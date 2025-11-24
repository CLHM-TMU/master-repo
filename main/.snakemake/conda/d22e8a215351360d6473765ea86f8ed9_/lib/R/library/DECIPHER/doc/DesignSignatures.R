### R code from vignette source 'DesignSignatures.Rnw'

###################################################
### code chunk number 1: DesignSignatures.Rnw:46-48
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
# specify the path to your sequence file:
fas <- "<<path to FASTA file>>"
# OR find the example sequence file used in this tutorial:
fas <- system.file("extdata", "IDH2.fas", package="DECIPHER")


###################################################
### code chunk number 4: expr2
###################################################
# specify a path for where to write the sequence database
dbConn <- "<<path to write sequence database>>"
# OR create the sequence database in memory
dbConn <- dbConnect(SQLite(), ":memory:")
N <- Seqs2DB(fas, "FASTA", dbConn, "")
N # number of sequences in the database


###################################################
### code chunk number 5: expr3
###################################################
# if each sequence belongs to its own group,
# then identify the sequences with a number:
desc <- as.character(seq_len(N)) # N is the number of sequences
# OR get the FASTA record description:
desc <- dbGetQuery(dbConn, "select description from Seqs")$description
# show the unique descriptors:
unique(desc)


###################################################
### code chunk number 6: expr4
###################################################
Add2DB(data.frame(identifier=desc, stringsAsFactors=FALSE), dbConn)


###################################################
### code chunk number 7: expr5a
###################################################
# Designing primers for sequencing experiments:
TYPE <- "sequence"
MIN_SIZE <- 300 # base pairs
MAX_SIZE <- 700
RESOLUTION <- 5 # k-mer signature
LEVELS <- 5 # max number of each k-mer


###################################################
### code chunk number 8: expr5b
###################################################
# Designing primers for community fingerprinting (FLP):
TYPE <- "length"
# it is important to have a width range of lengths
MIN_SIZE <- 200 # base pairs
MAX_SIZE <- 1400
# define bin boundaries for distinguishing length,
# the values below require high-resolution, but
# the bin boundaries can be redefined for lower
# resolution experiments such as gel runs
RESOLUTION <- c(seq(200, 700, 3),
                seq(705, 1000, 5),
                seq(1010, 1400, 10))
LEVELS <- 2 # presence/absence of the length


###################################################
### code chunk number 9: expr5c
###################################################
# Designing primers for high resolution melting (HRM):
TYPE <- "melt"
MIN_SIZE <- 55 # base pairs
MAX_SIZE <- 400
# the recommended values for resolution
RESOLUTION <- seq(75, 100, 0.25) # degrees Celsius
LEVELS <- 10


###################################################
### code chunk number 10: expr6
###################################################
ENZYMES <- NULL # required for sequencing
# OR select restriction enzymes to consider
data(RESTRICTION_ENZYMES) # load available enzymes
# for this tutorial we will use the enzyme MslI
ENZYMES <- RESTRICTION_ENZYMES["MslI"]
ENZYMES


###################################################
### code chunk number 11: expr7 (eval = FALSE)
###################################################
## primers <- DesignSignatures(dbConn,
##                             type=TYPE,
##                             minProductSize=MIN_SIZE,
##                             maxProductSize=MAX_SIZE,
##                             resolution=RESOLUTION,
##                             levels=LEVELS,
##                             enzymes=ENZYMES)


###################################################
### code chunk number 12: expr8 (eval = FALSE)
###################################################
## primers[which.max(primers$score),] # best primers without digestion


###################################################
### code chunk number 13: expr9 (eval = FALSE)
###################################################
## primers[which.max(primers$digest_score),] # best primers with digestion


###################################################
### code chunk number 14: expr9 (eval = FALSE)
###################################################
## PSET <- 1 # examine the top scoring primer set overall
## 
## # select the first sequence from each group
## dna <- SearchDB(dbConn,
##                 remove="all",
##                 nameBy="identifier",
##                 clause="row_names =
##                         (select min(row_names) from Seqs as S
##                          where S.identifier = Seqs.identifier)",
##                 verbose=FALSE)
## 
## f_primer <- DNAStringSet(primers$forward_primer[PSET])
## r_primer <- DNAStringSet(primers$reverse_primer[PSET])
## patterns <- c(f_primer,
##               reverseComplement(r_primer),
##               DNAStringSet(gsub("[^A-Z]", "", ENZYMES)))
## 
## BrowseSeqs(dna,
##            patterns=patterns)


###################################################
### code chunk number 15: expr10 (eval = FALSE)
###################################################
## PSET <- which.max(primers$score) # top scoring without digestion
## 
## f_primer <- DNAString(primers$forward_primer[PSET])
## r_primer <- DNAString(primers$reverse_primer[PSET])
## r_primer <- reverseComplement(r_primer)
## 
## ids <- dbGetQuery(dbConn, "select distinct identifier from Seqs")
## ids <- ids$identifier
## 
## if (TYPE=="sequence") {
##     signatures <- matrix(0, nrow=4^RESOLUTION, ncol=length(ids))
## } else if (TYPE=="melt") {
##     signatures <- matrix(0, nrow=length(RESOLUTION), ncol=length(ids))
## } else { # TYPE=="length"
##     signatures <- matrix(0, nrow=length(RESOLUTION) - 1, ncol=length(ids))
## }
## colnames(signatures) <- abbreviate(ids, 15)
## 
## for (i in seq_along(ids)) {
##     dna <- SearchDB(dbConn, identifier=ids[i], remove="all", verbose=FALSE)
##     amplicons <- matchLRPatterns(f_primer, r_primer,
##                                  MAX_SIZE, unlist(dna),
##                                  max.Lmismatch=2, max.Rmismatch=2,
##                                  Lfixed="subject", Rfixed="subject")
##     amplicons <- as(amplicons, "DNAStringSet")
##     if (length(amplicons)==0)
##         next
##     
##     if (TYPE=="sequence") {
##         signature <- oligonucleotideFrequency(amplicons, RESOLUTION)
##         signatures[, i] <- colMeans(signature)
##     } else if (TYPE=="melt") {
##         signature <- MeltDNA(amplicons, "melt curves", RESOLUTION)
##         # weight melting curves by their amlicon's width
##         signature <- t(signature)*width(amplicons)
##         signatures[, i] <- colSums(signature)/sum(width(amplicons))
##     } else { # TYPE=="length"
##         signature <- .bincode(width(amplicons), RESOLUTION)
##         for (j in signature[which(!is.na(signature))])
##             signatures[j, i] <- signatures[j, i] + 1/length(signature)
##     }
## }
## 
## if (TYPE=="sequence") {
##     d <- dist(t(signatures), "minkowski", p=1) # L1-Norm
##     TreeLine(myDistMatrix=as.matrix(d), method="UPGMA", showPlot=TRUE)
##     mtext(paste(RESOLUTION, "-mer Profile Distance", sep=""),
##         side=2, padj=-4)
## } else if (TYPE=="melt") {
##     matplot(RESOLUTION, signatures, type="l",
##         xlab="Temperature (degrees Celsius)", ylab="Average Helicity")
## } else { # TYPE=="length"
##     if (length(ids) > 20) {
##         plot(NA,
##             xlim=c(0.5, length(ids) + 0.5), ylim=range(RESOLUTION),
##             xlab="Group Index", ylab="Amplicon Length",
##             yaxs="i", xaxs="i")
##         axis(1, at=1:length(ids), labels=FALSE, tck=-0.01)
##     } else {
##         plot(NA,
##             xlim=c(0.5, length(ids) + 0.5), ylim=range(RESOLUTION),
##             xlab="", ylab="Amplicon Length",
##             yaxs="i", xaxs="i", xaxt="n")
##         axis(1, at=1:length(ids), labels=abbreviate(ids, 7), las=2)
##     }
##     xaxs <- RESOLUTION[-1] - diff(RESOLUTION)/2 # average lengths
##     for (i in seq_along(ids)) {
##         w <- which(signatures[, i] > 0)
##         if (length(w) > 0)
##             segments(i - 0.45, xaxs[w], i + 0.45, xaxs[w], lwd=2)
##     }
## }


###################################################
### code chunk number 16: expr11 (eval = FALSE)
###################################################
## PSET <- which.max(primers$digest_score) # top scoring with digestion
## 
## f_primer <- DNAString(primers$forward_primer[PSET])
## r_primer <- DNAString(primers$reverse_primer[PSET])
## r_primer <- reverseComplement(r_primer)
## enzyme <- RESTRICTION_ENZYMES[primers$enzyme[PSET]]
## 
## signatures[] <- 0 # initialize the results matrix used previously
## for (i in seq_along(ids)) {
##     dna <- SearchDB(dbConn, identifier=ids[i], remove="all", verbose=FALSE)
##     amplicons <- matchLRPatterns(f_primer, r_primer,
##                                  MAX_SIZE, unlist(dna),
##                                  max.Lmismatch=2, max.Rmismatch=2,
##                                  Lfixed="subject", Rfixed="subject")
##     amplicons <- as(amplicons, "DNAStringSet")
##     if (length(amplicons)==0)
##         next
##     digested <- DigestDNA(enzyme, amplicons, strand="top")
##     digested <- unlist(digested) # convert to DNAStringSet
##     
##     if (TYPE=="melt") {
##         signature <- MeltDNA(digested, "melt curves", RESOLUTION)
##         # weight melting curves by their fragment's width
##         signature <- t(signature)*width(digested)
##         signatures[, i] <- colSums(signature)/sum(width(digested))
##     } else { # TYPE=="length"
##         signature <- .bincode(width(digested), RESOLUTION)
##         for (j in signature[which(!is.na(signature))])
##             signatures[j, i] <- signatures[j, i] + 1/length(signature)
##     }
## }
## 
## if (TYPE=="melt") {
##     matplot(RESOLUTION, signatures, type="l",
##         xlab="Temperature (degrees Celsius)", ylab="Average Helicity")
## } else { # TYPE=="length"
##     if (length(ids) > 20) {
##         plot(NA,
##             xlim=c(0.5, length(ids) + 0.5), ylim=range(RESOLUTION),
##             xlab="Group Index", ylab="Amplicon Length",
##             yaxs="i", xaxs="i")
##         axis(1, at=1:length(ids), labels=FALSE, tck=-0.01)
##     } else {
##         plot(NA,
##             xlim=c(0.5, length(ids) + 0.5), ylim=range(RESOLUTION),
##             xlab="", ylab="Amplicon Length",
##             yaxs="i", xaxs="i", xaxt="n")
##         axis(1, at=1:length(ids), labels=abbreviate(ids, 7), las=2)
##     }
##     xaxs <- RESOLUTION[-1] - diff(RESOLUTION)/2 # average lengths
##     for (i in seq_along(ids)) {
##         w <- which(signatures[, i] > 0)
##         if (length(w) > 0)
##             segments(i - 0.45, xaxs[w], i + 0.45, xaxs[w], lwd=2)
##     }
## }


###################################################
### code chunk number 17: sessinfo
###################################################
zzz <- dbDisconnect(dbConn)
toLatex(sessionInfo(), locale=FALSE)


