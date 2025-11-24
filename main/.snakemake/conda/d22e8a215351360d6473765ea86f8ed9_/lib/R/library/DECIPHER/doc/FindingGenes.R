### R code from vignette source 'FindingGenes.Rnw'

###################################################
### code chunk number 1: FindingGenes.Rnw:47-50
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
# specify the path to your genome:
genome_path <- "<<path to genome FASTA file>>"
# OR use the example genome:
genome_path <- system.file("extdata",
	"Chlamydia_trachomatis_NC_000117.fas.gz",
	package="DECIPHER")

# read the sequences into memory
genome <- readDNAStringSet(genome_path)
genome


###################################################
### code chunk number 4: expr2
###################################################
getOption("SweaveHooks")[["fig"]]()
orfs <- FindGenes(genome, showPlot=TRUE, allScores=TRUE)


###################################################
### code chunk number 5: expr3
###################################################
orfs


###################################################
### code chunk number 6: expr4
###################################################
genes <- orfs[orfs[, "Gene"]==1,]


###################################################
### code chunk number 7: expr5
###################################################
colnames(genes)


###################################################
### code chunk number 8: expr6
###################################################
dna <- ExtractGenes(genes, genome)
dna


###################################################
### code chunk number 9: expr7
###################################################
table(subseq(dna[-1], 1, 3))


###################################################
### code chunk number 10: expr8
###################################################
w <- which(!subseq(dna, 1, 3) %in% c("ATG", "GTG", "TTG"))
w
w <- w[-1] # drop the first sequence because it is a fragment
w
dna[w]
genes[w]


###################################################
### code chunk number 11: expr9
###################################################
aa <- ExtractGenes(genes, genome, type="AAStringSet")
aa


###################################################
### code chunk number 12: expr10
###################################################
subseq(aa, 2, -2)


###################################################
### code chunk number 13: expr11
###################################################
a <- alphabetFrequency(dna, baseOnly=TRUE)
w <- which(a[, "other"] <= 20 & a[, "other"]/width(dna) <= 5)
genes <- genes[w]


###################################################
### code chunk number 14: expr12
###################################################
w <- which(width(dna) < 90)
dna[w]
aa[w]
genes[w]
genes[w, "End"] - genes[w, "Begin"] + 1 # lengths
genes[w, "FractionReps"]


###################################################
### code chunk number 15: expr13
###################################################
getOption("SweaveHooks")[["fig"]]()
pairs(genes[, 5:16], pch=46, col="#00000033", panel=panel.smooth)


###################################################
### code chunk number 16: expr14
###################################################
getOption("SweaveHooks")[["fig"]]()
plot(orfs, interact=FALSE)


###################################################
### code chunk number 17: expr15
###################################################
s <- c(1, genes[, "End"] + 1)
e <- c(genes[, "Begin"] - 1, width(genome))
w <- which(e - s >= 30)
intergenic <- unlist(extractAt(genome, IRanges(s[w], e[w])))
intergenic


###################################################
### code chunk number 18: expr16
###################################################
intergenic <- c(intergenic, reverseComplement(intergenic))
names(intergenic) <- c(w, paste(w, "rc", sep="_"))
clusts <- Clusterize(myXStringSet=intergenic, cutoff=0.3)


###################################################
### code chunk number 19: expr17
###################################################
t <- sort(table(clusts$cluster), decreasing=TRUE)
head(t) # the biggest clusters
AlignSeqs(intergenic[clusts$cluster == names(t)[1]], verbose=FALSE)


###################################################
### code chunk number 20: expr18
###################################################
getOption("SweaveHooks")[["fig"]]()
gc <- alphabetFrequency(intergenic, as.prob=TRUE, baseOnly=TRUE)
gc <- gc[, "G"] + gc[, "C"]
plot(width(intergenic),
	100*gc,
	xlab="Length (nucleotides)",
	ylab="GC content (%)",
	main="Intergenic regions",
	log="x")
size <- 10^seq(1, 4, 0.1)
expected <- 0.413*size
lines(size, 100*(expected + 1.96*sqrt(expected))/size)


###################################################
### code chunk number 21: expr19
###################################################
data(NonCodingRNA_Bacteria)
x <- NonCodingRNA_Bacteria
names(x)


###################################################
### code chunk number 22: expr20
###################################################
rnas <- FindNonCoding(x, genome)
rnas


###################################################
### code chunk number 23: expr21
###################################################
annotations <- attr(rnas, "annotations")
m <- match(rnas[, "Gene"], annotations)
sort(table(names(annotations)[m]))


###################################################
### code chunk number 24: expr22
###################################################
genes <- FindGenes(genome, includeGenes=rnas)
genes


###################################################
### code chunk number 25: expr23
###################################################
fas <- system.file("extdata",
	"PlanctobacteriaNamedGenes.fas.gz",
	package="DECIPHER")
prot <- readAAStringSet(fas)
prot
head(names(prot))


###################################################
### code chunk number 26: expr24
###################################################
trainingSet <- LearnTaxa(train=prot,
	taxonomy=names(prot),
	maxChildren=1)
trainingSet


###################################################
### code chunk number 27: expr25
###################################################
getOption("SweaveHooks")[["fig"]]()
w <- which(genes[, "Gene"] > 0)
aa <- ExtractGenes(genes[w], genome, type="AAStringSet")
ids <- IdTaxa(aa,
	trainingSet,
	fullLength=0.99,
	threshold=50,
	processors=1)
ids
plot(trainingSet, ids[grep("unclassified", ids, invert=TRUE)])


###################################################
### code chunk number 28: expr26
###################################################
annotations <- sapply(ids, function(x) paste(x$taxon[-1], collapse="; "))
u_annotations <- unique(annotations)
genes[w, "Gene"] <- match(annotations, u_annotations) + 1L
attr(genes, "annotations") <- c(attr(genes, "annotations"),
	setNames(seq_along(u_annotations) + 1L,
		u_annotations))
genes


###################################################
### code chunk number 29: expr27
###################################################
annotations <- attr(genes, "annotations")
m <- match(genes[, "Gene"], annotations)
head(sort(table(names(annotations)[m]), decreasing=TRUE))


###################################################
### code chunk number 30: expr28 (eval = FALSE)
###################################################
## set.seed(123) # choose a whole number as the random seed
## # then make gene predictions with FindGenes (not shown)
## set.seed(NULL) # return to the original state by unsetting the seed


###################################################
### code chunk number 31: sessinfo
###################################################
toLatex(sessionInfo(), locale=FALSE)


