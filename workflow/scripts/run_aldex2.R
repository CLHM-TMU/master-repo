suppressPackageStartupMessages({
  library(biomformat)
  library(phyloseq)
  library(ALDEx2)
  library(microbiomeMarker)
})

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x

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
  col_names <- paste0("Rank", seq_len(max_rank))

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

# ---------- BIOM format helpers ----------
.is_hdf5_biom <- function(path) {
  magic <- tryCatch(readBin(path, raw(), n = 4), error = function(e) raw(0))
  length(magic) >= 4 &&
    identical(magic[1:4], as.raw(c(0x89, 0x48, 0x44, 0x46)))  # \x89HDF
}

.read_hdf5_biom <- function(path) {
  if (!requireNamespace("rhdf5", quietly = TRUE))
    stop("Package 'rhdf5' is required for HDF5 BIOM files.\n",
         "  Install with: BiocManager::install('rhdf5')")
  obs_ids  <- as.character(rhdf5::h5read(path, "observation/ids"))
  samp_ids <- as.character(rhdf5::h5read(path, "sample/ids"))
  data_v   <- rhdf5::h5read(path, "observation/matrix/data")
  indices  <- as.integer(rhdf5::h5read(path, "observation/matrix/indices")) + 1L
  indptr   <- as.integer(rhdf5::h5read(path, "observation/matrix/indptr"))  + 1L
  mat <- matrix(0L, nrow = length(obs_ids), ncol = length(samp_ids),
                dimnames = list(obs_ids, samp_ids))
  for (i in seq_along(obs_ids)) {
    col_idx        <- indices[indptr[i]:(indptr[i + 1L] - 1L)]
    mat[i, col_idx] <- data_v[indptr[i]:(indptr[i + 1L] - 1L)]
  }
  mat
}

.read_biom_auto <- function(path) {
  if (.is_hdf5_biom(path)) {
    message("[ALDEx2] Detected HDF5 (BIOM v2) format — using rhdf5 reader")
    .read_hdf5_biom(path)
  } else {
    message("[ALDEx2] Detected JSON (BIOM v1) format — using biomformat reader")
    as.matrix(biomformat::biom_data(biomformat::read_biom(path)))
  }
}

# ---------- Snakemake bindings ----------
biom_path     <- snakemake@input[["feature_table"]]
metadata_path <- snakemake@input[["metadata"]]
taxonomy_path <- snakemake@input[["taxonomy"]]
out_rds       <- snakemake@output[["aldex2_rds"]]
out_tsv       <- snakemake@output[["aldex2_table"]]
group_col     <- snakemake@params[["group_col"]]     %||% stop("group_col param not set")
p_adj_method  <- snakemake@params[["p_adj_method"]]  %||% "BH"
pvalue_cutoff <- snakemake@params[["pvalue_cutoff"]] %||% 0.05
mc_samples    <- snakemake@params[["mc_samples"]]    %||% 128
denom         <- snakemake@params[["denom"]]         %||% "all"
paired_test   <- snakemake@params[["paired_test"]]   %||% FALSE

dir.create(dirname(out_rds), recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(out_tsv), recursive = TRUE, showWarnings = FALSE)

# ---------- Load data ----------
message("[ALDEx2] Reading BIOM table: ", biom_path)
otu <- .read_biom_auto(biom_path)

message("[ALDEx2] Reading metadata: ", metadata_path)
meta <- read.delim(metadata_path, header = TRUE, row.names = 1, sep = "\t",
                   check.names = FALSE, stringsAsFactors = FALSE,
                   quote = "", comment.char = "")

message("[ALDEx2] Reading taxonomy: ", taxonomy_path)
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

# --- New: Automated Pairing & Sorting Logic ---
if (paired_test) {
  # 1. Identify the Subject/Patient column
  possible_subject_cols <- c("Patient", "Mouse", "Subject", "Individual")
  subject_col <- intersect(possible_subject_cols, colnames(meta))[1]
  
  if (is.na(subject_col)) {
    stop("Paired test requested, but no 'Patient', 'Mouse', or 'Subject' column found in metadata.")
  }
  
  message("[ALDEx2] Pairing detected. Using column: '", subject_col, "' for alignment.")

  # 2. Sort metadata by Subject, then by the Group (e.g., Before/After)
  # This ensures Subject 1 - Before is followed immediately by Subject 1 - After
  meta <- meta[order(meta[[subject_col]], meta[[group_col]]), ]
  
  # 3. Re-order the OTU table to match this new metadata order
  otu <- otu[, rownames(meta), drop = FALSE]
  
  # 4. Critical Quality Check: Ensure every subject has exactly 2 samples
  subject_counts <- table(meta[[subject_col]])
  if (any(subject_counts != 2)) {
    bad_subjects <- names(subject_counts[subject_counts != 2])
    stop("Paired test failed: The following subjects do not have exactly 2 samples: ", 
         paste(bad_subjects, collapse = ", "))
  }
  
  message("[ALDEx2] Pairwise alignment verified for ", length(subject_counts), " subjects.")
}

# Ensure factor levels are consistent
meta[[group_col]] <- as.factor(meta[[group_col]])
otu <- otu[rowSums(otu, na.rm = TRUE) > 0, , drop = FALSE]
# -----------------------------------------------
# ---------- Run ALDEx2 ----------
otu_int   <- round(otu)
storage.mode(otu_int) <- "integer"

condition <- as.character(meta[[group_col]])
n_groups  <- length(unique(condition))
tax_mat   <- build_tax_matrix(tax_df, rownames(otu_int))

message("[ALDEx2] CLR transform (mc.samples=", mc_samples, ", denom='", denom, "')")
set.seed(42)
clr <- ALDEx2::aldex.clr(otu_int, condition,
                          mc.samples = mc_samples,
                          denom      = denom,
                          verbose    = FALSE)

if (n_groups == 2) {
  message("[ALDEx2] Welch t-test (paired=", paired_test, ")")
  test_res <- ALDEx2::aldex.ttest(clr, paired.test = paired_test, verbose = FALSE)
  pval_col <- "we.ep"
  padj_col <- "we.eBH"

  effect_res <- tryCatch(
    ALDEx2::aldex.effect(clr, CI = FALSE, verbose = FALSE),
    error = function(e) { message("[ALDEx2] aldex.effect skipped: ", conditionMessage(e)); NULL }
  )
  combined   <- if (!is.null(effect_res)) cbind(effect_res, test_res) else test_res
  has_effect <- !is.null(effect_res) && "effect" %in% colnames(combined)
} else {
  message("[ALDEx2] Kruskal-Wallis test")
  test_res   <- ALDEx2::aldex.kw(clr, verbose = FALSE)
  pval_col   <- "kw.ep"
  padj_col   <- "kw.eBH"
  combined   <- test_res
  has_effect <- FALSE
}

if (!(padj_col %in% colnames(combined)))
  combined[[padj_col]] <- p.adjust(combined[[pval_col]], method = p_adj_method)

# ---------- Enriched group ----------
group_levels <- unique(condition)
group_logmeans <- sapply(group_levels, function(g) {
  rowMeans(log(otu_int[, condition == g, drop = FALSE] + 0.5))
})
enrich_group <- group_levels[apply(group_logmeans, 1, which.max)]
names(enrich_group) <- rownames(otu_int)

# ---------- Filter significant taxa ----------
sig_mask  <- !is.na(combined[[padj_col]]) & combined[[padj_col]] < pvalue_cutoff
n_markers <- sum(sig_mask)
message("[ALDEx2] Found ", n_markers, " significant marker(s) at padj < ", pvalue_cutoff)

sig_features <- rownames(combined)[sig_mask]
sig_df <- data.frame(
  feature      = sig_features,
  enrich_group = enrich_group[sig_features],
  ef_aldex2    = if (has_effect) combined$effect[sig_mask] else rep(NA_real_, n_markers),
  pvalue       = combined[[pval_col]][sig_mask],
  padj         = combined[[padj_col]][sig_mask],
  stringsAsFactors = FALSE
)

# ---------- Build microbiomeMarker object (only when markers exist) ----------
# marker_table() rejects zero-row data frames, so we only construct it when
# there are significant results. The plot script receives a list wrapper.
mm <- if (n_markers > 0) {
  mt <- microbiomeMarker::marker_table(sig_df)
  microbiomeMarker::microbiomeMarker(
    marker_table = mt,
    norm_method  = "none",
    diff_method  = "aldex",
    phyloseq::otu_table(otu_int, taxa_are_rows = TRUE),
    phyloseq::sample_data(meta),
    phyloseq::tax_table(tax_mat)
  )
} else {
  NULL
}

# ---------- Save ----------
write.table(sig_df, out_tsv, sep = "\t", quote = FALSE, row.names = FALSE)

saveRDS(
  list(mm = mm, n_markers = n_markers, sig_df = sig_df, group_col = group_col),
  file = out_rds
)

message("[ALDEx2] RDS saved:   ", out_rds)
message("[ALDEx2] Table saved: ", out_tsv)