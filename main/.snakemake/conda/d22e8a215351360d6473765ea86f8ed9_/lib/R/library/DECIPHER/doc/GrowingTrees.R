### R code from vignette source 'GrowingTrees.Rnw'

###################################################
### code chunk number 1: GrowingTrees.Rnw:51-53
###################################################
options(continue=" ")
options(width=80)


###################################################
### code chunk number 2: expr1
###################################################
library(DECIPHER)

# specify the path to your sequence file:
fas <- "<<path to FASTA file>>"
# OR find the example sequence file used in this tutorial:
fas <- system.file("extdata", "Streptomyces_ITS_aligned.fas", package="DECIPHER")

seqs <- readDNAStringSet(fas) # use readAAStringSet for amino acid sequences
seqs # the aligned sequences


###################################################
### code chunk number 3: expr2
###################################################
seqs <- unique(seqs) # remove duplicated sequences

ns <- gsub("^.*Streptomyces( subsp\\. | sp\\. | | sp_)([^ ]+).*$", "\\2", names(seqs))
names(seqs) <- ns # name by species
seqs <- seqs[!duplicated(ns)] # remove redundant sequences from the same species
seqs


###################################################
### code chunk number 4: expr3
###################################################
getOption("SweaveHooks")[["fig"]]()
set.seed(123) # set the random number seed

tree <- TreeLine(seqs,
	method="ML",
	model="GTR+G4",
	reconstruct=TRUE,
	maxTime=0.01)

set.seed(NULL) # reset seed

plot(tree)


###################################################
### code chunk number 5: expr4
###################################################
attributes(tree) # view all attributes
attr(tree, "score") # best score


###################################################
### code chunk number 6: expr5
###################################################
getOption("SweaveHooks")[["fig"]]()
plot(dendrapply(tree,
	function(x) {
		s <- attr(x, "probability") # choose "probability" (aBayes) or "support"
		if (!is.null(s) && !is.na(s)) {
			s <- formatC(as.numeric(s), digits=2, format="f")
			attr(x, "edgetext") <- paste(s, "\n")
		}
		attr(x, "edgePar") <- list(p.col=NA, p.lwd=1e-5, t.col="#CC55AA", t.cex=0.7)
		if (is.leaf(x))
			attr(x, "nodePar") <- list(lab.font=3, pch=NA)
		x
	}),
	horiz=TRUE,
	yaxt='n')
# add a scale bar
arrows(0, 0, 0.4, 0, code=3, angle=90, len=0.05, xpd=TRUE)
text(0.2, 0, "0.4 subs./site", pos=3, xpd=TRUE)


###################################################
### code chunk number 7: expr6
###################################################
getOption("SweaveHooks")[["fig"]]()
getSupports <- function(x) {
	if (is.leaf(x)) {
		NULL
	} else if (is.null(attr(x, "support"))) {
		rbind(getSupports(x[[1]]), getSupports(x[[2]]))
	} else {
		rbind(cbind(attr(x, "support"),
				attr(x, "probability"),
				attr(x, "members")),
			getSupports(x[[1]]), getSupports(x[[2]]))
	}
}
support <- getSupports(tree)
plot(support[, 1],
	support[, 2],
	cex=log10(support[, 3]),
	xlab="Support", ylab="aBayes probability", asp=1)
abline(a=0, b=1, lty=2) # line of identity (y=x)


###################################################
### code chunk number 8: expr7
###################################################
getOption("SweaveHooks")[["fig"]]()
new_tree <- MapCharacters(tree, labelEdges=TRUE)
plot(new_tree, edgePar=list(p.col=NA, p.lwd=1e-5, t.col="#55CC99", t.cex=0.7))
attr(new_tree[[1]], "change") # state changes on first branch left of (virtual) root


###################################################
### code chunk number 9: expr8
###################################################
WriteDendrogram(tree, file="")


###################################################
### code chunk number 10: expr9
###################################################
params <- attr(tree, "parameters")
cat("[", paste(names(params), params, sep="=", collapse=","), "]", sep="", append=TRUE, file="")


###################################################
### code chunk number 11: sessinfo
###################################################
toLatex(sessionInfo(), locale=FALSE)


