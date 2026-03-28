suppressPackageStartupMessages({
  library(biomformat)
  library(phyloseq)
  library(microbiomeMarker)
})

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x

# Patch microbiomeMarker::run_lefse to fix a crash when no features pass the
# Kruskal-Wallis test: map2_lgl(sig_otus, names(sig_otus)) fails because
# vctrs::vec_size(data.frame) == nrow (19 samples) while length(names) == 0.
# The function already has the right handler downstream — it just never reaches it.
local({
  fn       <- get("run_lefse", envir = getNamespace("microbiomeMarker"))
  fn_lines <- deparse(fn, control = "all")
  target   <- grep("sig_otus\\s*<-\\s*otus_test\\[\\s*,\\s*sig_ind\\s*\\]", fn_lines)
  if (length(target) == 1) {
    # Replace the original line (drop=TRUE by default → vector when 1 feature passes)
    # with drop=FALSE so sig_otus is always a data frame, then add the early-exit guard.
    replacement <- c(
      "    sig_otus <- otus_test[, sig_ind, drop = FALSE]",
      "    if (ncol(sig_otus) == 0) {",
      "        warning(\"No marker was identified\", call. = FALSE)",
      "        return(microbiomeMarker(marker_table = NULL,",
      "            norm_method = get_norm_method(norm), diff_method = \"lefse\",",
      "            otu_table = otu_table(otus, taxa_are_rows = TRUE),",
      "            sam_data = sample_data(ps_normed), tax_table = tax))",
      "    }"
    )
    fn_lines  <- c(fn_lines[seq_len(target - 1L)], replacement,
                   fn_lines[seq(target + 1L, length(fn_lines))])
    fn_patched <- eval(parse(text = paste(fn_lines, collapse = "\n")))
    environment(fn_patched) <- environment(fn)
    utils::assignInNamespace("run_lefse", fn_patched, "microbiomeMarker")
    message("[LEfSe] Patched run_lefse: added drop=FALSE + early-exit guard for 0 KW-significant features")
  } else {
    warning("[LEfSe] run_lefse patch skipped: target line not found (package version mismatch?)")
  }
})

# ------------------------------------------------------------------------------
# Build a taxonomy matrix from a QIIME2-style taxonomy TSV.
# Attempts to map standard rank prefixes (d__, k__, p__, c__, o__, f__, g__, s__)
# to meaningful column names; falls back to generic Rank1, Rank2, ...
# ------------------------------------------------------------------------------
build_tax_matrix <- function(tax_df, taxa_ids) {
  tax_col <- if ("Taxon" %in% colnames(tax_df)) "Taxon" else
             if ("taxonomy" %in% colnames(tax_df)) "taxonomy" else NULL

  if (is.null(tax_col)) {
    mat <- matrix("", nrow = length(taxa_ids), ncol = 1,
                  dimnames = list(taxa_ids, "Kingdom"))
    return(mat)
  }

  tax_vec   <- as.character(tax_df[[tax_col]][match(taxa_ids, rownames(tax_df))])
  tax_vec[is.na(tax_vec)] <- ""
  split_tax <- strsplit(trimws(tax_vec), ";\\s*")
  max_rank  <- max(vapply(split_tax, length, integer(1)), 1L)

  rank_map  <- c(d = "Kingdom", k = "Kingdom", p = "Phylum",
                 c = "Class",   o = "Order",   f = "Family",
                 g = "Genus",   s = "Species")
  col_names <- paste0("Rank", seq_len(max_rank))  # fallback

  for (entry in split_tax) {
    if (length(entry) == 0) next
    detected <- rank_map[sub("^([a-z]+)__.*", "\\1", entry)]
    if (!any(is.na(detected)) && length(detected) == max_rank) {
      col_names <- as.character(detected)
      break
    }
  }

  mat <- matrix("", nrow = length(taxa_ids), ncol = max_rank,
                dimnames = list(taxa_ids, col_names))
  for (i in seq_along(split_tax)) {
    v <- split_tax[[i]]
    if (length(v)) mat[i, seq_len(length(v))] <- v
  }
  mat
}

# ---------- Snakemake bindings ----------
biom_path       <- snakemake@input[["feature_table"]]
metadata_path   <- snakemake@input[["metadata"]]
taxonomy_path   <- snakemake@input[["taxonomy"]]
out_rds         <- snakemake@output[["lefse_rds"]]
group_col       <- snakemake@params[["group_col"]]     %||% stop("group_col param not set")
lda_cutoff      <- snakemake@params[["lda_cutoff"]]    %||% 3.0
kw_cutoff       <- snakemake@params[["kw_cutoff"]]     %||% 0.05
wilcoxon_cutoff <- snakemake@params[["wilcoxon_cutoff"]] %||% 0.05
norm            <- snakemake@params[["norm"]]          %||% "CPM"
random_seed     <- snakemake@params[["random_seed"]]   %||% 42

dir.create(dirname(out_rds), recursive = TRUE, showWarnings = FALSE)

# ---------- Load data ----------
message("[LEfSe] Reading BIOM table: ", biom_path)
otu <- as.matrix(biomformat::biom_data(biomformat::read_biom(biom_path)))

message("[LEfSe] Reading metadata: ", metadata_path)
meta <- read.delim(metadata_path, header = TRUE, row.names = 1, sep = "\t",
                   check.names = FALSE, stringsAsFactors = FALSE,
                   quote = "", comment.char = "")

message("[LEfSe] Reading taxonomy: ", taxonomy_path)
tax_df <- read.delim(taxonomy_path, header = TRUE, row.names = 1, sep = "\t",
                     check.names = FALSE, stringsAsFactors = FALSE,
                     quote = "", comment.char = "")

if (!(group_col %in% colnames(meta)))
  stop("Grouping column '", group_col, "' not found in metadata.")

# ---------- Align samples ----------
common_samples <- intersect(colnames(otu), rownames(meta))
if (length(common_samples) < 2)
  stop("Too few overlapping samples between BIOM table and metadata.")

otu  <- otu[, common_samples, drop = FALSE]
meta <- meta[common_samples, , drop = FALSE]
meta[[group_col]] <- as.factor(meta[[group_col]])

otu <- otu[rowSums(otu, na.rm = TRUE) > 0, , drop = FALSE]
if (nrow(otu) == 0) stop("No non-zero taxa remain after filtering.")

# ---------- Build phyloseq ----------
tax_mat <- build_tax_matrix(tax_df, rownames(otu))

ps <- phyloseq::phyloseq(
  phyloseq::otu_table(otu, taxa_are_rows = TRUE),
  phyloseq::sample_data(meta),
  phyloseq::tax_table(tax_mat)
)

# ---------- Run LEfSe ----------
message("[LEfSe] Running LEfSe (group = '", group_col, "')")
set.seed(random_seed)
mm <- tryCatch(
  microbiomeMarker::run_lefse(
    ps,
    group           = group_col,
    norm            = norm,
    lda_cutoff      = lda_cutoff,
    kw_cutoff       = kw_cutoff,
    wilcoxon_cutoff = wilcoxon_cutoff,
    taxa_rank       = "all",
    multigrp_strat  = TRUE
  ),
  error = function(e) {
    message("[LEfSe] run_lefse failed: ", conditionMessage(e))
    message("[LEfSe] Writing NULL RDS, plotter will produce empty output.")
    saveRDS(NULL, file = out_rds)
    quit(save = "no", status = 0)
  }
)

n_markers <- nrow(microbiomeMarker::marker_table(mm)) %||% 0L
message("[LEfSe] Found ", n_markers, " significant marker(s).")

saveRDS(mm, file = out_rds)
message("[LEfSe] Results saved: ", out_rds)
