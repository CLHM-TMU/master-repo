### R code from vignette source 'Overview.Rnw'

###################################################
### code chunk number 1: style
###################################################
BiocStyle::latex()


###################################################
### code chunk number 2: preliminaries
###################################################
library("ShortRead")


###################################################
### code chunk number 3: sample (eval = FALSE)
###################################################
## sampler <- FastqSampler('E-MTAB-1147/fastq/ERR127302_1.fastq.gz', 20000)
## set.seed(123); ERR127302_1 <- yield(sampler)
## sampler <- FastqSampler('E-MTAB-1147/fastq/ERR127302_2.fastq.gz', 20000)
## set.seed(123); ERR127302_2 <- yield(sampler)


###################################################
### code chunk number 4: stream (eval = FALSE)
###################################################
## strm <- FastqStreamer("a.fastq.gz")
## repeat {
##     fq <- yield(strm)
##     if (length(fq) == 0)
##         break
##     ## process chunk
## }


###################################################
### code chunk number 5: sampler (eval = FALSE)
###################################################
## sampler <- FastqSampler("a.fastq.gz")
## fq <- yield(sampler)


###################################################
### code chunk number 6: countFastq
###################################################
fl <- system.file(package="ShortRead", "extdata", "E-MTAB-1147", 
                  "ERR127302_1_subset.fastq.gz")
countFastq(fl)


###################################################
### code chunk number 7: readFastq
###################################################
fq <- readFastq(fl)


###################################################
### code chunk number 8: ShortReadQ
###################################################
fq
fq[1:5]
head(sread(fq), 3)
head(quality(fq), 3)


###################################################
### code chunk number 9: encoding
###################################################
encoding(quality(fq))


###################################################
### code chunk number 10: qa-files (eval = FALSE)
###################################################
## fls <- dir("/path/to", "*fastq$", full=TRUE)


###################################################
### code chunk number 11: qa-qa (eval = FALSE)
###################################################
## qaSummary <- qa(fls, type="fastq")


###################################################
### code chunk number 12: qa-view (eval = FALSE)
###################################################
## browseURL(report(qaSummary))


###################################################
### code chunk number 13: qa-files
###################################################
load("qa_E-MTAB-1147.Rda")


###################################################
### code chunk number 14: qa-elements
###################################################
qaSummary


###################################################
### code chunk number 15: qa-readCounts
###################################################
head(qaSummary[["readCounts"]])
head(qaSummary[["baseCalls"]])


###################################################
### code chunk number 16: filter-scheme
###################################################
myFilterAndTrim <- 
    function(fl, destination=sprintf("%s_subset", fl))
{
    ## open input stream
    stream <- open(FastqStreamer(fl))
    on.exit(close(stream))
    
    repeat {
        ## input chunk
        fq <- yield(stream)
        if (length(fq) == 0)
            break
        
        ## trim and filter, e.g., reads cannot contain 'N'...
        fq <- fq[nFilter()(fq)]  # see ?srFilter for pre-defined filters
        ## trim as soon as 2 of 5 nucleotides has quality encoding less 
        ## than "4" (phred score 20)
        fq <- trimTailw(fq, 2, "4", 2)
        ## drop reads that are less than 36nt
        fq <- fq[width(fq) >= 36]
        
        ## append to destination
        writeFastq(fq, destination, "a")
    }
}


###################################################
### code chunk number 17: export
###################################################
## location of file
exptPath <- system.file("extdata", package="ShortRead")
sp <- SolexaPath(exptPath)
pattern <- "s_2_export.txt"
fl <- file.path(analysisPath(sp), pattern)
strsplit(readLines(fl, n=1), "\t")
length(readLines(fl))


###################################################
### code chunk number 18: colClasses
###################################################
colClasses <- rep(list(NULL), 21)
colClasses[9:10] <- c("DNAString", "BString")
names(colClasses)[9:10] <- c("read", "quality")


###################################################
### code chunk number 19: readXStringColumns
###################################################
cols <- readXStringColumns(analysisPath(sp), pattern, colClasses)
cols


###################################################
### code chunk number 20: size
###################################################
object.size(cols$read)
object.size(as.character(cols$read))


###################################################
### code chunk number 21: tables
###################################################
tbls <- tables(fq)
names(tbls)
tbls$top[1:5]
head(tbls$distribution)


###################################################
### code chunk number 22: srdistance
###################################################
dist <- srdistance(sread(fq), names(tbls$top)[1])[[1]]
table(dist)[1:10]


###################################################
### code chunk number 23: aln-not-near
###################################################
fqSubset <- fq[dist>4]


###################################################
### code chunk number 24: polya
###################################################
countA <- alphabetFrequency(sread(fq))[,"A"] 
fqNoPolyA <- fq[countA < 30]


###################################################
### code chunk number 25: sessionInfo
###################################################
toLatex(sessionInfo())


