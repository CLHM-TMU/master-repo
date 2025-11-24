## ----echo=FALSE---------------------------------------------------------------
knitr::opts_chunk$set(cache = FALSE,
                      fig.width = 9,
                      message = FALSE,
                      warning = FALSE)

## ----eval=FALSE---------------------------------------------------------------
#  if (!requireNamespace("BiocManager", quietly = TRUE))
#      install.packages("BiocManager")
#  BiocManager::install("mia")

## ----load-packages, message=FALSE, warning=FALSE------------------------------
library("mia")

## -----------------------------------------------------------------------------
data(GlobalPatterns, package = "mia")
tse <- GlobalPatterns
tse

## -----------------------------------------------------------------------------
# print the available taxonomic ranks
colnames(rowData(tse))
taxonomyRanks(tse)
# subset to taxonomic data only
rowData(tse)[,taxonomyRanks(tse)]

## -----------------------------------------------------------------------------
table(taxonomyRankEmpty(tse, "Species"))
head(getTaxonomyLabels(tse))

## -----------------------------------------------------------------------------
# agglomerate at the Family taxonomic rank
x1 <- mergeFeaturesByRank(tse, rank = "Family")
## How many taxa before/after agglomeration?
nrow(tse)
nrow(x1)

## -----------------------------------------------------------------------------
# with agglomeration of the tree
x2 <- mergeFeaturesByRank(tse, rank = "Family",
                        agglomerateTree = TRUE)
nrow(x2) # same number of rows, but
rowTree(x1) # ... different
rowTree(x2) # ... tree

## -----------------------------------------------------------------------------
data(enterotype, package = "mia")
taxonomyRanks(enterotype)
mergeFeaturesByRank(enterotype)

## -----------------------------------------------------------------------------
altExp(tse, "family") <- x2

## -----------------------------------------------------------------------------
x1 <- mergeFeaturesByRank(tse, rank = "Species", na.rm = TRUE)
altExp(tse,"species") <- mergeFeaturesByRank(tse, rank = "Species", na.rm = FALSE)
dim(x1)
dim(altExp(tse,"species"))

## -----------------------------------------------------------------------------
altExps(tse) <- splitByRanks(tse)
tse
altExpNames(tse)

## -----------------------------------------------------------------------------
taxa <- rowData(altExp(tse,"Species"))[,taxonomyRanks(tse)]
taxa_res <- resolveLoop(as.data.frame(taxa))
taxa_tree <- toTree(data = taxa_res)
taxa_tree$tip.label <- getTaxonomyLabels(altExp(tse,"Species"))
rowNodeLab <- getTaxonomyLabels(altExp(tse,"Species"), make_unique = FALSE)
altExp(tse,"Species") <- changeTree(altExp(tse,"Species"),
                                   rowTree = taxa_tree,
                                   rowNodeLab = rowNodeLab)

## -----------------------------------------------------------------------------
assayNames(enterotype)
anterotype <- transformAssay(enterotype, method = "log10", pseudocount = 1)
assayNames(enterotype)

## -----------------------------------------------------------------------------
data(GlobalPatterns, package = "mia")

tse.subsampled <- subsampleCounts(GlobalPatterns, 
                                  min_size = 60000, 
                                  name = "subsampled",
                                  replace = TRUE,
                                  seed = 1938)
tse.subsampled


## -----------------------------------------------------------------------------
library(MultiAssayExperiment)
mae <- MultiAssayExperiment(c("originalTreeSE" = GlobalPatterns,
                              "subsampledTreeSE" = tse.subsampled))
mae

## -----------------------------------------------------------------------------
# To extract specifically the subsampled TreeSE
experiments(mae)$subsampledTreeSE

## -----------------------------------------------------------------------------
tse <- estimateDiversity(tse)
colnames(colData(tse))[8:ncol(colData(tse))]

## -----------------------------------------------------------------------------
library(scater)
altExp(tse,"Genus") <- runMDS(altExp(tse,"Genus"), 
                              FUN = vegan::vegdist,
                              method = "bray",
                              name = "BrayCurtis", 
                              ncomponents = 5, 
                              assay.type = "counts", 
                              keep_dist = TRUE)

## ----message=FALSE, warning=FALSE---------------------------------------------
data(esophagus, package = "phyloseq")

## -----------------------------------------------------------------------------
esophagus
esophagus <- makeTreeSEFromPhyloseq(esophagus)
esophagus

## -----------------------------------------------------------------------------
# Specific taxa
assay(tse['522457',], "counts")
# Specific sample
assay(tse[,'CC1'], "counts")


## -----------------------------------------------------------------------------
data(esophagus, package = "mia")
top_taxa <- getTopFeatures(esophagus,
                       method = "mean",
                       top = 5,
                       assay.type = "counts")
top_taxa

## -----------------------------------------------------------------------------
molten_data <- meltAssay(tse,
                         assay.type = "counts",
                         add_row_data = TRUE,
                         add_col_data = TRUE
)
molten_data

## -----------------------------------------------------------------------------
sessionInfo()

