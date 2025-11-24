### R code from vignette source 'DesignPrimers.Rnw'

###################################################
### code chunk number 1: DesignPrimers.Rnw:46-48
###################################################
options(continue=" ")
options(width=80)


###################################################
### code chunk number 2: expr0 (eval = FALSE)
###################################################
## system("hybrid-min -V")


###################################################
### code chunk number 3: startup
###################################################
library(DECIPHER)


###################################################
### code chunk number 4: expr1
###################################################
# specify the path to your sequence file:
fas <- "<<path to FASTA file>>"
# OR find the example sequence file used in this tutorial:
fas <- system.file("extdata", "Streptomyces_ITS_aligned.fas", package="DECIPHER")


###################################################
### code chunk number 5: expr2
###################################################
# specify a path for where to write the sequence database
dbConn <- "<<path to write sequence database>>"
# OR create the sequence database in memory
dbConn <- dbConnect(SQLite(), ":memory:")
Seqs2DB(fas, "FASTA", dbConn, "Streptomyces")


###################################################
### code chunk number 6: expr3
###################################################
# get the FASTA record description
desc <- dbGetQuery(dbConn, "select description from Seqs")
# parse the sequence description to obtain the species name
desc <- unlist(lapply(strsplit(desc$description, "Streptomyces ", fixed=TRUE),
	function(x) return(x[length(x)])))
desc <- gsub("sp. ", "", desc, perl=TRUE)
desc <- gsub("sp_", "", desc, perl=TRUE)
desc <- unlist(lapply(strsplit(desc, " ", fixed=TRUE), function(x) return(x[1])))
unique(desc)


###################################################
### code chunk number 7: expr4
###################################################
Add2DB(data.frame(identifier=desc, stringsAsFactors=FALSE), dbConn)


###################################################
### code chunk number 8: expr5 (eval = FALSE)
###################################################
## tiles <- TileSeqs(dbConn, add2tbl="Tiles", minCoverage=1)


###################################################
### code chunk number 9: expr6 (eval = FALSE)
###################################################
## head(tiles)


###################################################
### code chunk number 10: expr7 (eval = FALSE)
###################################################
## primers <- DesignPrimers(tiles, identifier="avermitilis",
## 	minCoverage=1, minGroupCoverage=1)


###################################################
### code chunk number 11: expr8 (eval = FALSE)
###################################################
## primers[1,]


###################################################
### code chunk number 12: expr10 (eval = FALSE)
###################################################
## primers <- DesignPrimers(tiles, identifier="avermitilis", minCoverage=1,
## 	minGroupCoverage=1, numPrimerSets=5, maxSearchSize=20)


###################################################
### code chunk number 13: expr11 (eval = FALSE)
###################################################
## head(primers)


###################################################
### code chunk number 14: expr12 (eval = FALSE)
###################################################
## temp_range <- 60:75
## ps <- c("CGTTGATTATTCGGCACACTCGAC", "CCCTCGCCCTCCCATGT") # forward and reverse
## f <- function(temp) {
## 	CalculateEfficiencyPCR(ps, reverseComplement(DNAStringSet(ps)),
## 		temp, P=4e-7, ions=.225)
## }
## efficiency <- matrix(unlist(lapply(temp_range, f)), ncol=2, byrow=TRUE)
## plot(temp_range, efficiency[,1], ylim=c(0,1), ylab="Hybridization Efficiency",
## 	xlab=expression(paste("Temperature (", degree, "C)", sep="")),
## 	type="l", lwd=2, col="Blue", main="Denaturation Plot")
## lines(temp_range, efficiency[,2], col="Red", lwd=2)
## abline(h=0.5, lty=2, lwd=2, col="Orange")
## abline(v=64, lty=2, lwd=2, col="Green")
## legend("topright", legend=c("Forward Primer", "Reverse Primer", "50% Efficiency",
## 	"Annealing Temperature"), col=c("Blue", "Red", "Orange", "Green"),
## 	lwd=c(2, 2, 2, 2), lty=c(1, 1, 2, 2))


###################################################
### code chunk number 15: expr13
###################################################
dna <- SearchDB(dbConn)
dbDisconnect(dbConn)
amplicon <- subseq(dna, 247, 348)
names(amplicon) <- desc
# only show unique sequences
u_amplicon <- unique(amplicon)
names(u_amplicon) <- names(amplicon)[match(u_amplicon, amplicon)]
amplicon <- u_amplicon
# move the target group to the top
w <- which(names(amplicon)=="avermitilis")
amplicon <- c(amplicon[w], amplicon[-w])


###################################################
### code chunk number 16: expr14 (eval = FALSE)
###################################################
## BrowseSeqs(amplicon, colorPatterns=c(4, 27, 76, 94), highlight=1)


###################################################
### code chunk number 17: sessinfo
###################################################
toLatex(sessionInfo(), locale=FALSE)


