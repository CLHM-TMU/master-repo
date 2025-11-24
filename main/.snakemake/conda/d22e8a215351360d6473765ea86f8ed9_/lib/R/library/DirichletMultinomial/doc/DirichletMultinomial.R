### R code from vignette source 'DirichletMultinomial.Rnw'

###################################################
### code chunk number 1: library
###################################################
library(DirichletMultinomial)
library(lattice)
library(xtable)
library(parallel)


###################################################
### code chunk number 2: colors
###################################################
options(width=70, digits=2)
full <- FALSE
.qualitative <- DirichletMultinomial:::.qualitative
dev.off <- function(...) invisible(grDevices::dev.off(...))


###################################################
### code chunk number 3: data-input
###################################################
fl <- system.file(package="DirichletMultinomial", "extdata",
                  "Twins.csv")
count <- t(as.matrix(read.csv(fl, row.names=1)))
count[1:5, 1:3]


###################################################
### code chunk number 4: taxon-counts
###################################################
cnts <- log10(colSums(count))
pdf("taxon-counts.pdf")
densityplot(cnts, xlim=range(cnts),
            xlab="Taxon representation (log 10 count)")
dev.off()


###################################################
### code chunk number 5: fit
###################################################
if (full) {
    fit <- mclapply(1:7, dmn, count=count, verbose=TRUE)
    save(fit, file=file.path(tempdir(), "fit.rda"))
} else data(fit)
fit[[4]]


###################################################
### code chunk number 6: min-laplace
###################################################
lplc <- sapply(fit, laplace)
pdf("min-laplace.pdf")
plot(lplc, type="b", xlab="Number of Dirichlet Components",
     ylab="Model Fit")
dev.off()
(best <- fit[[which.min(lplc)]])


###################################################
### code chunk number 7: mix-weight
###################################################
mixturewt(best)
head(mixture(best), 3)


###################################################
### code chunk number 8: fitted
###################################################
pdf("fitted.pdf")
splom(log(fitted(best)))
dev.off()


###################################################
### code chunk number 9: isoMDS
###################################################



###################################################
### code chunk number 10: isoMDS-plot
###################################################



###################################################
### code chunk number 11: posterior-mean-diff
###################################################
p0 <- fitted(fit[[1]], scale=TRUE)     # scale by theta
p4 <- fitted(best, scale=TRUE)
colnames(p4) <- paste("m", 1:4, sep="")
(meandiff <- colSums(abs(p4 - as.vector(p0))))
sum(meandiff)


###################################################
### code chunk number 12: table-1
###################################################
diff <- rowSums(abs(p4 - as.vector(p0)))
o <- order(diff, decreasing=TRUE)
cdiff <- cumsum(diff[o]) / sum(diff)
df <- head(cbind(Mean=p0[o], p4[o,], diff=diff[o], cdiff), 10)


###################################################
### code chunk number 13: xtable
###################################################
xtbl <- xtable(df,
    caption="Taxonomic contributions (10 largest) to Dirichlet components.",
    label="tab:meandiff", align="lccccccc")
print(xtbl, hline.after=0, caption.placement="top")


###################################################
### code chunk number 14: heatmap-similarity
###################################################
pdf("heatmap1.pdf")
heatmapdmn(count, fit[[1]], best, 30)
dev.off()


###################################################
### code chunk number 15: twin-pheno
###################################################
fl <- system.file(package="DirichletMultinomial", "extdata",
                  "TwinStudy.t")
pheno0 <- scan(fl)
lvls <- c("Lean", "Obese", "Overwt")
pheno <- factor(lvls[pheno0 + 1], levels=lvls)
names(pheno) <- rownames(count)
table(pheno)


###################################################
### code chunk number 16: subsets
###################################################
counts <- lapply(levels(pheno), csubset, count, pheno)
sapply(counts, dim)
keep <- c("Lean", "Obese")
count <- count[pheno %in% keep,]
pheno <- factor(pheno[pheno %in% keep], levels=keep)


###################################################
### code chunk number 17: fit-several-
###################################################
if (full) {
    bestgrp <- dmngroup(count, pheno, k=1:5, verbose=TRUE, 
                        mc.preschedule=FALSE)
    save(bestgrp, file=file.path(tempdir(), "bestgrp.rda"))
} else data(bestgrp)


###################################################
### code chunk number 18: best-several
###################################################
bestgrp
lapply(bestgrp, mixturewt)
c(sapply(bestgrp, laplace),
  `Lean+Obese`=sum(sapply(bestgrp, laplace)),
  Single=laplace(best))


###################################################
### code chunk number 19: confusion
###################################################
xtabs(~pheno + predict(bestgrp, count, assign=TRUE))


###################################################
### code chunk number 20: cross-validate
###################################################
if (full) {
    ## full leave-one-out; expensive!
    xval <- cvdmngroup(nrow(count), count, c(Lean=1, Obese=3), pheno,
                       verbose=TRUE, mc.preschedule=FALSE)
    save(xval, file=file.path(tempdir(), "xval.rda"))
} else data(xval)


###################################################
### code chunk number 21: ROC-dmngroup
###################################################
bst <- roc(pheno[rownames(count)] == "Obese",
           predict(bestgrp, count)[,"Obese"])
bst$Label <- "Single"
two <- roc(pheno[rownames(xval)] == "Obese",
           xval[,"Obese"])
two$Label <- "Two group"
both <- rbind(bst, two)
pars <- list(superpose.line=list(col=.qualitative[1:2], lwd=2))
pdf("roc.pdf")
xyplot(TruePostive ~ FalsePositive, group=Label, both,
       type="l", par.settings=pars,
       auto.key=list(lines=TRUE, points=FALSE, x=.6, y=.1),
       xlab="False Positive", ylab="True Positive")
dev.off()


###################################################
### code chunk number 22: sessionInfo
###################################################
toLatex(sessionInfo())


