`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x

# Access variables defined in your .smk rule
input_tsv             <- snakemake@input[["ancombc2_table"]]
volcano_png           <- snakemake@output[["volcano_plot"]]
heatmap_png           <- snakemake@output[["heatmap_plot"]]
legend_tsv            <- snakemake@output[["heatmap_legend"]]
volcano_sig_threshold <- snakemake@params[["volcano_sig_threshold"]] %||% 0.05
heatmap_top_n         <- snakemake@params[["heatmap_top_n"]]         %||% 30
group_col             <- snakemake@params[["group_col"]]             %||% ""

# Derive the prefix for any internal logic (stripping the suffix from volcano)
output_prefix <- gsub("_volcano\\.png$", "", volcano_png)

# Ensure output directories exist
dir.create(dirname(volcano_png), recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(heatmap_png), recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(legend_tsv), recursive = TRUE, showWarnings = FALSE)
# --- End Snakemake Integration ---

empty_white_plot <- function(path, width, height, res = 140, msg = "No significant taxa found") {
  png(path, width = width, height = height, res = res)
  par(mar = c(0, 0, 0, 0))
  plot.new()
  text(0.5, 0.5, msg, cex = 1.4, col = "grey40")
  dev.off()
}

empty_legend <- function() {
  write.table(data.frame(TaxaIndex = integer(0), TaxonDisplay = character(0),
                         TaxonFull = character(0), TaxonHash = character(0)),
              legend_tsv, sep = "\t", quote = FALSE, row.names = FALSE)
}

if (!file.exists(input_tsv) || file.size(input_tsv) == 0) {
  message("[ANCOMBC2-PLOT] Input TSV is empty or missing; writing empty plots.")
  empty_white_plot(volcano_png, 1200, 600)
  empty_white_plot(heatmap_png, 1500, 2100)
  empty_legend()
  quit(save = "no", status = 0)
}

df <- read.delim(input_tsv, check.names = FALSE, stringsAsFactors = FALSE)

ref_level <- if ("ref_level" %in% colnames(df)) df$ref_level[1] else "reference"
group_col <- if ("group_col" %in% colnames(df)) df$group_col[1] else group_col

extract_display_taxon <- function(x) {
  if (is.na(x) || x == "") return(NA_character_)
  parts <- trimws(strsplit(as.character(x), ";")[[1]])
  parts <- parts[parts != ""]
  if (length(parts) == 0) return(NA_character_)
  paste(parts, collapse = "; ")
}

lfc_cols <- grep("^lfc_", colnames(df), value = TRUE)
q_cols <- grep("^q_", colnames(df), value = TRUE)

contrast_lfc <- setdiff(lfc_cols, "lfc_(Intercept)")
contrast_q <- setdiff(q_cols, "q_(Intercept)")

if (length(contrast_lfc) == 0 || length(contrast_q) == 0) {
  message("[ANCOMBC2-PLOT] No contrast-specific lfc_/q_ columns found; writing empty plots.")
  empty_white_plot(volcano_png, 1200, 600, msg = "No significant taxa found")
  empty_white_plot(heatmap_png, 1500, 2100, msg = "No significant taxa found")
  write.table(data.frame(TaxaIndex = integer(0), TaxonDisplay = character(0),
                         TaxonFull = character(0), TaxonHash = character(0)),
              legend_tsv, sep = "\t", quote = FALSE, row.names = FALSE)
  quit(save = "no", status = 0)
}

contrast_names <- sub("^lfc_", "", contrast_lfc)
contrast_names <- contrast_names[contrast_names %in% sub("^q_", "", contrast_q)]

# Strip the group_col prefix to get the bare level name for display (e.g. "TimepointPost" → "Post")
contrast_labels <- if (nchar(group_col) > 0) sub(paste0("^", group_col), "", contrast_names) else contrast_names
contrast_labels <- ifelse(contrast_labels == "", contrast_names, contrast_labels)

if (length(contrast_names) == 0) {
  message("[ANCOMBC2-PLOT] No matched lfc_/q_ contrast pairs found; writing empty plots.")
  empty_white_plot(volcano_png, 1200, 600, msg = "No significant taxa found")
  empty_white_plot(heatmap_png, 1500, 2100, msg = "No significant taxa found")
  write.table(data.frame(TaxaIndex = integer(0), TaxonDisplay = character(0),
                         TaxonFull = character(0), TaxonHash = character(0)),
              legend_tsv, sep = "\t", quote = FALSE, row.names = FALSE)
  quit(save = "no", status = 0)
}

if (nrow(df) == 0) {
  message("[ANCOMBC2-PLOT] Input table is empty; writing empty plots.")
  empty_white_plot(volcano_png, 1200, 600, msg = "No significant taxa found")
  empty_white_plot(heatmap_png, 1500, 2100, msg = "No significant taxa found")
  write.table(data.frame(TaxaIndex = integer(0), TaxonDisplay = character(0),
                         TaxonFull = character(0), TaxonHash = character(0)),
              legend_tsv, sep = "\t", quote = FALSE, row.names = FALSE)
  quit(save = "no", status = 0)
}

panel_n <- length(contrast_names)
panel_cols <- min(2, panel_n)
panel_rows <- ceiling(panel_n / panel_cols)

png(volcano_png, width = 1200, height = 600 * panel_rows, res = 140)
par(mfrow = c(panel_rows, panel_cols), mar = c(5, 5, 3, 1))

for (i in seq_along(contrast_names)) {
  cn    <- contrast_names[i]
  label <- contrast_labels[i]

  lfc <- df[[paste0("lfc_", cn)]]
  qv  <- df[[paste0("q_",   cn)]]

  keep <- is.finite(lfc) & is.finite(qv) & qv > 0
  x <- lfc[keep]
  y <- -log10(qv[keep])

  sig  <- qv[keep] < volcano_sig_threshold
  cols <- ifelse(sig, "#D55E00", "#999999")

  plot(
    x,
    y,
    pch  = 16,
    col  = cols,
    cex  = 0.8,
    xlab = paste0("LFC (", label, " vs ", ref_level, ")"),
    ylab = "-log10(q)",
    main = paste0("ANCOMBC2: ", label, " vs ", ref_level)
  )
  abline(v = 0, lty = 2, col = "#444444")
  abline(h = -log10(volcano_sig_threshold), lty = 2, col = "#444444")
}

dev.off()

q_mat   <- as.matrix(df[, paste0("q_",   contrast_names), drop = FALSE])
lfc_mat <- as.matrix(df[, paste0("lfc_", contrast_names), drop = FALSE])
colnames(lfc_mat) <- paste0(contrast_labels, " vs ", ref_level)

rownames(lfc_mat) <- if ("FeatureID" %in% colnames(df)) {
  as.character(df$FeatureID)
} else {
  as.character(seq_len(nrow(df)))
}

min_q <- apply(q_mat, 1, function(v) {
  vv <- v[is.finite(v)]
  if (length(vv) == 0) return(1)
  min(vv)
})

ord <- order(min_q, decreasing = FALSE)
top_n <- min(heatmap_top_n, nrow(lfc_mat))
sel <- ord[seq_len(top_n)]

lfc_top <- lfc_mat[sel, , drop = FALSE]
lfc_top[!is.finite(lfc_top)] <- 0

taxon_full <- if ("Taxon" %in% colnames(df)) as.character(df$Taxon[sel]) else rep(NA_character_, length(sel))
taxon_hash <- if ("taxon" %in% colnames(df)) as.character(df$taxon[sel]) else as.character(rownames(lfc_top))
taxon_display <- vapply(taxon_full, extract_display_taxon, character(1))
taxon_display[is.na(taxon_display) | taxon_display == ""] <- taxon_hash[is.na(taxon_display) | taxon_display == ""]

taxa_index <- seq_len(nrow(lfc_top))
rownames(lfc_top) <- as.character(taxa_index)

legend_df <- data.frame(
  TaxaIndex = taxa_index,
  TaxonDisplay = taxon_display,
  TaxonFull = taxon_full,
  TaxonHash = taxon_hash,
  stringsAsFactors = FALSE
)
write.table(legend_df, legend_tsv, sep = "\t", quote = FALSE, row.names = FALSE)

draw_heatmap <- function(mat, main_title, taxa_labels) {
  nr <- nrow(mat)
  nc <- ncol(mat)

  z <- t(mat[nr:1, , drop = FALSE])
  zlim <- max(abs(z), na.rm = TRUE)
  if (!is.finite(zlim) || zlim == 0) zlim <- 1

  cols <- colorRampPalette(c("#2166AC", "#F7F7F7", "#B2182B"))(101)

  op <- par(no.readonly = TRUE)
  on.exit(par(op), add = TRUE)

  layout(matrix(c(1, 2, 3), nrow = 3, byrow = TRUE), heights = c(8, 1.8, 9.5))

  par(mar = c(8, 7, 4, 2))
  image(
    x = seq_len(nc),
    y = seq_len(nr),
    z = z,
    col = cols,
    zlim = c(-zlim, zlim),
    axes = FALSE,
    xlab = "",
    ylab = "",
    main = main_title
  )

  axis(1, at = seq_len(nc), labels = colnames(mat), las = 1, cex.axis = 0.75)
  axis(2, at = seq_len(nr), labels = rev(rownames(mat)), las = 2, cex.axis = 0.55)
  box()

  par(mar = c(3, 7, 0.5, 2))
  xseq <- seq(-zlim, zlim, length.out = length(cols) + 1)
  plot.new()
  plot.window(xlim = c(-zlim, zlim), ylim = c(0, 1))
  rect(xseq[-length(xseq)], 0, xseq[-1], 1, col = cols, border = NA)
  axis_ticks <- pretty(c(-zlim, zlim), n = 7)
  axis(1, at = axis_ticks, labels = format(axis_ticks, digits = 2), cex.axis = 0.8)
  mtext("LFC", side = 1, line = 2, cex = 0.85)
  box()

  par(mar = c(0.5, 2, 1.5, 2))
  plot.new()
  plot.window(xlim = c(0, 1), ylim = c(0, 1))
  title("Taxa index legend", line = 0.2, cex.main = 0.9)

  n <- length(taxa_labels)
  if (n > 0) {
    legend_cols <- if (n == 1) 1 else 2
    rows_per_col <- ceiling(n / legend_cols)

    legend_text <- paste0(seq_len(n), " = ", taxa_labels)

    top_y <- 0.94
    bottom_y <- 0.06
    usable_h <- top_y - bottom_y
    row_gap <- usable_h / max(rows_per_col - 1, 1)

    legend_cex <- 0.95
    min_cex <- 0.40
    left_x  <- 0.01
    max_x   <- 0.98

    # --- height-based shrink (2-column layout) ---
    txt_h <- strheight("M", cex = legend_cex, units = "user")
    while (legend_cex > min_cex && txt_h > row_gap * 0.90) {
      legend_cex <- legend_cex - 0.03
      txt_h <- strheight("M", cex = legend_cex, units = "user")
    }

    # --- decide whether 2 columns actually fit ---
    if (legend_cols > 1) {
      left_labels  <- legend_text[seq_len(rows_per_col)]
      right_labels <- legend_text[(rows_per_col + 1):n]
      max_left_w   <- max(strwidth(left_labels,  cex = legend_cex, units = "user"))
      max_right_w  <- max(strwidth(right_labels, cex = legend_cex, units = "user"))
      right_x      <- left_x + max_left_w + 0.03
      if (right_x + max_right_w > max_x) {
        # fall back to single column and recompute row spacing
        legend_cols  <- 1
        rows_per_col <- n
        row_gap      <- usable_h / max(rows_per_col - 1, 1)
        # re-shrink for new (tighter) row spacing
        while (legend_cex > min_cex &&
               strheight("M", cex = legend_cex, units = "user") > row_gap * 0.90) {
          legend_cex <- legend_cex - 0.03
        }
      }
    }

    # --- width-based shrink for the active layout ---
    active_labels <- legend_text[seq_len(rows_per_col)]
    while (legend_cex > min_cex &&
           max(strwidth(active_labels, cex = legend_cex, units = "user")) > max_x - left_x) {
      legend_cex <- legend_cex - 0.03
    }

    # --- truncate any labels that still overflow at min_cex ---
    col_w <- max_x - left_x
    legend_text <- vapply(legend_text, function(lbl) {
      while (nchar(lbl) > 5 &&
             strwidth(lbl, cex = legend_cex, units = "user") > col_w) {
        lbl <- paste0(substr(lbl, 1, nchar(lbl) - 4), "...")
      }
      lbl
    }, character(1))

    # --- recompute right_x with final cex / labels ---
    if (legend_cols > 1) {
      left_labels <- legend_text[seq_len(rows_per_col)]
      max_left_w  <- max(strwidth(left_labels, cex = legend_cex, units = "user"))
      right_x     <- left_x + max_left_w + 0.03
    }

    x_pos  <- ifelse(seq_len(n) <= rows_per_col, left_x, right_x)
    row_id <- ((seq_len(n) - 1) %% rows_per_col) + 1
    y_pos  <- if (rows_per_col == 1) {
      rep((top_y + bottom_y) / 2, n)
    } else {
      top_y - (row_id - 1) * row_gap
    }

    text(x_pos, y_pos, labels = legend_text, adj = c(0, 0.5), cex = legend_cex)
  }
}

png(heatmap_png, width = 1500, height = 2100, res = 140)
draw_heatmap(lfc_top, paste0("ANCOMBC2 LFC Heatmap — ref: ", ref_level, " (top features by min q)"), taxon_display)
dev.off()

cat("[ANCOMBC2-PLOT] Wrote:", volcano_png, "\n")
cat("[ANCOMBC2-PLOT] Wrote:", heatmap_png, "\n")
cat("[ANCOMBC2-PLOT] Wrote:", legend_tsv, "\n")