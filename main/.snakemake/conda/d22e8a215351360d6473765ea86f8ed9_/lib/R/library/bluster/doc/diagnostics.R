## ----echo=FALSE---------------------------------------------------------------
knitr::opts_chunk$set(error=FALSE, message=FALSE, warning=FALSE)
library(BiocStyle)

## -----------------------------------------------------------------------------
library(scRNAseq)
sce <- GrunPancreasData()

# Quality control to remove bad cells.
library(scuttle)
qcstats <- perCellQCMetrics(sce)
qcfilter <- quickPerCellQC(qcstats, sub.fields="altexps_ERCC_percent")
sce <- sce[,!qcfilter$discard]

# Normalization by library size.
sce <- logNormCounts(sce)

# Feature selection.
library(scran)
dec <- modelGeneVar(sce)
hvgs <- getTopHVGs(dec, n=1000)

# Dimensionality reduction.
set.seed(1000)
library(scater)
sce <- runPCA(sce, ncomponents=20, subset_row=hvgs)

# Clustering.
library(bluster)
mat <- reducedDim(sce)
clust.info <- clusterRows(mat, NNGraphParam(), full=TRUE)
clusters <- clust.info$clusters
table(clusters)

## -----------------------------------------------------------------------------
sil <- approxSilhouette(mat, clusters)
sil
boxplot(split(sil$width, clusters))

## -----------------------------------------------------------------------------
best.choice <- ifelse(sil$width > 0, clusters, sil$other)
table(Assigned=clusters, Closest=best.choice)

## -----------------------------------------------------------------------------
pure <- neighborPurity(mat, clusters)
pure
boxplot(split(pure$purity, clusters))

## -----------------------------------------------------------------------------
table(Assigned=clusters, Max=pure$maximum)

## -----------------------------------------------------------------------------
rmsd <- clusterRMSD(mat, clusters)
barplot(rmsd)

## -----------------------------------------------------------------------------
clusterRMSD(mat, clusters, sum=TRUE)

## -----------------------------------------------------------------------------
g <- clust.info$objects$graph
ratio <- pairwiseModularity(g, clusters, as.ratio=TRUE)

library(pheatmap)
pheatmap(log10(ratio+1), cluster_cols=FALSE, cluster_rows=FALSE,
    col=rev(heat.colors(100)))

## -----------------------------------------------------------------------------
cluster.gr <- igraph::graph_from_adjacency_matrix(log2(ratio+1), 
    mode="upper", weighted=TRUE, diag=FALSE)

# Increasing the weight to increase the visibility of the lines.
set.seed(1100101)
plot(cluster.gr, edge.width=igraph::E(cluster.gr)$weight*5,
    layout=igraph::layout_with_lgl)

## -----------------------------------------------------------------------------
merged <- mergeCommunities(g, clusters, number=10)
table(merged)

## -----------------------------------------------------------------------------
hclusters <- clusterRows(mat, HclustParam(cut.dynamic=TRUE))
pairwiseRand(clusters, hclusters, mode="index")

## -----------------------------------------------------------------------------
ratio <- pairwiseRand(clusters, hclusters, mode="ratio")

library(pheatmap)
pheatmap(ratio, cluster_cols=FALSE, cluster_rows=FALSE,
    col=viridis::viridis(100), breaks=seq(-1, 1, length=101))

## -----------------------------------------------------------------------------
set.seed(1001010)
ari <-bootstrapStability(mat, clusters=clusters, 
    mode="index", BLUSPARAM=NNGraphParam())
ari

## -----------------------------------------------------------------------------
set.seed(1001010)
ratio <-bootstrapStability(mat, clusters=clusters,
    mode="ratio", BLUSPARAM=NNGraphParam())

library(pheatmap)
pheatmap(ratio, cluster_cols=FALSE, cluster_rows=FALSE,
    col=viridis::viridis(100), breaks=seq(-1, 1, length=101))

## -----------------------------------------------------------------------------
combinations <- clusterSweep(mat, BLUSPARAM=SNNGraphParam(),
    k=c(5L, 10L, 15L, 20L), cluster.fun=c("walktrap", "louvain", "infomap"))

## -----------------------------------------------------------------------------
colnames(combinations$clusters)
combinations$parameters

## -----------------------------------------------------------------------------
set.seed(10)
nclusters <- 3:25
kcombos <- clusterSweep(mat, BLUSPARAM=KmeansParam(centers=5), centers=nclusters)

sil <- vapply(as.list(kcombos$clusters), function(x) mean(approxSilhouette(mat, x)$width), 0)
plot(nclusters, sil, xlab="Number of clusters", ylab="Average silhouette width")

pur <- vapply(as.list(kcombos$clusters), function(x) mean(neighborPurity(mat, x)$purity), 0)
plot(nclusters, pur, xlab="Number of clusters", ylab="Average purity")

wcss <- vapply(as.list(kcombos$clusters), function(x) sum(clusterRMSD(mat, x, sum=TRUE)), 0)
plot(nclusters, wcss, xlab="Number of clusters", ylab="Within-cluster sum of squares")

## -----------------------------------------------------------------------------
linked <- linkClusters(
    list(
        walktrap=combinations$clusters$k.10_cluster.fun.walktrap,
        louvain=combinations$clusters$k.10_cluster.fun.louvain,
        infomap=combinations$clusters$k.10_cluster.fun.infomap
    )
)
linked

## -----------------------------------------------------------------------------
meta <- igraph::cluster_walktrap(linked)
plot(linked, mark.groups=meta)

## -----------------------------------------------------------------------------
aris <- compareClusterings(combinations$clusters)
g <- igraph::graph.adjacency(aris, mode="undirected", weighted=TRUE)
meta2 <- igraph::cluster_walktrap(g)
plot(g, mark.groups=meta2)

## -----------------------------------------------------------------------------
sessionInfo()

