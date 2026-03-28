suppressPackageStartupMessages({
  library(microbiomeMarker)
  library(ggplot2)
})

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x

# tab10 palette to match the original Python seaborn tab10 colors
TAB10 <- c(
  "#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd",
  "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"
)

# ---------- Snakemake bindings ----------
lefse_rds     <- snakemake@input[["lefse_rds"]]
metadata_path <- snakemake@input[["metadata"]]
lda_svg       <- snakemake@output[["lda_svg"]]
cladogram_svg <- snakemake@output[["cladogram_svg"]]
group_col     <- snakemake@params[["group_col"]] %||% stop("group_col param not set")

dir.create(dirname(lda_svg), recursive = TRUE, showWarnings = FALSE)

empty_plot <- function(msg = "No significant markers found") {
  ggplot2::ggplot() +
    ggplot2::annotate("text", x = 0.5, y = 0.5, label = msg, size = 6, hjust = 0.5) +
    ggplot2::theme_void()
}

# ---------- Build color map (matches original Python get_colors order) ----------
meta   <- read.delim(metadata_path, header = TRUE, row.names = 1, sep = "\t",
                     check.names = FALSE, stringsAsFactors = FALSE,
                     quote = "", comment.char = "")
groups <- as.character(unique(meta[[group_col]]))
colors <- setNames(TAB10[seq_along(groups)], groups)

# ---------- Load results ----------
message("[LEfSe] Loading results: ", lefse_rds)
mm <- tryCatch(readRDS(lefse_rds), error = function(e) {
  message("[LEfSe] Failed to load RDS (", conditionMessage(e), "); writing empty plots.")
  NULL
})

if (is.null(mm)) {
  svg(lda_svg, width = 10, height = 4); print(empty_plot()); dev.off()
  svg(cladogram_svg, width = 12, height = 12); print(empty_plot()); dev.off()
  message("[LEfSe] Empty plots written.")
  quit(save = "no", status = 0)
}

n_markers <- tryCatch(nrow(microbiomeMarker::marker_table(mm)) %||% 0L,
                      error = function(e) 0L)
message("[LEfSe] Markers to plot: ", n_markers)

# ---------- LDA bar plot ----------
message("[LEfSe] Writing LDA bar plot -> ", lda_svg)
p_lda <- if (n_markers == 0) {
  empty_plot()
} else {
  microbiomeMarker::plot_ef_bar(mm) + ggplot2::theme_bw(base_size = 12)
}

svg(lda_svg, width = 10, height = max(4, n_markers * 0.3 + 2))
print(p_lda)
dev.off()

# Remove taxa whose |‑delimited path produces duplicate rank prefixes inside
# get_treedata_phyloseq's factor(levels = rev(prefix)) call.
# These arise from microbiomeMarker's internal ancestor-node expansion, e.g.
# "d__Bacteria|d__Bacteria_" where both elements extract prefix "d".
# Uses direct slot assignment to avoid phyloseq accessor coercion.
remove_dup_prefix_taxa <- function(mm) {
  tt_data <- phyloseq::tax_table(mm)@.Data
  col1    <- tt_data[, 1]

  message("[LEfSe][filter] tax_table has ", nrow(tt_data), " taxa x ", ncol(tt_data), " ranks")
  message("[LEfSe][filter] taxa_names (first 10): ",
          paste(head(rownames(tt_data), 10), collapse = " | "))
  message("[LEfSe][filter] duplicated taxa_names before filter: ",
          sum(duplicated(rownames(tt_data))))

  rank_prefix <- function(p) {
    if (grepl("__$", p)) substr(p, nchar(p) - 2L, nchar(p) - 2L)
    else                  gsub("(.*)__.*", "\\1", p)
  }

  has_dup <- vapply(col1, function(path) {
    parts    <- c("r__Root", strsplit(path, "|", fixed = TRUE)[[1]])
    prefixes <- vapply(parts, rank_prefix, character(1L))
    any(duplicated(prefixes))
  }, logical(1L))

  if (any(has_dup)) {
    dup_paths <- col1[has_dup]
    message("[LEfSe][filter] ", sum(has_dup), " taxa flagged for duplicate rank prefixes.")
    for (i in seq_along(dup_paths)) {
      path  <- dup_paths[[i]]
      parts <- c("r__Root", strsplit(path, "|", fixed = TRUE)[[1]])
      pfx   <- vapply(parts, rank_prefix, character(1L))
      dups  <- pfx[duplicated(pfx)]
      message("[LEfSe][filter]   [", i, "] path=", path)
      message("[LEfSe][filter]       prefixes=", paste(pfx, collapse = ", "),
              "  => duplicated=", paste(unique(dups), collapse = ", "))
    }
  } else {
    message("[LEfSe][filter] No taxa with duplicate rank prefixes found.")
    return(mm)
  }

  keep <- !has_dup
  message("[LEfSe] Filtering ", sum(has_dup), " taxa with ambiguous rank prefixes.")
  message("[LEfSe][filter] Keeping ", sum(keep), " / ", length(keep), " taxa after filter.")

  tt_kept <- tt_data[keep, , drop = FALSE]
  message("[LEfSe][filter] duplicated taxa_names after filter: ",
          sum(duplicated(rownames(tt_kept))))
  if (any(duplicated(rownames(tt_kept)))) {
    dups <- rownames(tt_kept)[duplicated(rownames(tt_kept))]
    message("[LEfSe][filter] WARN: still-duplicated names: ", paste(dups, collapse = " | "))
  }

  slot(mm, "tax_table") <- phyloseq::tax_table(tt_kept)
  ot <- slot(mm, "otu_table")
  slot(mm, "otu_table") <- if (phyloseq::taxa_are_rows(ot)) ot[keep, ] else ot[, keep]
  mm
}

try_cladogram <- function(mm, colors) {
  message("[LEfSe][cladogram] --- entering try_cladogram ---")
  message("[LEfSe][cladogram] markers before prefix filter: ",
          nrow(microbiomeMarker::marker_table(mm)))

  mm <- remove_dup_prefix_taxa(mm)

  message("[LEfSe][cladogram] markers after prefix filter: ",
          nrow(microbiomeMarker::marker_table(mm)))

  tt_after <- phyloseq::tax_table(mm)@.Data
  message("[LEfSe][cladogram] tax_table after filter: ",
          nrow(tt_after), " taxa x ", ncol(tt_after), " ranks")
  message("[LEfSe][cladogram] taxa_names duplicates after filter: ",
          sum(duplicated(rownames(tt_after))))

  # Inspect all col1 paths to check for other sources of duplicated leaf names
  col1 <- tt_after[, 1]
  leaf_names <- vapply(col1, function(p) {
    parts <- strsplit(p, "|", fixed = TRUE)[[1]]
    tail(parts, 1)
  }, character(1L))
  message("[LEfSe][cladogram] duplicated leaf tokens in col1 paths: ",
          sum(duplicated(leaf_names)))
  if (any(duplicated(leaf_names))) {
    dup_leaves <- leaf_names[duplicated(leaf_names)]
    message("[LEfSe][cladogram] duplicated leaf tokens: ",
            paste(unique(dup_leaves), collapse = " | "))
  }

  # Subset colors to only the groups that actually appear in the marker table;
  # plot_cladogram requires length(color) == length(unique(enrich_group)).
  enrich_groups <- unique(as.character(microbiomeMarker::marker_table(mm)[["enrich_group"]]))
  message("[LEfSe][cladogram] enrich_groups present: ", paste(enrich_groups, collapse = ", "))
  colors_sub    <- colors[names(colors) %in% enrich_groups]
  missing       <- setdiff(enrich_groups, names(colors_sub))
  if (length(missing) > 0) {
    message("[LEfSe][cladogram] assigning fallback colors for missing groups: ",
            paste(missing, collapse = ", "))
    colors_sub <- c(colors_sub, setNames(TAB10[seq(length(colors_sub) + 1,
                                                    length(colors_sub) + length(missing))],
                                         missing))
  }
  message("[LEfSe][cladogram] color map: ",
          paste(names(colors_sub), colors_sub, sep = "=", collapse = ", "))

  message("[LEfSe][cladogram] calling plot_cladogram ...")
  tryCatch(
    print(microbiomeMarker::plot_cladogram(mm, color = colors_sub, only_marker = TRUE)),
    error = function(e) {
      message("[LEfSe] Cladogram failed (", conditionMessage(e), "); writing LDA bar instead.")
      message("[LEfSe][cladogram] Full traceback:")
      message(paste(capture.output(traceback()), collapse = "\n"))
      print(p_lda)
    }
  )
}

# ---------- Cladogram ----------
message("[LEfSe] Writing cladogram -> ", cladogram_svg)
svg(cladogram_svg, width = 12, height = 12)
if (n_markers == 0) {
  print(empty_plot())
} else {
  try_cladogram(mm, colors)
}
dev.off()

message("[LEfSe] Plotting done.")
