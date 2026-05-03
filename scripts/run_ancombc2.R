suppressPackageStartupMessages({
  library(biomformat)
  library(phyloseq)
  library(ANCOMBC)
})

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0) y else x
}

natural_level_order <- function(x) {
  pad_nums <- function(s) {
    parts <- strsplit(s, "(?<=\\D)(?=\\d)|(?<=\\d)(?=\\D)", perl = TRUE)[[1]]
    paste(ifelse(grepl("^\\d+$", parts),
                 formatC(as.integer(parts), width = 10, flag = "0"),
                 parts), collapse = "")
  }
  x[order(vapply(as.character(x), pad_nums, character(1)))]
}

parse_interactions <- function(interactions, metadata_cols) {
  if (is.null(interactions) || length(interactions) == 0) {
    return(character(0))
  }

  terms <- character(0)
  for (intx in interactions) {
    if (is.null(intx)) next

    vars <- unlist(intx, use.names = FALSE)
    vars <- as.character(vars)
    vars <- vars[vars %in% metadata_cols]

    if (length(vars) >= 2) {
      terms <- c(terms, paste(vars, collapse = "*"))
    }
  }

  unique(terms)
}

extract_taxonomy_matrix <- function(taxonomy_df, taxa_ids) {
  tax_col <- if ("Taxon" %in% colnames(taxonomy_df)) {
    "Taxon"
  } else if ("taxonomy" %in% colnames(taxonomy_df)) {
    "taxonomy"
  } else {
    NULL
  }

  if (is.null(tax_col)) {
    mat <- matrix("", nrow = length(taxa_ids), ncol = 1)
    rownames(mat) <- taxa_ids
    colnames(mat) <- "Taxon"
    return(mat)
  }

  tax_vec <- taxonomy_df[[tax_col]]
  names(tax_vec) <- rownames(taxonomy_df)
  tax_vec <- as.character(tax_vec[taxa_ids])
  tax_vec[is.na(tax_vec)] <- ""

  split_tax <- strsplit(tax_vec, ";\\s*")
  max_rank <- max(vapply(split_tax, length, integer(1)), 1L)

  mat <- matrix("", nrow = length(taxa_ids), ncol = max_rank)
  rownames(mat) <- taxa_ids
  colnames(mat) <- paste0("Rank", seq_len(max_rank))

  for (i in seq_along(split_tax)) {
    vec <- split_tax[[i]]
    if (length(vec) > 0) {
      mat[i, seq_len(length(vec))] <- vec
    }
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
    message("[ANCOMBC2] Detected HDF5 (BIOM v2) format — using rhdf5 reader")
    .read_hdf5_biom(path)
  } else {
    message("[ANCOMBC2] Detected JSON (BIOM v1) format — using biomformat reader")
    as.matrix(biomformat::biom_data(biomformat::read_biom(path)))
  }
}

biom_path            <- snakemake@input[["feature_table"]]
metadata_path        <- snakemake@input[["metadata"]]
taxonomy_path        <- snakemake@input[["taxonomy"]]
out_path             <- snakemake@output[["output_file"]]
group_col            <- snakemake@params[["group_col"]]           %||% ""
covariates           <- snakemake@params[["covariates"]]          %||% character(0)
interactions         <- snakemake@params[["interactions"]]        %||% list()
min_sample_presence  <- snakemake@params[["min_sample_presence"]] %||% 3
prv_cut              <- snakemake@params[["prv_cut"]]             %||% 0.28
lib_cut              <- snakemake@params[["lib_cut"]]             %||% 5000
p_adj_method         <- snakemake@params[["p_adj_method"]]        %||% "BH"
alpha                <- snakemake@params[["alpha"]]               %||% 0.05
pseudo_sens          <- snakemake@params[["pseudo_sens"]]         %||% TRUE
struc_zero           <- snakemake@params[["struc_zero"]]          %||% TRUE
neg_lb               <- snakemake@params[["neg_lb"]]              %||% TRUE

dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)

message("[ANCOMBC2] Reading BIOM table: ", biom_path)
otu <- .read_biom_auto(biom_path)

if (!is.matrix(otu) || nrow(otu) == 0 || ncol(otu) == 0) {
  stop("BIOM table is empty or unreadable.")
}

message("[ANCOMBC2] Reading metadata: ", metadata_path)
meta <- read.delim(
  metadata_path,
  header = TRUE,
  row.names = 1,
  sep = "\t",
  check.names = FALSE,
  stringsAsFactors = FALSE,
  quote = "",
  comment.char = ""
)

if (!(group_col %in% colnames(meta))) {
  stop("Grouping column '", group_col, "' not found in metadata.")
}

message("[ANCOMBC2] Reading taxonomy: ", taxonomy_path)
tax_df <- read.delim(
  taxonomy_path,
  header = TRUE,
  row.names = 1,
  sep = "\t",
  check.names = FALSE,
  stringsAsFactors = FALSE,
  quote = "",
  comment.char = ""
)

common_samples <- intersect(colnames(otu), rownames(meta))
if (length(common_samples) < 2) {
  stop("Too few overlapping samples between BIOM table and metadata.")
}

otu <- otu[, common_samples, drop = FALSE]
meta <- meta[common_samples, , drop = FALSE]
meta[[group_col]] <- factor(meta[[group_col]],
                            levels = natural_level_order(unique(as.character(meta[[group_col]]))))

keep_taxa <- rowSums(otu, na.rm = TRUE) > 0
otu <- otu[keep_taxa, , drop = FALSE]

if (nrow(otu) == 0) {
  stop("No non-zero taxa remain after filtering.")
}

tax_mat <- extract_taxonomy_matrix(tax_df, rownames(otu))

ps <- phyloseq::phyloseq(
  phyloseq::otu_table(otu, taxa_are_rows = TRUE),
  phyloseq::sample_data(meta),
  phyloseq::tax_table(tax_mat)
)

ps <- phyloseq::filter_taxa(ps, function(x) sum(x > 0) >= min_sample_presence, TRUE)

# Remove taxa with zero variance within any group level — ancombc2 cannot fit these
otu_mat <- as.matrix(phyloseq::otu_table(ps))
if (!phyloseq::taxa_are_rows(ps)) otu_mat <- t(otu_mat)
sample_groups <- meta[colnames(otu_mat), group_col]
zero_var_mask <- apply(otu_mat, 1, function(x) {
  group_vars <- tapply(x, sample_groups, var)
  # Keep a taxon if at least one group has non-zero variance;
  # only drop if ALL groups have zero variance (truly constant everywhere)
  all(group_vars == 0, na.rm = TRUE)
})
if (any(zero_var_mask)) {
  message("[ANCOMBC2] Removing ", sum(zero_var_mask),
          " taxa with zero within-group variance")
  ps <- phyloseq::prune_taxa(!zero_var_mask, ps)
}

if (phyloseq::ntaxa(ps) == 0) {
  message("[ANCOMBC2] No taxa remain after filtering. Writing empty results: ", out_path)
  write.table(data.frame(FeatureID = character(0), Taxon = character(0)),
              file = out_path, sep = "\t", quote = FALSE, row.names = FALSE)
  quit(save = "no", status = 0)
}

ref_level <- levels(meta[[group_col]])[1]
message("[ANCOMBC2] Reference (baseline) level for '", group_col, "': ", ref_level)

covariate_cols <- as.character(unlist(covariates))
covariate_cols <- covariate_cols[covariate_cols %in% colnames(meta)]
for (col in covariate_cols) meta[[col]] <- as.factor(meta[[col]])

int_terms <- parse_interactions(interactions, colnames(meta))
fix_terms <- unique(c(group_col, covariate_cols, int_terms))
fix_formula <- paste(fix_terms, collapse = " + ")

run_ancombc2 <- function(ps_obj) {
  ANCOMBC::ancombc2(
    data       = ps_obj,
    fix_formula = fix_formula,
    group      = group_col,
    prv_cut    = prv_cut,
    lib_cut    = lib_cut,
    p_adj_method = p_adj_method,
    pseudo_sens = pseudo_sens,
    struc_zero = struc_zero,
    neg_lb     = neg_lb,
    alpha      = alpha,
    global     = TRUE,
    pairwise   = TRUE,
    dunnet     = FALSE,
    trend      = FALSE,
    verbose    = FALSE
  )
}

message("[ANCOMBC2] Running with formula: ", fix_formula)
ps_run <- ps
res <- NULL
repeat {
  res <- tryCatch(
    run_ancombc2(ps_run),
    error = function(e) {
      msg <- conditionMessage(e)
      if (grepl("Zero variances have been detected", msg)) {
        taxa_block <- gsub(".*Zero variances have been detected for the following taxa:\\s*", "", msg)
        taxa_block <- gsub("\\s*Please remove these taxa.*", "", taxa_block)
        bad_taxa   <- trimws(unlist(strsplit(taxa_block, "[,\n\\s]+")))
        bad_taxa   <- bad_taxa[nzchar(bad_taxa)]
        bad_taxa   <- bad_taxa[bad_taxa %in% phyloseq::taxa_names(ps_run)]
        if (length(bad_taxa) > 0) {
          message("[ANCOMBC2] Removing ", length(bad_taxa),
                  " zero-variance taxa and retrying")
          ps_run <<- phyloseq::prune_taxa(
            setdiff(phyloseq::taxa_names(ps_run), bad_taxa), ps_run)
          if (phyloseq::ntaxa(ps_run) == 0) {
            message("[ANCOMBC2] No taxa remain. Writing empty results: ", out_path)
            write.table(data.frame(FeatureID = character(0), Taxon = character(0)),
                        file = out_path, sep = "\t", quote = FALSE, row.names = FALSE)
            quit(save = "no", status = 0)
          }
          return(NULL)  # signal: retry
        }
      }
      message("[ANCOMBC2] ancombc2 failed: ", msg)
      write.table(data.frame(FeatureID = character(0), Taxon = character(0)),
                  file = out_path, sep = "\t", quote = FALSE, row.names = FALSE)
      quit(save = "no", status = 0)
    }
  )
  if (!is.null(res)) break
}

# 1. Extract the main results
res_df <- as.data.frame(res$res)

# 2. If pairwise was enabled, merge those columns in
if (!is.null(res$pairwise)) {
  pair_df <- as.data.frame(res$pairwise)
  # Match by taxon to ensure rows align correctly
  res_df <- merge(res_df, pair_df, by = "taxon", all = TRUE)
}

# 3. Ensure we have a FeatureID column for the plotter
if ("taxon" %in% colnames(res_df)) {
  res_df$FeatureID <- res_df$taxon
} else {
  res_df$FeatureID <- rownames(res_df)
}

# 4. Map the Taxonomy (Handling the merge safely)
tax_col <- if ("Taxon" %in% colnames(tax_df)) "Taxon" else if ("taxonomy" %in% colnames(tax_df)) "taxonomy" else NULL

if (!is.null(tax_col)) {
  tax_map <- as.character(tax_df[[tax_col]])
  names(tax_map) <- trimws(rownames(tax_df))
  res_df$Taxon <- tax_map[trimws(as.character(res_df$FeatureID))]
} else {
  res_df$Taxon <- NA_character_
}

# 5. Attach baseline metadata so the plot script can label axes correctly
res_df$group_col    <- group_col
res_df$ref_level    <- ref_level

# 6. Dynamic Column Reordering (The Safety Check)
# Only include columns that actually exist in the data frame
first_cols <- c("FeatureID", "Taxon", "group_col", "ref_level")
existing_first <- first_cols[first_cols %in% colnames(res_df)]
other_cols <- setdiff(colnames(res_df), existing_first)

res_df <- res_df[, c(existing_first, other_cols), drop = FALSE]

write.table(
  res_df,
  file = out_path,
  sep = "\t",
  quote = FALSE,
  row.names = FALSE,
  col.names = TRUE
)

message("[ANCOMBC2] Results written: ", out_path)