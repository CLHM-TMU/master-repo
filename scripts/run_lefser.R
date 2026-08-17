suppressPackageStartupMessages({
  library(biomformat)
  library(SummarizedExperiment)
  library(lefser)
})

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x

# ------------------------------------------------------------------------------
# Build one pipe-delimited lineage string per feature ("k__Bacteria|p__...|s__...")
# from a QIIME2-style taxonomy TSV. lefser::get_terminal_nodes() relies on this
# format: it detects internal (non-leaf) nodes by checking whether one feature's
# lineage string is a substring of another's, so every feature needs its full
# ancestry, not just its own rank label.
# ------------------------------------------------------------------------------
build_lineage_strings <- function(tax_df, taxa_ids) {

  # --- Detect genus-collapsed input ---
  # When the table is genus-collapsed, feature IDs ARE the taxonomy strings.
  is_collapsed <- mean(grepl("__", taxa_ids)) > 0.5

  if (is_collapsed) {
    message("[lefseR] Detected genus-collapsed feature IDs — using row names as lineage strings.")
    lineage <- gsub(";\\s*", "|", trimws(taxa_ids))
  } else {
    tax_col <- if ("Taxon" %in% colnames(tax_df)) "Taxon" else
               if ("taxonomy" %in% colnames(tax_df)) "taxonomy" else NULL

    if (is.null(tax_col)) {
      message("[lefseR] No Taxon/taxonomy column found; falling back to feature IDs as lineage strings.")
      return(make.unique(taxa_ids))
    }

    tax_vec <- as.character(tax_df[[tax_col]][match(taxa_ids, rownames(tax_df))])
    tax_vec[is.na(tax_vec)] <- taxa_ids[is.na(tax_vec)]
    lineage <- gsub(";\\s*", "|", trimws(tax_vec))
  }

  # lefser::rowNames2RowData() only recognizes the classic LEfSe/MetaPhlAn rank
  # prefixes (k__p__c__o__f__g__s__t__). GTDB-derived classifiers (e.g.
  # Greengenes2) use "d__" (domain) instead of "k__" (kingdom) for the same
  # top rank; left as "d__" it silently breaks lefserClades() downstream
  # (rowData column name becomes NA -> mia::splitByRanks finds no ranks).
  lineage <- sub("^d__", "k__", lineage)

  make.unique(lineage)
}

# ---------- Snakemake bindings ----------
biom_path       <- snakemake@input[["feature_table"]]
metadata_path   <- snakemake@input[["metadata"]]
taxonomy_path   <- snakemake@input[["taxonomy"]]
out_rds         <- snakemake@output[["lefser_rds"]]
group_col       <- snakemake@params[["group_col"]]      %||% stop("group_col param not set")
class_a         <- snakemake@params[["class_a"]]         %||% stop("class_a param not set")
class_b         <- snakemake@params[["class_b"]]         %||% stop("class_b param not set")
lda_cutoff      <- snakemake@params[["lda_cutoff"]]      %||% 2.0
kw_cutoff       <- snakemake@params[["kw_cutoff"]]       %||% 0.05
wilcoxon_cutoff <- snakemake@params[["wilcoxon_cutoff"]] %||% 0.05
random_seed     <- snakemake@params[["random_seed"]]     %||% 42

dir.create(dirname(out_rds), recursive = TRUE, showWarnings = FALSE)

save_empty <- function(reason) {
  message("[lefseR] ", reason, " Writing NULL RDS, plotter will produce empty output.")
  saveRDS(list(res = NULL, res_clades = NULL, group_col = group_col,
               class_a = class_a, class_b = class_b),
          file = out_rds)
  quit(save = "no", status = 0)
}

# ---------- Load data ----------
message("[lefseR] Reading BIOM table: ", biom_path)
otu <- as.matrix(biomformat::biom_data(biomformat::read_biom(biom_path)))

message("[lefseR] Reading metadata: ", metadata_path)
meta <- read.delim(metadata_path, header = TRUE, row.names = 1, sep = "\t",
                   check.names = FALSE, stringsAsFactors = FALSE,
                   quote = "", comment.char = "")

message("[lefseR] Reading taxonomy: ", taxonomy_path)
tax_df <- read.delim(taxonomy_path, header = TRUE, row.names = 1, sep = "\t",
                     check.names = FALSE, stringsAsFactors = FALSE,
                     quote = "", comment.char = "")

if (!(group_col %in% colnames(meta)))
  stop("Grouping column '", group_col, "' not found in metadata.")

# ---------- Align samples, restrict to the two classes in this comparison ----------
common_samples <- intersect(colnames(otu), rownames(meta))
if (length(common_samples) < 2)
  save_empty("Too few overlapping samples between BIOM table and metadata.")

otu  <- otu[, common_samples, drop = FALSE]
meta <- meta[common_samples, , drop = FALSE]

pair_samples <- rownames(meta)[meta[[group_col]] %in% c(class_a, class_b)]
if (length(pair_samples) < 2)
  save_empty(paste0("Fewer than 2 samples in '", group_col, "' %in% c('",
                     class_a, "', '", class_b, "')."))

otu  <- otu[, pair_samples, drop = FALSE]
meta <- meta[pair_samples, , drop = FALSE]

# class_a -> reference level (score 0), class_b -> comparison level (score 1),
# matching lefserPlot()'s "positive score = more abundant in class 1" convention.
meta[[group_col]] <- factor(as.character(meta[[group_col]]), levels = c(class_a, class_b))

otu <- otu[rowSums(otu, na.rm = TRUE) > 0, , drop = FALSE]
if (nrow(otu) == 0)
  save_empty("No non-zero taxa remain after filtering.")

# ---------- Build lineage-string row names, filter to terminal (leaf) taxa ----------
rownames(otu) <- build_lineage_strings(tax_df, rownames(otu))

terminal <- lefser::get_terminal_nodes(rownames(otu))
otu_tn   <- otu[terminal, , drop = FALSE]
if (nrow(otu_tn) == 0) {
  message("[lefseR] get_terminal_nodes() found no terminal taxa; falling back to all features.")
  otu_tn <- otu
}

# ---------- Build SummarizedExperiment, convert to relative abundance ----------
se <- SummarizedExperiment::SummarizedExperiment(
  assays  = list(counts = otu_tn),
  colData = meta
)

ra <- lefser::relativeAb(se)
relab <- SummarizedExperiment::SummarizedExperiment(
  assays  = list(rel_abs = SummarizedExperiment::assay(ra, "rel_abs")),
  colData = SummarizedExperiment::colData(ra)
)

message("[lefseR] Running lefser (group = '", group_col, "', ",
        class_a, " vs ", class_b, "; ", nrow(relab), " terminal taxa, ",
        ncol(relab), " samples)")

set.seed(random_seed)
res <- tryCatch(
  lefser::lefser(
    relab,
    classCol         = group_col,
    kruskal.threshold = kw_cutoff,
    wilcox.threshold  = wilcoxon_cutoff,
    lda.threshold     = lda_cutoff,
    assay             = 1L
  ),
  error = function(e) {
    message("[lefseR] lefser() failed: ", conditionMessage(e))
    NULL
  }
)

n_markers <- if (is.null(res)) 0L else nrow(res)
message("[lefseR] Found ", n_markers, " significant marker(s).")

# ---------- Clade-resolved results, for the cladogram plot ----------
res_clades <- NULL
if (n_markers > 0) {
  relab_tree <- tryCatch(lefser::rowNames2RowData(relab), error = function(e) NULL)
  if (!is.null(relab_tree)) {
    res_clades <- tryCatch(
      lefser::lefserClades(
        relab_tree,
        classCol          = group_col,
        kruskal.threshold  = kw_cutoff,
        wilcox.threshold   = wilcoxon_cutoff,
        lda.threshold      = lda_cutoff
      ),
      error = function(e) {
        message("[lefseR] lefserClades() failed: ", conditionMessage(e))
        NULL
      }
    )
  }
}

saveRDS(
  list(res = res, res_clades = res_clades, group_col = group_col,
       class_a = class_a, class_b = class_b),
  file = out_rds
)
message("[lefseR] Results saved: ", out_rds)
