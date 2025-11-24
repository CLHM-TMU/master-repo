### R code from vignette source 'ArtOfAlignmentInR.Rnw'

###################################################
### code chunk number 1: ArtOfAlignmentInR.Rnw:51-53
###################################################
options(continue=" ")
options(width=80)


###################################################
### code chunk number 2: expr0
###################################################
library(DECIPHER)
n_points <- 10
N0 <- ceiling(2^seq(5, 13, length.out=n_points))
N1 <- ceiling(2^seq(5, 12, length.out=n_points))
N2 <- ceiling(2^seq(5, 13, length.out=n_points))
N3 <- ceiling(2^seq(5, 16, length.out=n_points))
timings0 <- setNames(rep(0, length(N0)), N0)
timings1 <- setNames(rep(0, length(N1)), N1)
timings2 <- setNames(rep(0, length(N2)), N2)
timings3 <- setNames(rep(0, length(N3)), N3)
for (i in seq_len(length(N0))) {
	for (j in 0:3) {
		N <- eval(parse(text=paste("N", j, sep="")))
		# simulate sequences with 15% distance
		string1 <- DNAStringSet(paste(sample(DNA_ALPHABET[1:4], N[i], replace = TRUE), collapse = ""))
		string2 <- replaceAt(string1,
			at=IRanges(sample(N[i], ceiling(N[i]/5)), width=1),
			sample(c(DNA_ALPHABET[1:4], ""), ceiling(N[i]/5), replace = TRUE))
		# align the sequences using two methods
		if (j==0) {
			timings0[i] <- system.time(pairwiseAlignment(string1, string2))[["user.self"]]
		} else if (j==1) {
			timings1[i] <- system.time(AlignProfiles(string1, string2, restrict=c(-1e10, 1e10, 1e10), anchor=NA))[["user.self"]]
		} else if (j==2) {
			timings2[i] <- system.time(AlignProfiles(string1, string2, anchor=NA))[["user.self"]]
		} else { # j == 3
			timings3[i] <- system.time(AlignProfiles(string1, string2))[["user.self"]]
		}
	}
}

c0 <- lm(timings0 ~ N0 + I(N0^2))
c1 <- lm(timings1 ~ N1 + I(N1^2))
c2 <- lm(timings2 ~ N2)
c3 <- lm(timings3 ~ N3)

N <- seq(1, 46340, length.out=1000) # prediction range
plot(N0, timings0,
	xlab = "Sequence length (nucleotides)",
	ylab = "Elapsed Time (sec.)",
	main = "",
	ylim=c(range(timings0,
		timings1,
		timings2,
		timings3,
		predict(c2, data.frame(N2=46340)))),
	xlim=c(0, max(N3)))
points(N, predict(c0,
		data.frame(N0 = N)),
	type="l", lty=3)
points(N1, timings1,
	col="blue", pch=0)
points(N, predict(c1,
		data.frame(N1 = N)),
	type="l", lty=3, col="blue")
points(N2, timings2,
	col="red", pch=5)
points(N, predict(c2,
		data.frame(N2 = N)),
	type="l", lty=3, col="red")
N <- seq(1, max(N3), length.out=1000) # prediction range
points(N3, timings3,
	col="green", pch=2)
points(N, predict(c3,
		data.frame(N3 = N)),
	type="l", lty=3, col="green")
legend("bottomright",
	c("Biostrings::pairwiseAlignment",
		"AlignProfiles (unrestricted, unanchored)",
		"AlignProfiles (restricted, unanchored)",
		"AlignProfiles (restricted, anchored)"),
	pch=c(1, 0, 5, 2), lty=3,
	col=c("black", "blue", "red", "green"), bg="white")


###################################################
### code chunk number 3: expr1
###################################################
library(DECIPHER)

# specify the path to your sequence file:
fas <- "<<path to FASTA file>>"
# OR find the example sequence file used in this tutorial:
fas <- system.file("extdata", "50S_ribosomal_protein_L2.fas", package="DECIPHER")

dna <- readDNAStringSet(fas)
dna # the unaligned sequences


###################################################
### code chunk number 4: expr2 (eval = FALSE)
###################################################
## AA <- AlignTranslation(dna, type="AAStringSet") # align the translation
## BrowseSeqs(AA, highlight=1) # view the alignment
## 
## DNA <- AlignSeqs(dna) # align the sequences directly without translation
## DNA <- AlignTranslation(dna) # align the translation then reverse translate
## 
## # write the aligned sequences to a FASTA file
## writeXStringSet(DNA, file="<<path to output file>>")


###################################################
### code chunk number 5: expr3 (eval = FALSE)
###################################################
## u_dna <- unique(dna) # the unique input sequences
## index <- match(dna, u_dna) # de-replication index
## 
## U_DNA <- AlignSeqs(u_dna) # align the sequences directly without translation
## DNA <- U_DNA[index]
## names(DNA) <- names(dna) # the re-replicated alignment


###################################################
### code chunk number 6: expr4 (eval = FALSE)
###################################################
## # database containing 16S ribosomal RNA sequences
## db <- system.file("extdata", "Bacteria_175seqs.sqlite", package="DECIPHER")
## 
## rna <- SearchDB(db, remove="all", type="RNAStringSet")
## # or if starting with DNA sequences, convert to RNA with:
## # rna <- RNAStringSet(dna)
## # or import RNA sequences directly using:
## # rna <- readRNAStringSet("<<path to FASTA file>>")
## 
## alignedRNA <- AlignSeqs(rna) # align with RNA secondary structure


###################################################
### code chunk number 7: expr6 (eval = FALSE)
###################################################
## half <- floor(length(dna)/2)
## dna1 <- dna[1:half] # first half
## dna2 <- dna[(half + 1):length(dna)] # second half
## 
## AA1 <- AlignTranslation(dna1, type="AAStringSet")
## AA2 <- AlignTranslation(dna2, type="AAStringSet")
## AA <- AlignProfiles(AA1, AA2) # align two alignments


###################################################
### code chunk number 8: expr7 (eval = FALSE)
###################################################
## # Align DNA sequences stored in separate tables:
## dbConn <- dbConnect(SQLite(), ":memory:")
## Seqs2DB(AA1, "DNAStringSet", dbConn, "AA1", tblName="AA1")
## Seqs2DB(AA2, "DNAStringSet", dbConn, "AA2", tblName="AA2")
## AlignDB(dbConn, tblName=c("AA1", "AA2"), add2tbl="AA",
##         type="AAStringSet")
## AA <- SearchDB(dbConn, tblName="AA", type="AAStringSet")
## BrowseDB(dbConn, tblName="AA")
## dbDisconnect(dbConn)


###################################################
### code chunk number 9: expr5 (eval = FALSE)
###################################################
## # form a chained guide tree
## gT <- lapply(order(width(dna), decreasing=TRUE),
## 	function(x) {
## 		attr(x, "height") <- 0
## 		attr(x, "label") <- names(dna)[x]
## 		attr(x, "members") <- 1L
## 		attr(x, "leaf") <- TRUE
## 		x
## 	})
## attr(gT, "height") <- 0.5
## attr(gT, "members") <- length(dna)
## class(gT) <- "dendrogram"
## 
## # use the guide tree as input for alignment
## DNA <- AlignTranslation(dna,
## 	guideTree=gT,
## 	iterations=0,
## 	refinements=0)


###################################################
### code chunk number 10: expr8 (eval = FALSE)
###################################################
## BrowseSeqs(DNA, highlight=0)


###################################################
### code chunk number 11: expr9 (eval = FALSE)
###################################################
## DNA_adjusted <- AdjustAlignment(DNA)


###################################################
### code chunk number 12: expr10 (eval = FALSE)
###################################################
## DNA_staggered <- StaggerAlignment(DNA)


###################################################
### code chunk number 13: expr11
###################################################
db <- system.file("extdata", "Influenza.sqlite", package="DECIPHER")
synteny <- FindSynteny(db, verbose=FALSE)
synteny # an object of class `Synteny`
InfluenzaA <- AlignSynteny(synteny, db, verbose=FALSE)
unlist(InfluenzaA[[1]])


###################################################
### code chunk number 14: expr12
###################################################
pairs(synteny, boxBlocks=TRUE) # scatterplot matrix


###################################################
### code chunk number 15: sessinfo
###################################################
toLatex(sessionInfo(), locale=FALSE)


