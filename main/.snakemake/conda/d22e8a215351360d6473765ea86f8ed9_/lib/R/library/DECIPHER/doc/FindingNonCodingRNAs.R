### R code from vignette source 'FindingNonCodingRNAs.Rnw'

###################################################
### code chunk number 1: FindingNonCodingRNAs.Rnw:47-49
###################################################
options(continue=" ")
options(width=80)


###################################################
### code chunk number 2: startup
###################################################
library(DECIPHER)


###################################################
### code chunk number 3: expr1
###################################################
# specify the path to your genome:
fas_path <- "<<path to FASTA file>>"
# OR use the example genome:
fas_path <- system.file("extdata",
	"IhtA.fas",
	package="DECIPHER")

# read the sequences into memory
rna <- readRNAStringSet(fas_path)
rna


###################################################
### code chunk number 4: expr2
###################################################
RNA <- AlignSeqs(rna)
RNA


###################################################
### code chunk number 5: expr3
###################################################
p <- PredictDBN(RNA, type="structures")
BrowseSeqs(RNA, patterns=p)


###################################################
### code chunk number 6: expr4
###################################################
getOption("SweaveHooks")[["fig"]]()
evidence <- PredictDBN(RNA, type="evidence", threshold=0, verbose=FALSE)
pairs <- PredictDBN(RNA, type="pairs", verbose=FALSE)
dots <- matrix(0, width(RNA)[1], width(RNA)[1])
dots[evidence[, 1:2]] <- evidence[, 3]
dots[pairs[, 2:1]] <- 1

image(dots, xaxt="n", yaxt="n", col=gray(seq(1, 0, -0.01)))
abline(a=0, b=1)
cons <- toString(ConsensusSequence(RNA, threshold=0.2))
cons <- strsplit(cons, "")[[1]]
at <- seq(0, 1, length.out=length(cons))
axis(1, at, cons, tick=FALSE, cex.axis=0.3, gap.axis=0, line=-1)
axis(2, at, cons, tick=FALSE, cex.axis=0.3, gap.axis=0, line=-1)


###################################################
### code chunk number 7: expr5
###################################################
RNA <- unique(RNA)
t <- TerminalChar(RNA)
w <- which(t[, "leadingChar"] <= median(t[, "leadingChar"]) &
	t[, "trailingChar"] <= median(t[, "trailingChar"]))
RNA <- RemoveGaps(RNA[w], "common")


###################################################
### code chunk number 8: expr6
###################################################
y <- LearnNonCoding(RNA)
y


###################################################
### code chunk number 9: expr7
###################################################
y[["motifs"]]


###################################################
### code chunk number 10: expr8
###################################################
y[["hairpins"]]


###################################################
### code chunk number 11: expr9
###################################################
head(y[["kmers"]])
tail(y[["kmers"]])


###################################################
### code chunk number 12: expr10
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
### code chunk number 13: expr11
###################################################
FindNonCoding(y, genome)


###################################################
### code chunk number 14: expr12
###################################################
data(NonCodingRNA_Bacteria)
x <- NonCodingRNA_Bacteria
names(x)


###################################################
### code chunk number 15: expr13
###################################################
x[[length(x) + 1]] <- y
names(x)[length(x)] <- "IhtA"


###################################################
### code chunk number 16: expr14
###################################################
rnas <- FindNonCoding(x, genome)
rnas
class(rnas)


###################################################
### code chunk number 17: expr15
###################################################
annotations <- attr(rnas, "annotations")
m <- match(rnas[, "Gene"], annotations)
sort(table(names(annotations)[m]))


###################################################
### code chunk number 18: expr16
###################################################
ExtractGenes(rnas, genome, type="RNAStringSet")


###################################################
### code chunk number 19: sessinfo
###################################################
toLatex(sessionInfo(), locale=FALSE)


