### R code from vignette source 'RepeatRepeat.Rnw'

###################################################
### code chunk number 1: RepeatRepeat.Rnw:51-53
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
Ig <- AAStringSet("VRALPARFTEGLRNEEAMEGATATLQCELSKAAPVEWRKGLEALRDGDKYSLRQDGAVCELQIHGLAMADNGVYSCVCGQERTSATLT")
Ig


###################################################
### code chunk number 4: expr2
###################################################
# specify the path to your file of sequences:
fas <- "<<path to training FASTA file>>"
# OR use the example DNA sequences:
fas <- system.file("extdata",
	"LongHumanProteins.fas.gz",
	package="DECIPHER")
# read the sequences into memory
DNA <- readDNAStringSet(fas)
DNA


###################################################
### code chunk number 5: expr3
###################################################
AA <- translate(DNA)
AA
names(AA)
index <- 2
AA <- AA[index]


###################################################
### code chunk number 6: expr4
###################################################
getOption("SweaveHooks")[["fig"]]()
windows <- extractAt(AA[[1]],
	IRanges(seq_len(width(AA[1]) - width(Ig)),
		width=width(Ig)))
p <- pairwiseAlignment(windows, Ig)
plot(score(p), ylab="Score", xlab="Amino acid position", type="l")


###################################################
### code chunk number 7: expr5
###################################################
reps <- DetectRepeats(AA, allScores=TRUE)
reps[which.max(reps[, "Score"]),]


###################################################
### code chunk number 8: expr6
###################################################
getOption("SweaveHooks")[["fig"]]()
plot(NA,
	xlim=c(0, max(width(AA))),
	ylim=range(0, reps[, "Score"]),
	xlab="Position in protein",
	ylab="Tandem repeat score")
for (i in seq_len(nrow(reps)))
	segments(reps[[i, "Left"]],
		reps[i, "Score"],
		reps[[i, "Right"]],
		reps[i, "Score"],
		col=seq_along(reps[[i, "Left"]]))


###################################################
### code chunk number 9: expr7
###################################################
i <- which.max(reps[, "Score"])
seqs <- extractAt(AA[[reps[i, "Index"]]],
	IRanges(reps[[i, "Left"]], reps[[i, "Right"]]))
seqs <- AlignSeqs(seqs, verbose=FALSE) # align the repeats
names(seqs) <- seq_along(seqs) # number from left to right
seqs


###################################################
### code chunk number 10: expr8
###################################################
getOption("SweaveHooks")[["fig"]]()
d <- DistanceMatrix(seqs)
dend <- TreeLine(myDistMatrix=d, method="NJ", verbose=FALSE)
dend <- reorder(dend, seq_along(seqs))
layout(matrix(1:2))
plot(dend)
plot(unlist(dend), xlab="Position on tree", ylab="Repeat number")
abline(a=0, b=1)


###################################################
### code chunk number 11: sessinfo
###################################################
toLatex(sessionInfo(), locale=FALSE)


