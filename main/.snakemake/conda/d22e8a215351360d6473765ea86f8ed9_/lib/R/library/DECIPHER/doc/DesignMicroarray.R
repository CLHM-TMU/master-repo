### R code from vignette source 'DesignMicroarray.Rnw'

###################################################
### code chunk number 1: DesignMicroarray.Rnw:46-50
###################################################
options(continue=" ")
options(width=80)
options(SweaveHooks=list(fig=function()
	par(mar=c(4.1, 4.1, 0.3, 0.1))))


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
fas <- system.file("extdata", "Bacteria_175seqs.fas", package="DECIPHER")


###################################################
### code chunk number 4: expr2
###################################################
# specify a path for where to write the sequence database
dbConn <- "<<path to write sequence database>>"
# OR create the sequence database in memory
dbConn <- dbConnect(SQLite(), ":memory:")
Seqs2DB(fas, "FASTA", dbConn, "uncultured bacterium")


###################################################
### code chunk number 5: expr3
###################################################
dna <- SearchDB(dbConn)
dMatrix <- DistanceMatrix(dna, verbose=FALSE)
clusters <- TreeLine(myDistMatrix=dMatrix, type="clusters", cutoff=0.03, method="complete", verbose=FALSE)
Add2DB(clusters, dbConn, verbose=FALSE)


###################################################
### code chunk number 6: expr4
###################################################
conSeqs <- IdConsensus(dbConn, colName="cluster", verbose=FALSE)
dbDisconnect(dbConn)
# name the sequences by their cluster number
ns <- lapply(strsplit(names(conSeqs), "_", fixed=TRUE), `[`, 1)
names(conSeqs) <- gsub("cluster", "", unlist(ns), fixed=TRUE)
# order the sequences by their cluster number
o <- order(as.numeric(names(conSeqs)))
conSeqs <- conSeqs[o]


###################################################
### code chunk number 7: expr5
###################################################
probes <- DesignArray(conSeqs, maxPermutations=2, numProbes=20,
	start=120, end=1450, verbose=FALSE)
dim(probes)
names(probes)


###################################################
### code chunk number 8: expr6
###################################################
probes[1,]


###################################################
### code chunk number 9: expr7
###################################################
u <- unique(unlist(strsplit(probes$probes, ",", fixed=TRUE)))
length(u)
head(u)


###################################################
### code chunk number 10: expr8
###################################################
A <- Array2Matrix(probes, verbose=FALSE)
w <- which(A$x < 0.05)
if (length(w) > 0) {
	A$i <- A$i[-w]
	A$j <- A$j[-w]
	A$x <- A$x[-w]
}


###################################################
### code chunk number 11: expr9
###################################################
# simulate the case where 10% of the OTUs are present in random amounts
present <- sample(length(conSeqs), floor(0.1*length(conSeqs)))
x <- numeric(length(conSeqs))
x[present] <- abs(rnorm(length(present), sd=2))

# determine the predicted probe brightnesses based on the present OTUS
background <- 0.2
b <- matrix(tapply(A$x[A$j]*x[A$j], A$i, sum), ncol=1) + background
b <- b + rnorm(length(b), sd=0.2*b) # add 20% error
b <- b - background # background subtracted brightnesses

# add in a 5% false hybridization rate
bad_hybs <- sample(length(b), floor(0.05*length(b)))
b[bad_hybs] <- abs(rnorm(length(bad_hybs), sd=max(b)/3))


###################################################
### code chunk number 12: expr10
###################################################
# solve for the predicted amount of each OTU present on the array
x_out <- NNLS(A, b, verbose=FALSE)


###################################################
### code chunk number 13: expr11
###################################################
getOption("SweaveHooks")[["fig"]]()
ranges <- range(c(x_out$x, x))
ramp <- colorRampPalette(c("white", "yellow", "orange", "red"),
	space = "rgb")
smoothScatter(x, x_out$x,
	xlab="Expected Amount", ylab="Predicted Amount",
	xlim=ranges, ylim=ranges, nrpoints=1e5,
	pch=1, cex=0.5, nbin=300, colramp=ramp,
	transformation=function(x) x, bandwidth=0.4,
	cex.axis=0.7, cex.lab=0.8)
abline(a=0, b=1) # identity line
abline(a=max(x_out$x[which(x==0)]), b=0, lty=2) # threshold


###################################################
### code chunk number 14: expr12
###################################################
# initialize weights to one:
weights <- matrix(1, nrow=nrow(b), ncol=ncol(b))
# iteratively unweight observations with high residuals:
for (i in 1:10) { # 10 iterations
	weights <- weights*exp(-0.1*abs(x_out$residuals))
	A_weighted <- A
	A_weighted$x <- A$x*weights[A$i]
	b_weighted <- b*weights
	x_out <- NNLS(A_weighted, b_weighted, verbose=FALSE)
}


###################################################
### code chunk number 15: expr13
###################################################
getOption("SweaveHooks")[["fig"]]()
ranges <- range(c(x_out$x, x))
ramp <- colorRampPalette(c("white", "yellow", "orange", "red"),
	space = "rgb")
smoothScatter(x, x_out$x,
	xlab="Expected Amount", ylab="Predicted Amount",
	xlim=ranges, ylim=ranges, nrpoints=1e5,
	pch=1, cex=0.5, nbin=300, colramp=ramp,
	transformation=function(x) x, bandwidth=0.4,
	cex.axis=0.7, cex.lab=0.8)
abline(a=0, b=1) # identity line
abline(a=max(x_out$x[which(x==0)]), b=0, lty=2) # threshold


###################################################
### code chunk number 16: expr14
###################################################
w <- which(x_out$x >= min(x_out$x[present]))
w <- w[-match(present, w)] # false positives
dMatrix <- DistanceMatrix(conSeqs, verbose=FALSE)
# print distances of false positives to the nearest present OTU
for (i in w)
	print(min(dMatrix[i, present]))


###################################################
### code chunk number 17: expr15
###################################################
# simulate multiple cases where 10% of the OTUs are present in random amounts
iterations <- 100
b <- matrix(0, nrow=dim(b)[1], ncol=iterations)
x <- matrix(0, nrow=length(conSeqs), ncol=iterations)
for (i in 1:iterations) {
	present <- sample(length(conSeqs), floor(0.1*length(conSeqs)))
	x[present, i] <- abs(rnorm(length(present), sd=2))
	
	# determine the predicted probe brightnesses based on the present OTUS
	b[, i] <- tapply(A$x[A$j]*x[A$j, i], A$i, sum) + background
	b[, i] <- b[, i] + rnorm(dim(b)[1], sd=0.2*b[, i]) # add 20% error
	b[, i] <- b[, i] - background # background subtracted brightnesses
	
	# add in a 5% false hybridization rate
	bad_hybs <- sample(dim(b)[1], floor(0.05*length(b[, i])))
	b[bad_hybs, i] <- abs(rnorm(length(bad_hybs), sd=max(b[, i])/3))
}

x_out <- NNLS(A, b, verbose=FALSE)


###################################################
### code chunk number 18: expr17
###################################################
getOption("SweaveHooks")[["fig"]]()
ranges <- range(c(x_out$x, x))
ramp <- colorRampPalette(c("white", "yellow", "orange", "red"),
	space = "rgb")
smoothScatter(x[], x_out$x[],
	xlab="Expected Amount", ylab="Predicted Amount",
	xlim=ranges, ylim=ranges, nrpoints=1e5,
	pch=1, cex=0.5, nbin=300, colramp=ramp,
	transformation=function(x) x, bandwidth=0.4,
	cex.axis=0.7, cex.lab=0.8)
abline(a=0, b=1) # identity line


###################################################
### code chunk number 19: sessinfo
###################################################
toLatex(sessionInfo(), locale=FALSE)


