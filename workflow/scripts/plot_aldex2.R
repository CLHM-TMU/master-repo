suppressPackageStartupMessages({
  library(phyloseq)
  library(microbiomeMarker)
  library(ggplot2)
})

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x

OKABE_ITO <- c(
  "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7", "#000000",
  "#999999", "#332288"
)

# ---------- Snakemake bindings ----------
aldex2_rds    <- snakemake@input[["aldex2_rds"]]
metadata_path <- snakemake@input[["metadata"]]
heatmap_png   <- snakemake@output[["heatmap_png"]]
cladogram_svg <- snakemake@output[["cladogram_svg"]]
group_col     <- snakemake@params[["group_col"]]     %||% stop("group_col param not set")
heatmap_top_n <- snakemake@params[["heatmap_top_n"]] %||% 30

dir.create(dirname(heatmap_png),   recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(cladogram_svg), recursive = TRUE, showWarnings = FALSE)

# ---------- Helpers ----------
natural_level_order <- function(x) {
  pad_nums <- function(s) {
    parts <- strsplit(s, "(?<=\\D)(?=\\d)|(?<=\\d)(?=\\D)", perl = TRUE)[[1]]
    paste(ifelse(grepl("^\\d+$", parts),
                 formatC(as.integer(parts), width = 10, flag = "0"),
                 parts), collapse = "")
  }
  x[order(vapply(as.character(x), pad_nums, character(1)))]
}

empty_png <- function(path, msg = "No significant markers found") {
  png(path, width = 800, height = 400, res = 100)
  par(mar = c(0, 0, 0, 0))
  plot.new()
  text(0.5, 0.5, msg, cex = 1.4, col = "#555555")
  dev.off()
}

empty_svg <- function(path, msg = "No significant markers found") {
  svg(path, width = 8, height = 4)
  print(
    ggplot2::ggplot() +
      ggplot2::annotate("text", x = 0.5, y = 0.5, label = msg, size = 6, hjust = 0.5) +
      ggplot2::theme_void()
  )
  dev.off()
}

deduplicate_tax_table <- function(mm) {
  tt <- as.matrix(phyloseq::tax_table(mm))
  tt[] <- make.unique(as.vector(tt), sep = "_")
  slot(mm, "tax_table") <- phyloseq::tax_table(tt)
  mm
}

# ---------- Load results ----------
message("[ALDEx2] Loading RDS: ", aldex2_rds)
result <- readRDS(aldex2_rds)

n_markers <- result$n_markers %||% 0L
mm        <- result$mm   # NULL when n_markers == 0
message("[ALDEx2] Markers available: ", n_markers)

# ---------- Group color map ----------
meta   <- read.delim(metadata_path, header = TRUE, row.names = 1, sep = "\t",
                     check.names = FALSE, stringsAsFactors = FALSE,
                     quote = "", comment.char = "")
groups <- natural_level_order(as.character(unique(meta[[group_col]])))
colors <- setNames(OKABE_ITO[seq_along(groups)], groups)

# ============================================================
# HEATMAP — mean CLR abundance per group for top N markers
# ============================================================
if (n_markers == 0) {
  empty_png(heatmap_png)
} else {
  mt  <- as.data.frame(microbiomeMarker::marker_table(mm))

  # Pick top features by padj (ascending), then effect size (descending)
  mt_ord <- mt[order(mt$padj, -abs(mt$ef_aldex2)), ]
  top_features <- head(mt_ord$feature, heatmap_top_n)

  # Raw counts from the phyloseq object stored in the microbiomeMarker result
  otu_raw <- as.matrix(phyloseq::otu_table(mm))
  if (!phyloseq::taxa_are_rows(mm)) otu_raw <- t(otu_raw)

  # CLR transform (log-ratio with geometric mean per sample, pseudocount 0.5)
  clr_mat <- apply(otu_raw + 0.5, 2, function(s) log(s) - mean(log(s)))
  # clr_mat: taxa × samples

  # Subset to significant taxa present in the CLR matrix
  top_features <- top_features[top_features %in% rownames(clr_mat)]
  if (length(top_features) == 0) {
    empty_png(heatmap_png, "Top features not found in count table")
  } else {
    clr_top <- clr_mat[top_features, , drop = FALSE]

    # Compute per-group means
    sam_groups <- as.character(phyloseq::sample_data(mm)[[group_col]])
    group_levels <- natural_level_order(unique(sam_groups))
    clr_group <- sapply(group_levels, function(g)
      rowMeans(clr_top[, sam_groups == g, drop = FALSE]))
    # clr_group: taxa × groups

    # Enrichment annotation (which group each marker is enriched in)
    enrich_map <- setNames(mt$enrich_group, mt$feature)

    # Truncate long taxon labels for y-axis
    taxa_labels <- rownames(clr_group)

    nr   <- nrow(clr_group)
    nc   <- ncol(clr_group)
    zlim <- max(abs(clr_group), na.rm = TRUE)
    if (!is.finite(zlim) || zlim == 0) zlim <- 1

    cols <- colorRampPalette(c("#2166AC", "#F7F7F7", "#B2182B"))(101)

    # Dynamic figure height: more taxa = taller plot
    fig_h <- max(1600, nr * 45 + 400)

    png(heatmap_png, width = 1400, height = fig_h, res = 140)

    op <- par(no.readonly = TRUE)
    on.exit(par(op))

    layout(matrix(c(1, 2), nrow = 2), heights = c(fig_h - 280, 280))

    # Panel 1 — heatmap
    par(mar = c(1, 8, 4, 10))
    image(
      x = seq_len(nc),
      y = seq_len(nr),
      z = t(clr_group[nr:1, , drop = FALSE]),
      col  = cols,
      zlim = c(-zlim, zlim),
      axes = FALSE,
      xlab = "", ylab = "",
      main = paste0("ALDEx2 Mean CLR Heatmap — top ", nr, " markers")
    )
    axis(1, at = seq_len(nc), labels = colnames(clr_group), las = 1, cex.axis = 0.85)

    # Y-axis: truncated taxon labels
    max_label_chars <- 60
    display_labels <- rev(taxa_labels)
    display_labels <- ifelse(
      nchar(display_labels) > max_label_chars,
      paste0(substr(display_labels, 1, max_label_chars - 3), "..."),
      display_labels
    )
    axis(2, at = seq_len(nr), labels = display_labels, las = 2, cex.axis = 0.5)

    # Right axis: enriched group annotation
    enrich_labels <- rev(enrich_map[taxa_labels])
    enrich_labels[is.na(enrich_labels)] <- ""
    enrich_cols   <- colors[enrich_labels]
    enrich_cols[is.na(enrich_cols)] <- "#888888"
    axis(4, at = seq_len(nr), labels = enrich_labels, las = 2,
         cex.axis = 0.6, col.axis = "black", tick = FALSE)
    # Colored rectangles on right margin to highlight enrichment
    for (i in seq_len(nr)) {
      rect(nc + 0.5, i - 0.4, nc + 0.9, i + 0.4,
           col = enrich_cols[i], border = NA, xpd = TRUE)
    }

    # Group color legend (top-right)
    legend("topright", legend = names(colors), fill = colors,
           border = NA, bty = "n", cex = 0.75, inset = c(-0.07, 0), xpd = TRUE)

    box()

    # Panel 2 — color scale bar
    par(mar = c(4, 8, 1, 10))
    xseq <- seq(-zlim, zlim, length.out = length(cols) + 1)
    plot.new()
    plot.window(xlim = c(-zlim, zlim), ylim = c(0, 1))
    rect(xseq[-length(xseq)], 0, xseq[-1], 1, col = cols, border = NA)
    ticks <- pretty(c(-zlim, zlim), n = 7)
    axis(1, at = ticks, labels = format(ticks, digits = 2), cex.axis = 0.85)
    mtext("Mean CLR abundance", side = 1, line = 2.5, cex = 0.9)
    box()

    dev.off()
    message("[ALDEx2] Heatmap written: ", heatmap_png)
  }
}

# ============================================================
# CLADOGRAM
# ============================================================
message("[ALDEx2] Writing cladogram -> ", cladogram_svg)

svg(cladogram_svg, width = 12, height = 12)
if (n_markers == 0) {
  print(
    ggplot2::ggplot() +
      ggplot2::annotate("text", x = 0.5, y = 0.5,
                        label = "No significant markers found", size = 6, hjust = 0.5) +
      ggplot2::theme_void()
  )
} else {
  tryCatch(
    print(microbiomeMarker::plot_cladogram(mm, color = colors)),
    error = function(e) {
      if (grepl("duplicated", conditionMessage(e), ignore.case = TRUE)) {
        message("[ALDEx2] Retrying cladogram with deduplicated taxonomy...")
        tryCatch(
          print(microbiomeMarker::plot_cladogram(deduplicate_tax_table(mm), color = colors)),
          error = function(e2) {
            message("[ALDEx2] Cladogram failed (", conditionMessage(e2), "); writing placeholder.")
            print(
              ggplot2::ggplot() +
                ggplot2::annotate("text", x = 0.5, y = 0.5,
                                  label = paste("Cladogram failed:", conditionMessage(e2)),
                                  size = 4, hjust = 0.5) +
                ggplot2::theme_void()
            )
          }
        )
      } else {
        message("[ALDEx2] Cladogram failed (", conditionMessage(e), "); writing placeholder.")
        print(
          ggplot2::ggplot() +
            ggplot2::annotate("text", x = 0.5, y = 0.5,
                              label = paste("Cladogram failed:", conditionMessage(e)),
                              size = 4, hjust = 0.5) +
            ggplot2::theme_void()
        )
      }
    }
  )
}
dev.off()

message("[ALDEx2] Cladogram written: ", cladogram_svg)
message("[ALDEx2] Plotting done.")
