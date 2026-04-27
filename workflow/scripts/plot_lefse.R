suppressPackageStartupMessages({
  library(microbiomeMarker)
  library(ggplot2)
  library(ggtree)
})

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x

OKABE_ITO <- c(
  "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7", "#000000",
  "#999999", "#332288"
)

# ---------- Snakemake bindings ----------
lefse_rds     <- snakemake@input[["lefse_rds"]]
metadata_path <- snakemake@input[["metadata"]]
taxonomy_path <- snakemake@input[["taxonomy"]]
lda_svg       <- snakemake@output[["lda_svg"]]
cladogram_svg <- snakemake@output[["cladogram_svg"]]
group_col     <- snakemake@params[["group_col"]] %||% stop("group_col param not set")

dir.create(dirname(lda_svg), recursive = TRUE, showWarnings = FALSE)

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

empty_plot <- function(msg = "No significant markers found") {
  ggplot2::ggplot() +
    ggplot2::annotate("text", x = 0.5, y = 0.5, label = msg, size = 6, hjust = 0.5) +
    ggplot2::theme_void()
}

# ---------- Build color map ----------
meta   <- read.delim(metadata_path, header = TRUE, row.names = 1, sep = "\t",
                     check.names = FALSE, stringsAsFactors = FALSE,
                     quote = "", comment.char = "")
groups <- natural_level_order(as.character(unique(meta[[group_col]])))
colors <- setNames(OKABE_ITO[seq_along(groups)], groups)

# ---------- Robust marker_table -> data.frame coercion --------------------
marker_table_to_df <- function(mt_raw) {
  cols <- lapply(colnames(mt_raw), function(cn) as.vector(mt_raw[[cn]]))
  names(cols) <- colnames(mt_raw)
  df <- as.data.frame(cols, stringsAsFactors = FALSE)
  score_col <- intersect(c("ef_lda_score", "ef_lda", "lda_score", "score"), names(df))[1]
  if (!is.na(score_col))
    df[[score_col]] <- as.numeric(df[[score_col]])
  df
}

# ---------- Detect finest rank from marker table features -----------------
# Inspects the terminal token of each feature string to determine what rank
# run_lefse was called with (e.g. "genus", "species"). Works for both bare
# tokens ("g__Lactobacillus") and pipe/semicolon-delimited paths.
detect_finest_rank <- function(features) {
  rank_map <- c(s = "species", g = "genus",  f = "family",
                o = "order",   c = "class",   p = "phylum",
                d = "kingdom", k = "kingdom")
  terminal_prefixes <- vapply(features, function(f) {
    parts <- strsplit(f, "[;|]")[[1]]
    last  <- trimws(tail(parts, 1L))
    sub("^([a-z]+)__.*", "\\1", last)
  }, character(1L))
  most_common <- names(sort(table(terminal_prefixes), decreasing = TRUE))[1]
  rank_val <- rank_map[most_common]
  rank <- if (!is.na(rank_val) && length(rank_val) > 0) unname(rank_val) else "genus"
  message("[LEfSe] Detected finest rank in marker features: ", rank,
          " (prefix '", most_common, "__')")
  rank
}

# ---------- Build lineage lookup ------------------------------------------
# Maps terminal rank token -> full pipe-delimited lineage path trimmed to
# that rank. Adapts to whatever finest_rank was detected so it works for
# both genus-level (V3V4) and species-level (full-length) data.
build_lineage_lookup <- function(taxonomy_path, finest_rank = "genus") {
  message("[LEfSe] Building lineage lookup from: ", taxonomy_path,
          " (finest_rank = '", finest_rank, "')")

  tax_df  <- read.delim(taxonomy_path, header = TRUE, row.names = 1, sep = "\t",
                        check.names = FALSE, stringsAsFactors = FALSE,
                        quote = "", comment.char = "")

  message("[LEfSe] tax_df dim: ", nrow(tax_df), " x ", ncol(tax_df))
  message("[LEfSe] tax_df colnames: ", paste(colnames(tax_df), collapse = ", "))

  tax_col <- intersect(c("Taxon", "taxonomy"), colnames(tax_df))[1]
  if (is.na(tax_col)) {
    message("[LEfSe] No Taxon/taxonomy column found; lineage lookup will be empty.")
    return(NULL)
  }

  rank_prefix <- switch(finest_rank,
    species = "s__",
    genus   = "g__",
    family  = "f__",
    order   = "o__",
    class   = "c__",
    phylum  = "p__",
    "g__"   # fallback
  )

  tax_vec <- trimws(as.character(tax_df[[tax_col]]))
  fields  <- strsplit(tax_vec, ";\\s*")

  # Key = the token at finest_rank level
  extract_key <- function(parts) {
    parts <- trimws(parts)
    hit   <- parts[grepl(paste0("^", rank_prefix), parts)]
    if (length(hit) == 0) return(NA_character_)
    hit[1]
  }

  # Value = full lineage trimmed to finest_rank (drops deeper ranks like species
  # when genus is the target, preserves species when species is the target)
  trim_to_rank <- function(parts) {
    parts     <- trimws(parts)
    rank_idx  <- which(grepl(paste0("^", rank_prefix), parts))
    if (length(rank_idx) == 0) return(paste(parts, collapse = "|"))
    paste(parts[seq_len(rank_idx[1])], collapse = "|")
  }

  keys <- vapply(fields, extract_key, character(1L))
  vals <- vapply(fields, trim_to_rank, character(1L))

  valid  <- !is.na(keys) & nchar(keys) > 0
  lookup <- setNames(vals[valid], keys[valid])
  lookup <- lookup[!duplicated(names(lookup))]
  message("[LEfSe] Lineage lookup built: ", length(lookup),
          " unique entries at ", finest_rank, " level")
  lookup
}

# ---------- Build lineage lookup from tax_table ---------------------------
# Primary lookup source: reconstructs full lineage paths directly from the
# tax_table inside the microbiomeMarker object. After run_lefse aggregates to
# e.g. genus level, tax_table rownames ARE the genus tokens LEfSe reports as
# marker features, so the keys are guaranteed to match — no external file
# dependency and no string-format mismatch possible.
build_lineage_lookup_from_tax_table <- function(mm, finest_rank = "genus") {
  tt <- tryCatch(
    as.data.frame(phyloseq::tax_table(mm), stringsAsFactors = FALSE),
    error = function(e) NULL
  )
  if (is.null(tt) || nrow(tt) == 0) {
    message("[LEfSe] tax_table is empty or unavailable.")
    return(NULL)
  }

  RANK_ORDER <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
  finest_std <- switch(finest_rank,
    kingdom = "Kingdom", phylum = "Phylum", class   = "Class",
    order   = "Order",   family = "Family", genus   = "Genus",
    species = "Species", "Genus"
  )

  avail_ranks <- intersect(RANK_ORDER, colnames(tt))
  target_idx  <- match(finest_std, avail_ranks)
  if (is.na(target_idx)) {
    message("[LEfSe] Rank '", finest_std, "' not found in tax_table columns (",
            paste(avail_ranks, collapse = ", "), "); skipping tax_table lookup.")
    return(NULL)
  }

  ranks_to_use <- avail_ranks[seq_len(target_idx)]
  genus_col    <- as.character(tt[[finest_std]])

  lineages <- apply(tt[, ranks_to_use, drop = FALSE], 1, function(row) {
    parts <- trimws(as.character(row))
    parts <- parts[!is.na(parts) & nchar(parts) > 0]
    paste(parts, collapse = "|")
  })

  valid  <- !is.na(genus_col) & nchar(trimws(genus_col)) > 0
  lookup <- setNames(lineages[valid], genus_col[valid])
  lookup <- lookup[!duplicated(names(lookup))]
  message("[LEfSe] Lineage lookup from tax_table: ", length(lookup),
          " unique entries at ", finest_rank, " level")
  lookup
}

# ---------- Normalize feature delimiters ----------------------------------
# Genus-collapsed BIOM uses semicolons; microbiomeMarker internal paths use
# pipes. Normalize everything to "|" before parsing.
normalize_feature_delimiters <- function(features) {
  is_semicolon <- mean(grepl(";", features, fixed = TRUE)) > 0.5
  is_pipe      <- mean(grepl("|", features, fixed = TRUE)) > 0.5
  if (is_semicolon && !is_pipe) {
    message("[LEfSe][cladogram] Detected semicolon-delimited features; normalizing to '|'.")
    features <- gsub(";\\s*", "|", features)
  }
  features
}

# ---------- Reconstruct lineage paths -------------------------------------
# Expands bare terminal tokens (e.g. "g__Lactobacillus") into full lineage
# paths (e.g. "d__Bacteria|p__Firmicutes|...|g__Lactobacillus") using the
# lookup built from the taxonomy TSV.
reconstruct_lineage <- function(features, lineage_lookup) {
  reconstructed <- vapply(features, function(g) {
    val <- lineage_lookup[g]
    if (!is.na(val)) unname(val) else g
  }, character(1L))

  n_found   <- sum(reconstructed != features)
  n_missing <- sum(reconstructed == features)
  message("[LEfSe][cladogram] Lineage reconstruction: ",
          n_found, " expanded, ", n_missing, " not found in lookup (kept as-is).")
  if (n_missing > 0)
    message("[LEfSe][cladogram] Unmatched tokens: ",
            paste(head(features[reconstructed == features], 10), collapse = ", "))
  reconstructed
}

# ---------- ggtree-based cladogram ----------------------------------------
try_cladogram <- function(mm, colors, lineage_lookup = NULL) {
  message("[LEfSe][cladogram] --- entering try_cladogram (ggtree) ---")

  mt_raw <- microbiomeMarker::marker_table(mm)
  message("[LEfSe][cladogram] marker_table class: ", paste(class(mt_raw), collapse = ", "))
  message("[LEfSe][cladogram] marker_table colnames: ", paste(colnames(mt_raw), collapse = ", "))

  mt <- marker_table_to_df(mt_raw)
  message("[LEfSe][cladogram] mt colnames after coercion: ", paste(colnames(mt), collapse = ", "))
  message("[LEfSe][cladogram] marker_table rows: ", nrow(mt))

  if (nrow(mt) == 0) {
    message("[LEfSe][cladogram] No markers; returning empty plot.")
    return(empty_plot())
  }

  # Detect column names defensively across microbiomeMarker versions
  feat_col     <- intersect(c("feature", "Feature"), colnames(mt))[1]
  group_col_mt <- intersect(c("enrich_group", "enriched_group"), colnames(mt))[1]
  score_col    <- intersect(c("ef_lda_score", "ef_lda", "lda_score", "score"), colnames(mt))[1]

  message("[LEfSe][cladogram] using columns -> feature='", feat_col,
          "' group='", group_col_mt, "' score='", score_col, "'")

  if (any(is.na(c(feat_col, group_col_mt, score_col)))) {
    stop("Could not detect required columns in marker_table. ",
         "Found: ", paste(colnames(mt), collapse = ", "))
  }

  # ---- 1. Normalize delimiters -------------------------------------------
  ROOT         <- "r__Root"
  raw_features <- normalize_feature_delimiters(mt[[feat_col]])

  message("[LEfSe][cladogram] feat_col raw sample (first 3):")
  message(paste(head(mt[[feat_col]], 3), collapse = "\n"))
  message("[LEfSe][cladogram] after delimiter normalization (first 3):")
  message(paste(head(raw_features, 3), collapse = "\n"))

  # ---- 2. Reconstruct full lineage if features are bare terminal tokens --
  max_depth <- max(vapply(strsplit(raw_features, "|", fixed = TRUE), length, integer(1)))
  message("[LEfSe][cladogram] max lineage depth before reconstruction: ", max_depth)

  if (max_depth <= 1L) {
    if (!is.null(lineage_lookup)) {
      message("[LEfSe][cladogram] Bare terminal tokens detected; reconstructing lineage paths.")
      raw_features <- reconstruct_lineage(raw_features, lineage_lookup)
      message("[LEfSe][cladogram] after reconstruction (first 3):")
      message(paste(head(raw_features, 3), collapse = "\n"))
      max_depth <- max(vapply(strsplit(raw_features, "|", fixed = TRUE), length, integer(1)))
      message("[LEfSe][cladogram] max lineage depth after reconstruction: ", max_depth)
    }
    if (max_depth <= 1L) {
      message("[LEfSe][cladogram] Features still have no lineage depth after reconstruction; ",
              "cladogram is uninformative. Returning explanatory plot.")
      return(empty_plot(
        "Cladogram unavailable: features have no lineage depth.\nSee LDA bar plot."
      ))
    }
  }
  # ---- 3. Parse taxonomy paths into an edge list -------------------------
  all_paths <- strsplit(raw_features, "|", fixed = TRUE)

  edges <- lapply(all_paths, function(parts) {
    nodes <- c(ROOT, parts)
    data.frame(
      parent = nodes[-length(nodes)],
      child  = nodes[-1L],
      stringsAsFactors = FALSE
    )
  })
  edge_df <- unique(do.call(rbind, edges))
  message("[LEfSe][cladogram] unique edges: ", nrow(edge_df))

  # ---- 4. Build an ape::phylo object -------------------------------------
  children  <- setdiff(edge_df$child, edge_df$parent)
  internals <- setdiff(unique(c(edge_df$parent, edge_df$child)), children)

  ordered_nodes <- c(children, internals)
  node_index    <- setNames(seq_along(ordered_nodes), ordered_nodes)
  n_nodes       <- length(internals)

  phy_edges <- matrix(
    c(node_index[edge_df$parent], node_index[edge_df$child]),
    ncol = 2
  )

  phy <- structure(
    list(
      edge        = phy_edges,
      tip.label   = children,
      node.label  = internals,
      Nnode       = n_nodes,
      edge.length = rep(1, nrow(phy_edges))
    ),
    class = "phylo"
  )

  message("[LEfSe][cladogram] phylo tips: ", length(phy$tip.label),
          "  internal nodes: ", phy$Nnode)

  # ---- 5. Build annotation data.frame ------------------------------------
  leaf_tokens <- vapply(
    strsplit(raw_features, "|", fixed = TRUE),
    function(x) tail(x, 1L),
    character(1L)
  )

  mt_slim <- data.frame(
    label        = leaf_tokens,
    enrich_group = mt[[group_col_mt]],
    ef_lda_score = mt[[score_col]],
    stringsAsFactors = FALSE
  )

  message("[LEfSe][cladogram] mt_slim rows: ", nrow(mt_slim))
  message("[LEfSe][cladogram] ordered_nodes length: ", length(ordered_nodes))
  message("[LEfSe][cladogram] leaf overlap: ",
          sum(ordered_nodes %in% mt_slim$label), " / ", nrow(mt_slim))

  node_info <- data.frame(label = ordered_nodes, stringsAsFactors = FALSE)
  idx       <- match(node_info$label, mt_slim$label)
  node_info$enrich_group <- mt_slim$enrich_group[idx]
  node_info$ef_lda_score <- mt_slim$ef_lda_score[idx]

  message("[LEfSe][cladogram] node_info rows: ", nrow(node_info),
          "  annotated: ", sum(!is.na(node_info$enrich_group)))

  # ---- 6. Color internal nodes (unanimous-group rule) --------------------
  if (requireNamespace("phangorn", quietly = TRUE)) {
    get_descendant_groups <- function(node_name) {
      idx_phy   <- node_index[[node_name]]
      desc_tips <- tryCatch(
        phangorn::Descendants(phy, idx_phy, type = "tips")[[1]],
        error = function(e) integer(0)
      )
      if (length(desc_tips) == 0) return(NA_character_)
      tip_labels  <- phy$tip.label[desc_tips]
      groups_here <- unique(mt_slim$enrich_group[mt_slim$label %in% tip_labels])
      groups_here <- groups_here[!is.na(groups_here)]
      if (length(groups_here) == 1L) groups_here else NA_character_
    }

    internal_mask <- node_info$label %in% internals & is.na(node_info$enrich_group)
    node_info$enrich_group[internal_mask] <- vapply(
      node_info$label[internal_mask], get_descendant_groups, character(1L)
    )
    message("[LEfSe][cladogram] after internal coloring, annotated: ",
            sum(!is.na(node_info$enrich_group)))
  }

  # ---- 7. Subset colors to groups present --------------------------------
  enrich_groups <- unique(stats::na.omit(node_info$enrich_group))
  colors_sub    <- colors[names(colors) %in% enrich_groups]
  missing       <- setdiff(enrich_groups, names(colors_sub))
  if (length(missing) > 0) {
    colors_sub <- c(colors_sub,
                    setNames(OKABE_ITO[seq(length(colors_sub) + 1L,
                                          length(colors_sub) + length(missing))],
                             missing))
  }
  message("[LEfSe][cladogram] color map: ",
          paste(names(colors_sub), colors_sub, sep = "=", collapse = ", "))

  # ---- 8. Short labels (strip rank prefix) --------------------------------
  node_info$short_label <- sub("^[a-z]__", "", node_info$label)
  node_info$short_label[node_info$label == ROOT] <- "Root"

  # ---- 9. Draw with ggtree -----------------------------------------------
  p <- ggtree::ggtree(phy, layout = "circular", branch.length = "none") %<+%
    node_info +
    ggtree::geom_point2(
      ggplot2::aes(color = enrich_group, size = ef_lda_score),
      na.rm = TRUE
    ) +
    ggtree::geom_tiplab2(
      ggplot2::aes(label = short_label, color = enrich_group),
      size = 2.5, offset = 0.3, na.rm = TRUE
    ) +
    ggplot2::scale_color_manual(
      values       = colors_sub,
      na.value     = "grey70",
      name         = group_col,
      na.translate = FALSE
    ) +
    ggplot2::scale_size_continuous(
      name  = "LDA score",
      range = c(1, 6)
    ) +
    ggplot2::theme(
      legend.position = "right",
      plot.background = ggplot2::element_rect(fill = "white", color = NA)
    )

  p
}

# =============================================================================
# MAIN
# =============================================================================

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

# ---------- Detect finest rank and build lineage lookup -------------------
# Done here in MAIN so the lookup is built once and passed into try_cladogram,
# rather than being rebuilt inside the plotting function.
finest_rank <- if (n_markers > 0) {
  mt_preview  <- marker_table_to_df(microbiomeMarker::marker_table(mm))
  feat_col_p  <- intersect(c("feature", "Feature"), colnames(mt_preview))[1]
  detect_finest_rank(mt_preview[[feat_col_p]])
} else {
  "genus"
}

# Prefer tax_table inside mm: its rownames are the exact genus tokens LEfSe
# reports, so keys are guaranteed to match. Fall back to the taxonomy TSV for
# edge cases where tax_table is missing or lacks rank columns (e.g. ASV-level
# runs that were not aggregated).
lineage_lookup <- if (n_markers > 0) {
  build_lineage_lookup_from_tax_table(mm, finest_rank = finest_rank) %||%
    build_lineage_lookup(taxonomy_path, finest_rank = finest_rank)
} else {
  NULL
}

# ---------- LDA bar plot ----------
message("[LEfSe] Writing LDA bar plot -> ", lda_svg)
p_lda <- if (n_markers == 0) {
  empty_plot()
} else {
  microbiomeMarker::plot_ef_bar(mm) +
    ggplot2::scale_fill_manual(values  = colors, breaks = names(colors)) +
    ggplot2::scale_color_manual(values = colors, breaks = names(colors)) +
    ggplot2::theme_bw(base_size = 12)
}

svg(lda_svg, width = 10, height = max(4, n_markers * 0.3 + 2))
print(p_lda)
dev.off()

# ---------- Cladogram ----------
message("[LEfSe] Writing cladogram -> ", cladogram_svg)
svg(cladogram_svg, width = 16, height = 16)
if (n_markers == 0) {
  print(empty_plot())
} else {
  p_clado <- tryCatch(
    try_cladogram(mm, colors, lineage_lookup = lineage_lookup),
    error = function(e) {
      message("[LEfSe] Cladogram failed (", conditionMessage(e),
              "); falling back to LDA bar plot.")
      message(paste(capture.output(traceback()), collapse = "\n"))
      p_lda
    }
  )
  print(p_clado)
}
dev.off()

message("[LEfSe] Plotting done.")