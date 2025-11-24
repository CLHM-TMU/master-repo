## ----echo=FALSE---------------------------------------------------------------
knitr::opts_chunk$set(error=FALSE, message=FALSE, warnings=FALSE)
library(BiocStyle)

## -----------------------------------------------------------------------------
library(scRNAseq)
sce <- ZeiselBrainData()

# Trusting the authors' quality control, and going straight to normalization.
library(scuttle)
sce <- logNormCounts(sce)

# Feature selection based on highly variable genes.
library(scran)
dec <- modelGeneVar(sce)
hvgs <- getTopHVGs(dec, n=1000)

# Dimensionality reduction for work (PCA) and pleasure (t-SNE).
set.seed(1000)
library(scater)
sce <- runPCA(sce, ncomponents=20, subset_row=hvgs)
sce <- runUMAP(sce, dimred="PCA")

mat <- reducedDim(sce, "PCA")
dim(mat)

## -----------------------------------------------------------------------------
library(bluster)
hclust.out <- clusterRows(mat, HclustParam())
plotUMAP(sce, colour_by=I(hclust.out))

## -----------------------------------------------------------------------------
hp2 <- HclustParam(method="ward.D2", cut.dynamic=TRUE)
hp2
hclust.out <- clusterRows(mat, hp2)
plotUMAP(sce, colour_by=I(hclust.out))

## -----------------------------------------------------------------------------
set.seed(1000)
sub <- sce[,sample(ncol(sce), 200)]
ap.out <- clusterRows(reducedDim(sub), AffinityParam())
plotUMAP(sub, colour_by=I(ap.out))

## -----------------------------------------------------------------------------
set.seed(1000)
ap.out <- clusterRows(reducedDim(sub), AffinityParam(q=-2))
plotUMAP(sub, colour_by=I(ap.out))

## -----------------------------------------------------------------------------
set.seed(100)
kmeans.out <- clusterRows(mat, KmeansParam(10))
plotUMAP(sce, colour_by=I(kmeans.out))

## -----------------------------------------------------------------------------
kp <- KmeansParam(sqrt)
kp
set.seed(100)
kmeans.out <- clusterRows(mat, kp)
plotUMAP(sce, colour_by=I(kmeans.out))

## -----------------------------------------------------------------------------
set.seed(100)
mbkmeans.out <- clusterRows(mat, MbkmeansParam(20))
plotUMAP(sce, colour_by=I(mbkmeans.out))

## -----------------------------------------------------------------------------
set.seed(1000)
som.out <- clusterRows(mat, SomParam(20))
plotUMAP(sce, colour_by=I(som.out))

## ----fig.wide=TRUE------------------------------------------------------------
set.seed(1000)
som.out <- clusterRows(mat, SomParam(100), full=TRUE)

par(mfrow=c(1,2))
plot(som.out$objects$som, "counts")
grid <- som.out$objects$som$grid$pts
text(grid[,1], grid[,2], seq_len(nrow(grid)))

## -----------------------------------------------------------------------------
set.seed(101) # just in case there are ties.
graph.out <- clusterRows(mat, NNGraphParam(k=10))
plotUMAP(sce, colour_by=I(graph.out))

## -----------------------------------------------------------------------------
set.seed(101) # just in case there are ties.
np <- NNGraphParam(k=20, cluster.fun="louvain")
np
graph.out <- clusterRows(mat, np)
plotUMAP(sce, colour_by=I(graph.out))

## -----------------------------------------------------------------------------
dbscan.out <- clusterRows(mat, DbscanParam())
plotUMAP(sce, colour_by=I(dbscan.out))

## -----------------------------------------------------------------------------
summary(is.na(dbscan.out))

## -----------------------------------------------------------------------------
dbscan.out <- clusterRows(mat, DbscanParam(core.prop=0.1))
summary(is.na(dbscan.out))

## -----------------------------------------------------------------------------
set.seed(100) # for the k-means
two.out <- clusterRows(mat, TwoStepParam())
plotUMAP(sce, colour_by=I(two.out))

## -----------------------------------------------------------------------------
twop <- TwoStepParam(second=NNGraphParam(k=5))
twop
set.seed(100) # for the k-means
two.out <- clusterRows(mat, TwoStepParam())
plotUMAP(sce, colour_by=I(two.out))

## -----------------------------------------------------------------------------
nn.out <- clusterRows(mat, NNGraphParam(), full=TRUE)
nn.out$objects$graph

## -----------------------------------------------------------------------------
table(nn.out$clusters)

## -----------------------------------------------------------------------------
sessionInfo()

