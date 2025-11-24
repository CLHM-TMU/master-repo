### R code from vignette source 'DECIPHERing.Rnw'

###################################################
### code chunk number 1: DECIPHERing.Rnw:49-51
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
# access a sequence file included in the package:
gen <- system.file("extdata", "Bacteria_175seqs.gen", package="DECIPHER")

# connect to a database:
dbConn <- dbConnect(SQLite(), ":memory:")

# import the sequences into the sequence database
Seqs2DB(gen, "GenBank", dbConn, "Bacteria")


###################################################
### code chunk number 4: expr2
###################################################
BrowseDB(dbConn)


###################################################
### code chunk number 5: expr3
###################################################
l <- IdLengths(dbConn)
head(l)
Add2DB(l, dbConn, verbose=FALSE)
BrowseDB(dbConn, maxChars=20)


###################################################
### code chunk number 6: expr4
###################################################
r <- IdentifyByRank(dbConn, level=3, add2tbl=TRUE)
BrowseDB(dbConn, maxChars=20)


###################################################
### code chunk number 7: expr5
###################################################
dna <- SearchDB(dbConn, identifier="Bacteroidetes")
BrowseSeqs(subseq(dna, 140, 240))


###################################################
### code chunk number 8: expr6
###################################################
d <- DistanceMatrix(dna, correction="Jukes-Cantor", verbose=FALSE)
c <- TreeLine(myDistMatrix=d, method="NJ", cutoff=0.05, showPlot=TRUE, verbose=FALSE)


###################################################
### code chunk number 9: expr7
###################################################
dbDisconnect(dbConn)


###################################################
### code chunk number 10: sessinfo
###################################################
toLatex(sessionInfo(), locale=FALSE)


