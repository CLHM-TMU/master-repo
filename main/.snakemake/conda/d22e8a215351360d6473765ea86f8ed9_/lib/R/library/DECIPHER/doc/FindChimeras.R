### R code from vignette source 'FindChimeras.Rnw'

###################################################
### code chunk number 1: FindChimeras.Rnw:43-45
###################################################
options(continue=" ")
options(width=80)


###################################################
### code chunk number 2: startup
###################################################
library(DECIPHER)


###################################################
### code chunk number 3: expr1 (eval = FALSE)
###################################################
## ids <- dbGetQuery(dbRef, "select identifier, origin from Seqs")
## ids <- paste(ids$origin, ids$identifier, sep=";")
## 
## dna <- SearchDB(dbRef, type="DNAStringSet", remove="all")
## 
## trainingSet <- LearnTaxa(dna, ids)


###################################################
### code chunk number 4: expr3 (eval = FALSE)
###################################################
## dbConn <- dbConnect(SQLite(), '<<path to query database>>')
## Seqs2DB('<<path to query sequences>>', 'FASTA', dbConn, '')


###################################################
### code chunk number 5: expr4 (eval = FALSE)
###################################################
## query <- SearchDB(dbConn, remove="all")
## groups <- IdTaxa(query, trainingSet, strand="top", threshold=0, processors=1)
## groups <- sapply(groups, function(x) tail(x$taxon, n=1))
## groups <- data.frame(identifier=groups, row.names=seq_along(groups), stringsAsFactors=FALSE)
## Add2DB(groups, dbConn)


###################################################
### code chunk number 6: expr7 (eval = FALSE)
###################################################
## # full-length sequences
## chimeras <- FindChimeras(dbConn, dbFileReference=dbRef, add2tbl=TRUE)


###################################################
### code chunk number 7: sessinfo
###################################################
toLatex(sessionInfo(), locale=FALSE)


