### R code from vignette source 'ClusteringSequences.Rnw'

###################################################
### code chunk number 1: ClusteringSequences.Rnw:51-54
###################################################
options(continue=" ")
options(width=80)
set.seed(123)


###################################################
### code chunk number 2: startup
###################################################
library(DECIPHER)


###################################################
### code chunk number 3: expr1
###################################################
# specify the path to your file of sequences:
fas <- "<<path to training FASTA file>>"
# OR use the example DNA sequences:
fas <- system.file("extdata",
	"50S_ribosomal_protein_L2.fas",
	package="DECIPHER")
# read the sequences into memory
dna <- readDNAStringSet(fas)
dna


###################################################
### code chunk number 4: expr2
###################################################
aa <- translate(dna)
aa
seqs <- aa # could also cluster the nucleotides
length(seqs)


###################################################
### code chunk number 5: expr3
###################################################
clusters <- Clusterize(seqs, cutoff=seq(0.5, 0, -0.1), processors=1)
class(clusters)
colnames(clusters)
str(clusters)
apply(clusters, 2, max) # number of clusters per cutoff
apply(clusters, 2, function(x) which.max(table(x))) # max sizes


###################################################
### code chunk number 6: expr4
###################################################
o <- order(clusters[[2]], width(seqs), decreasing=TRUE) # 40% cutoff
o <- o[!duplicated(clusters[[2]])]
aa[o]
dna[o]


###################################################
### code chunk number 7: expr5
###################################################
t <- table(clusters[[1]]) # select the clusters at a cutoff
t <- sort(t, decreasing=TRUE)
head(t)
w <- which(clusters[[1]] == names(t[1]))
AlignSeqs(seqs[w], verbose=FALSE)


###################################################
### code chunk number 8: expr6
###################################################
aligned_seqs <- AlignSeqs(seqs, verbose=FALSE)
d <- DistanceMatrix(aligned_seqs, verbose=FALSE)
tree <- TreeLine(myDistMatrix=d, method="UPGMA", verbose=FALSE)
heatmap(as.matrix(clusters), scale="column", Colv=NA, Rowv=tree)


###################################################
### code chunk number 9: expr7
###################################################
c1 <- Clusterize(dna, cutoff=0.2, invertCenters=TRUE, processors=1)
w <- which(c1 < 0 & !duplicated(c1))
dna[w] # select cluster representatives (negative cluster numbers)


###################################################
### code chunk number 10: expr8
###################################################
c2 <- Clusterize(dna, cutoff=0.2, singleLinkage=TRUE, processors=1)
max(abs(c1)) # center-linkage
max(c2) # single-linkage (fewer clusters, but broader clusters)


###################################################
### code chunk number 11: expr9
###################################################
genus <- sapply(strsplit(names(dna), " "), `[`, 1)
t <- table(genus, c2[[1]])
heatmap(sqrt(t), scale="none", Rowv=NA, col=hcl.colors(100))


###################################################
### code chunk number 12: expr10
###################################################
batchSize <- 2e2 # normally a large number (e.g., 1e6 or 1e7)
o <- order(width(seqs), decreasing=TRUE) # process largest to smallest
c3 <- integer(length(seqs)) # cluster numbers
repeat {
	m <- which(c3 < 0) # existing cluster representatives
	m <- m[!duplicated(c3[m])] # remove redundant sequences
	if (length(m) >= batchSize)
		stop("batchSize is too small")
	w <- head(c(m, o[c3[o] == 0L]), batchSize)
	if (!any(c3[w] == 0L)) {
		if (any(c3[-w] == 0L))
			stop("batchSize is too small")
		break # done
	}
	m <- m[match(abs(c3[-w]), abs(c3[m]))]
	c3[w] <- Clusterize(seqs[w], cutoff=0.05, invertCenters=TRUE)[[1]]
	c3[-w] <- ifelse(is.na(c3[m]), 0L, abs(c3[m]))
}
table(abs(c3)) # cluster sizes


###################################################
### code chunk number 13: expr11
###################################################
set.seed(123) # initialize the random number generator
clusters <- Clusterize(seqs, cutoff=0.1, processors=1)
set.seed(NULL) # reset the seed


###################################################
### code chunk number 14: sessinfo
###################################################
toLatex(sessionInfo(), locale=FALSE)


