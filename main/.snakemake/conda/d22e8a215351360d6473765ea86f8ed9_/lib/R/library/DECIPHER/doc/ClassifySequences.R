### R code from vignette source 'ClassifySequences.Rnw'

###################################################
### code chunk number 1: ClassifySequences.Rnw:47-50
###################################################
options(continue=" ")
options(width=80)
set.seed(123)


###################################################
### code chunk number 2: startup
###################################################
library(DECIPHER)


###################################################
### code chunk number 3: expr1 (eval = FALSE)
###################################################
## # specify the path to your file of training sequences:
## seqs_path <- "<<path to training FASTA file>>"
## # read the sequences into memory
## seqs <- readDNAStringSet(seqs_path)
## # Alternatively use readAAStringSet or readRNAStringSet
## 
## # (optionally) specify a path to the taxid file:
## rank_path <- "<<path to taxid text file>>"
## taxid <- read.table(rank_path,
## 	header=FALSE,
## 	col.names=c('Index', 'Name', 'Parent', 'Level', 'Rank'),
## 	sep="*", # asterisks delimited
## 	quote="", # preserve quotes
## 	stringsAsFactors=FALSE)
## # OR, if no taxid text file exists, use:
## #taxid <- NULL


###################################################
### code chunk number 4: expr2 (eval = FALSE)
###################################################
## # if they exist, remove any gaps in the sequences:
## seqs <- RemoveGaps(seqs)


###################################################
### code chunk number 5: expr3 (eval = FALSE)
###################################################
## # ensure that all sequences are in the same orientation:
## seqs <- OrientNucleotides(seqs)


###################################################
### code chunk number 6: expr4 (eval = FALSE)
###################################################
## # obtain the taxonomic assignments
## groups <- names(seqs) # sequence names
## # assume the taxonomy begins with 'Root;'
## groups <- gsub("(.*)(Root;)", "\\2", groups) # extract the group label
## groupCounts <- table(groups)
## u_groups <- names(groupCounts) # unique groups
## length(u_groups) # number of groups


###################################################
### code chunk number 7: expr5 (eval = FALSE)
###################################################
## maxGroupSize <- 10 # max sequences per label (>= 1)
## 
## remove <- logical(length(seqs))
## for (i in which(groupCounts > maxGroupSize)) {
## 	index <- which(groups==u_groups[i])
## 	keep <- sample(length(index),
## 		maxGroupSize)
## 	remove[index[-keep]] <- TRUE
## }
## sum(remove) # number of sequences eliminated


###################################################
### code chunk number 8: expr6 (eval = FALSE)
###################################################
## maxIterations <- 3 # must be >= 1
## allowGroupRemoval <- FALSE
## 
## probSeqsPrev <- integer() # suspected problem sequences from prior iteration
## for (i in seq_len(maxIterations)) {
## 	cat("Training iteration: ", i, "\n", sep="")
## 	
## 	# train the classifier
## 	trainingSet <- LearnTaxa(seqs[!remove],
## 		names(seqs)[!remove],
## 		taxid)
## 	
## 	# look for problem sequences
## 	probSeqs <- trainingSet$problemSequences$Index
## 	if (length(probSeqs)==0) {
## 		cat("No problem sequences remaining.\n")
## 		break
## 	} else if (length(probSeqs)==length(probSeqsPrev) &&
## 		all(probSeqsPrev==probSeqs)) {
## 		cat("Iterations converged.\n")
## 		break
## 	}
## 	if (i==maxIterations)
## 		break
## 	probSeqsPrev <- probSeqs
## 	
## 	# remove any problem sequences
## 	index <- which(!remove)[probSeqs]
## 	remove[index] <- TRUE # remove all problem sequences
## 	if (!allowGroupRemoval) {
## 		# replace any removed groups
## 		missing <- !(u_groups %in% groups[!remove])
## 		missing <- u_groups[missing]
## 		if (length(missing) > 0) {
## 			index <- index[groups[index] %in% missing]
## 			remove[index] <- FALSE # don't remove
## 		}
## 	}
## }
## sum(remove) # total number of sequences eliminated
## length(probSeqs) # number of remaining problem sequences


###################################################
### code chunk number 9: expr7
###################################################
data("TrainingSet_16S")
trainingSet <- TrainingSet_16S


###################################################
### code chunk number 10: expr8
###################################################
trainingSet


###################################################
### code chunk number 11: expr9
###################################################
plot(trainingSet)


###################################################
### code chunk number 12: expr10
###################################################
fas <- "<<path to FASTA file>>"
# OR use the example 16S sequences:
fas <- system.file("extdata",
	"Bacteria_175seqs.fas",
	package="DECIPHER")

# read the sequences into memory
test <- readDNAStringSet(fas)
# Alternatively use readAAStringSet or readRNAStringSet


###################################################
### code chunk number 13: expr11
###################################################
# if they exist, remove any gaps in the sequences:
test <- RemoveGaps(test)
test


###################################################
### code chunk number 14: expr12
###################################################
ids <- IdTaxa(test,
	trainingSet,
	type="extended",
	strand="top",
	threshold=60,
	processors=1)


###################################################
### code chunk number 15: expr13
###################################################
ids


###################################################
### code chunk number 16: expr14
###################################################
ids[1:5] # summary results for the first 5 sequences
ids[[1]] # results for the first sequence
ids[c(10, 25)] # combining different sequences
c(ids[10], ids[25]) # merge different sets
ids[, c("rootrank", "domain", "class")] # only look at specific rank levels
ids[threshold=70] # threshold the results at a higher confidence


###################################################
### code chunk number 17: expr15
###################################################
assignment <- sapply(ids,
	function(x)
		paste(x$taxon,
			collapse=";"))
head(assignment)


###################################################
### code chunk number 18: expr16
###################################################
plot(ids, trainingSet)


###################################################
### code chunk number 19: expr17
###################################################
phylum <- sapply(ids,
	function(x) {
		w <- which(x$rank=="phylum")
		if (length(w) != 1) {
			"unknown"
		} else {
			x$taxon[w]
		}
	})
table(phylum)

taxon <- sapply(ids,
	function(x)
		x$taxon[length(x$taxon)])
head(taxon)


###################################################
### code chunk number 20: expr18
###################################################
# get a vector with the sample name for each sequence
samples <- gsub(".*; (.+?)_.*", "\\1", names(test))
taxaTbl <- table(taxon, samples)
taxaTbl <- t(t(taxaTbl)/colSums(taxaTbl)) # normalize by sample
head(taxaTbl)


###################################################
### code chunk number 21: expr19
###################################################
include <- which(rowMeans(taxaTbl) >= 0.04)
barplot(taxaTbl[include,],
	legend=TRUE,
	col=rainbow(length(include), s=0.4),
	ylab="Relative abundance",
	ylim=c(0, 1),
	las=2, # vertical x-axis labels
	args.legend=list(x="topleft", bty="n", ncol=2))


###################################################
### code chunk number 22: expr20
###################################################
output <- sapply(ids,
	function (id) {
		paste(id$taxon,
			" (",
			round(id$confidence, digits=1),
			"%)",
			sep="",
			collapse="; ")
	})
tail(output)
#writeLines(output, "<<path to output text file>>")


###################################################
### code chunk number 23: expr21 (eval = FALSE)
###################################################
## set.seed(123) # choose a whole number as the random seed
## # then classify sequences with IdTaxa (not shown)
## set.seed(NULL) # return to the original state by unsetting the seed


###################################################
### code chunk number 24: expr22 (eval = FALSE)
###################################################
## ranks <- readLines("<<path to lines of text>>")
## taxa <- setNames(c("domain", "phylum", "order", "family", "genus"),
## 		c("d__", "p__", "o__", "f__", "g__"))
## 
## ranks <- strsplit(ranks, ";", fix=T)
## count <- 1L
## groups <- "Root"
## index <- -1L
## level <- 0L
## rank <- "rootrank"
## pBar <- txtProgressBar(style=3)
## for (i in seq_along(ranks)) {
## 	for (j in seq_along(ranks[[i]])) {
## 		rank_level <- taxa[substring(ranks[[i]][j], 1, 3)]
## 		group <- substring(ranks[[i]][j], 4)
## 		w <- which(groups==group & rank==rank_level)
## 		if (length(w) > 0) {
## 			parent <- match(substring(ranks[[i]][j - 1], 4),
## 				groups)
## 			if (j==1 || any((parent - 1L)==index[w]))
## 				next # already included
## 		}
## 		
## 		count <- count + 1L
## 		groups <- c(groups, group)
## 		if (j==1) {
## 			index <- c(index, 0)
## 		} else {
## 			parent <- match(substring(ranks[[i]][j - 1], 4),
## 				groups)
## 			index <- c(index,
## 				parent - 1L)
## 		}
## 		level <- c(level, j)
## 		rank <- c(rank, taxa[j])
## 	}
## 	
## 	setTxtProgressBar(pBar, i/length(ranks))
## }
## groups <- gsub("^[ ]+", "", groups)
## groups <- gsub("[ ]+$", "", groups)
## 
## taxid <- paste(0:(length(index) - 1L), groups, index, level, rank, sep="*")
## head(taxid, n=10)


###################################################
### code chunk number 25: expr23 (eval = FALSE)
###################################################
## writeLines(taxid,
## 	con="<<path to taxid file>>")


###################################################
### code chunk number 26: expr24
###################################################
fas <- system.file("extdata",
	"PlanctobacteriaNamedGenes.fas.gz",
	package="DECIPHER")
aa <- readAAStringSet(fas)
aa
head(names(aa))


###################################################
### code chunk number 27: expr25
###################################################
aa <- aa[!grepl("Root;NoEC", names(aa), fixed=TRUE)]
aa


###################################################
### code chunk number 28: expr26
###################################################
trainingSet <- LearnTaxa(train=aa,
	taxonomy=names(aa),
	maxChildren=1)


###################################################
### code chunk number 29: expr27
###################################################
fas <- system.file("extdata",
	"Chlamydia_trachomatis_NC_000117.fas.gz",
	package="DECIPHER")
genome <- readDNAStringSet(fas)
genes <- FindGenes(genome, verbose=FALSE)
test <- ExtractGenes(genes, genome, type="AAStringSet")
test


###################################################
### code chunk number 30: expr28
###################################################
ids <- IdTaxa(test,
	trainingSet,
	fullLength=0.99,
	threshold=50,
	processors=1)
ids


###################################################
### code chunk number 31: expr29
###################################################
unclassified <- sapply(ids,
	function(x)
		"unclassified_Root" %in% x$taxon)
plot(ids[!unclassified, 1:2])


###################################################
### code chunk number 32: sessinfo
###################################################
toLatex(sessionInfo(), locale=FALSE)


