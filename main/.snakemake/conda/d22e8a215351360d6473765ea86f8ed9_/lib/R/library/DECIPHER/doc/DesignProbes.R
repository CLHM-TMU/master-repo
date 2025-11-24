### R code from vignette source 'DesignProbes.Rnw'

###################################################
### code chunk number 1: DesignProbes.Rnw:46-48
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
gb <- "<<path to GenBank file>>"
# OR find the example sequence file used in this tutorial:
gb <- system.file("extdata", "Bacteria_175seqs.gen", package="DECIPHER")


###################################################
### code chunk number 5: expr2
###################################################
# specify a path for where to write the sequence database
dbConn <- "<<path to write sequence database>>"
# OR create the sequence database in memory
dbConn <- dbConnect(SQLite(), ":memory:")
Seqs2DB(gb, "GenBank", dbConn, "Bacteria")


###################################################
### code chunk number 6: expr3
###################################################
ids <- IdentifyByRank(dbConn, level=Inf, add2tbl=TRUE)


###################################################
### code chunk number 7: expr4 (eval = FALSE)
###################################################
## tiles <- TileSeqs(dbConn, add2tbl="Tiles")


###################################################
### code chunk number 8: expr5 (eval = FALSE)
###################################################
## probes <- DesignProbes(tiles, identifier="Sphingopyxis",
## 	start=120, end=1450)


###################################################
### code chunk number 9: expr6 (eval = FALSE)
###################################################
## o <- order(probes$score, decreasing=TRUE)
## probes[o[1],]


###################################################
### code chunk number 10: expr7 (eval = FALSE)
###################################################
## ConsensusSequence(DNAStringSet(probes[o[1], "probe"][1:3]))


###################################################
### code chunk number 11: expr8 (eval = FALSE)
###################################################
## FA_range <- 0:70 # [FA] (%, v/v)
## probe <- probes$probe[o[1], 1:3]
## targets <- reverseComplement(DNAStringSet(probe))
## f <- function(FA)
## 	CalculateEfficiencyFISH(probe, targets,
## 		temp=46, P=250e-9, ions=1, FA)[, "HybEff"]
## efficiency <- matrix(unlist(lapply(FA_range, f)), ncol=3, byrow=TRUE)
## matplot(FA_range, efficiency, ylim=c(0,1), ylab="Hybridization Efficiency",
## 	xlab=expression(paste("[Formamide] (%, v/v)", sep="")),
## 	type="l", lwd=2, col="Blue", main="Formamide Curve", lty=1)
## 
## nontargets <- DNAStringSet(c("AGCGTTTGACATCCTGATCGCGG",
## 	"AGCTTTTGACATCCCGGTCGCGG"))
## f <- function(FA)
## 	CalculateEfficiencyFISH(probe[3:2], nontargets,
## 		temp=46, P=250e-9, ions=1, FA)[, "HybEff"]
## efficiency <- matrix(unlist(lapply(FA_range, f)), ncol=2, byrow=TRUE)
## matlines(FA_range, efficiency, col="Red", lwd=2, lty=3)
## 
## abline(h=0.5, lty=2, lwd=2, col="Orange")
## abline(v=35, lty=2, lwd=2, col="Green")
## legend("topright", legend=c("Targets", "Non-Targets", "50% Efficiency",
## 	"Experimental [FA]"), col=c("Blue", "Red", "Orange", "Green"),
## 	lwd=c(2, 2, 2, 2), lty=c(1, 3, 2, 2))


###################################################
### code chunk number 12: expr9 (eval = FALSE)
###################################################
## dbConn_ref <- dbConnect(SQLite(), "<<path to reference database>>")
## # select the most common k-mers
## ref_tiles <- dbGetQuery(dbConn_ref,
## 	"select * from Tiles where groupCoverage > 0.2 and coverage > 0.01")
## dbDisconnect(dbConn_ref)
## ref_tiles$id <- paste("ref", ref_tiles$id, sep="_")


###################################################
### code chunk number 13: expr10 (eval = FALSE)
###################################################
## seqs <- DNAStringSet(ref_tiles$target_site)
## w <- which(!is.na(t(probes$probe)))
## probes_rc <- reverseComplement(DNAStringSet(t(probes$probe)[w]))
## p <- PDict(probes_rc, tb.start=1, tb.width=5)
## hits1 <- vwhichPDict(p, seqs, max.mismatch=5)
## l <- vapply(hits1, length, integer(1))
## hits1 <- unlist(hits1, use.names=FALSE)
## names(hits1) <- rep(1:length(l), l)
## p <- PDict(probes_rc, tb.end=-1, tb.width=5)
## hits2 <- vwhichPDict(p, seqs, max.mismatch=5)
## l <- vapply(hits2, length, integer(1))
## hits2 <- unlist(hits2, use.names=FALSE)
## names(hits2) <- rep(1:length(l), l)
## hits <- c(hits1, hits2)


###################################################
### code chunk number 14: expr11 (eval = FALSE)
###################################################
## Hyb_FA <- 35 # the default Hybridization [FA] (%; v/v)
## count <- 0L
## pBar <- txtProgressBar(style=3)
## for (i in 1:dim(probes)[1]) {
## 	# for each hit calculate the degree of cross-hybridization
## 	w <- which(!is.na(probes[i, "probe"]))
## 	results <- NULL
## 	for (j in 1:length(w)) {
## 		count <- count + 1L
## 		w <- which(hits==count)
## 		if (length(w) > 0) {
## 			ns <- as.integer(unique(names(hits[w])))
## 			eff <- CalculateEfficiencyFISH(rep(probes$probe[i, j],
## 					length(ns)),
## 				ref_tiles$target_site[ns],
## 				46, # temperature
## 				250e-9, # [Probe]
## 				1, # [NA]
## 				Hyb_FA)
## 			eff <- cbind(eff,
## 				data.frame(id=ref_tiles$id[ns],
## 					probe_rc=toString(probes_rc[count]),
## 					target=ref_tiles$target_site[ns],
## 					dFAm=eff[, "FAm"] - Hyb_FA,
## 					stringsAsFactors=FALSE))
## 			results <- rbind(results, eff)
## 		}
## 	}
## 	
## 	w <- which(results$dFAm > -20)
## 	if (length(w) > 0) {
## 		# only record the strongest cross-hybridization in each group
## 		results <- results[w,]
## 		u <- unique(results$id)
## 		keep <- integer()
## 		for (j in 1:length(u)) {
## 			w <- which(results$id==u[j])
## 			keep <- c(keep, w[which.max(results$dFAm[w])])
## 		}
## 		results <- results[keep,]
## 		
## 		# append more non-targets to mismatches
## 		p <- pairwiseAlignment(results$probe_rc,
## 			results$target,
## 			type="global-local")
## 		probes$mismatches[i] <- paste(probes$mismatches[i],
## 			paste(results$id,
## 				" (", round(100*results$HybEff, 1), "%,",
## 				round(results$ddG1, 2), "kcal/mol,",
## 				round(results$dFAm, 1), "%;",
## 				substring(reverseComplement(DNAStringSet(pattern(p))),
## 					1L),
## 				"/", substring(subject(p), 1L), ")",
## 				sep="",
## 				collapse=" "),
## 			sep="")
## 		
## 		# score -= 0.2 + 1.2^dFAm
## 		probes$score[i] <- probes$score[i] -
## 			sum(ifelse(results$dFAm < -20, 0, 0.2 +
## 				1.2^ifelse(results$dFAm > 0, 0, results$dFAm)))
## 	}
## 	
## 	setTxtProgressBar(pBar, i/dim(probes)[1])
## }


###################################################
### code chunk number 15: expr12 (eval = FALSE)
###################################################
## # the original best scoring probe after searching the comprehensive database
## probes[o[1],]


###################################################
### code chunk number 16: expr13 (eval = FALSE)
###################################################
## # the new best scoring probe after searching the comprehensive database
## o <- order(probes$score, -1*probes$permutations,
## 	rowSums(as.matrix(probes$coverage[,]), na.rm=TRUE),
## 	decreasing=TRUE)
## probes[o[1],]


###################################################
### code chunk number 17: expr14 (eval = FALSE)
###################################################
## probes <- DesignProbes(tiles, identifier="Sphingopyxis",
## 	start=120, end=1450,
## 	numProbeSets=100) # note numProbeSets > 0


###################################################
### code chunk number 18: expr15 (eval = FALSE)
###################################################
## dim(probes) # now there are 100 potential probe sets


###################################################
### code chunk number 19: expr16 (eval = FALSE)
###################################################
## numProbeSets <- 100 # number of probe sets to generate
## s <- ifelse(dim(probes)[1] > numProbeSets, numProbeSets, dim(probes)[1])
## MMs <- strsplit(probes$mismatches[o[1:s]], "mol,", fixed=TRUE)
## ls <- unlist(lapply(MMs, length))
## ls <- ifelse(ls > 0, ls - 1, 0)
## index <- rep(1:length(ls), ls)
## if (length(index) > 0) {
## 	MMs <- strsplit(unlist(MMs), "%;", fixed=TRUE)
## 	MMs <- unlist(strsplit(unlist(MMs), ") ", fixed=TRUE))
## 	effs <- as.numeric(MMs[seq(2, length(MMs), 3)])
## 	MMs <- MMs[seq(1, length(MMs), 3)]
## 	MMs <- unlist(strsplit(MMs, " (", fixed=TRUE))
## 	MMs <- MMs[seq(1, length(MMs), 2)]
## }
## 
## m <- matrix(0, nrow=s, ncol=s, dimnames=list(o[1:s], o[1:s])) # scores
## n <- matrix(0, nrow=s, ncol=s, dimnames=list(o[1:s], o[1:s])) # counts
## for (i in 1:(s - 1)) {
## 	w1 <- which(index==i)
## 	if (length(w1)==0)
## 		next
## 	for (j in (i + 1):s) {
## 		w2 <- which(index==j)
## 		if (length(w2)==0)
## 			next
## 		overlap_MMs <- match(MMs[w1], MMs[w2])
## 		w <- which(!is.na(overlap_MMs))
## 		n[i, j] <- length(w)
## 		if (length(w) > 0)
## 			m[i, j] <- sum(tapply(c(effs[w1[w]], effs[w2[overlap_MMs[w]]]),
## 				rep(1:length(w), 2),
## 				function(x) return(-1.2^ifelse(min(x) > 0, 0, min(x)))))
## 	}
## }


###################################################
### code chunk number 20: expr17 (eval = FALSE)
###################################################
## # plot the matrix of dual-probe scores
## m <- m + t(m) # make symmetric
## diag(m) <- probes$score[o[1:s]]
## O <- order(o[1:s]) # unsort
## cols <- colorRamp(rainbow(101, start=0, end=0.35, v=0.9), bias=0.1)(0:100/100)/255
## cols <- mapply(rgb, cols[, 1], cols[, 2], cols[, 3])
## image(m[O, O[dim(m)[2]:1]], yaxt='n', xaxt='n', col=cols,
## 	xlab="Probe #1 Target Site Position", ylab="Probe #2 Target Site Position")
## axis(1, seq(0, 1, 0.01), probes$start[o[1:s]][O[seq(1, s, length.out=101)]])
## axis(2, seq(1, 0, -0.01), probes$start[o[1:s]][O[seq(1, s, length.out=101)]])


###################################################
### code chunk number 21: expr18 (eval = FALSE)
###################################################
## # choose the best probe sets
## d <- dimnames(m)
## p <- outer(probes$permutations[o[1:s]],
## 	probes$permutations[o[1:s]],
## 	FUN="+")
## c <- -1*outer(rowSums(as.matrix(probes$coverage[o[1:s],]), na.rm=TRUE),
## 	ifelse(rep(s, s)==1,
## 		sum(probes$coverage[o[1:s],], na.rm=TRUE),
## 		rowSums(as.matrix(probes$coverage[o[1:s],]), na.rm=TRUE)),
## 	FUN="*")
## ss <- -1*outer(probes$score[o[1:s]],
## 	probes$score[o[1:s]],
## 	FUN="+")
## # order probes by dual-probe score, permutations, coverage, and individual scores
## o <- order(m + n/5, p, c, ss) # score = 0.2*n + 1.2^dFAm
## j <- 0
## first <- second <- integer()
## scores <- numeric()
## mismatches <- character()
## for (k in 1:numProbeSets) {
## 	if ((j + 1) > length(o))
## 		break
## 	for (j in (j + 1):length(o)) {
## 		w_o <- c((o[j] - 1) %% dim(m)[1] + 1,
## 			(o[j] - 1)%/% dim(m)[1] + 1)
## 		f <- as.numeric(d[[1]][w_o[1]])
## 		r <- as.numeric(d[[2]][w_o[2]])
## 		
## 		start_F <- probes$start[f]
## 		start_R <- probes$start[r]
## 		if (abs(start_F - start_R) > (50 + nchar(probes$probe[f][1])))
## 			break # > 50 nt separation
## 	}
## 	
## 	if (abs(start_F - start_R) > (50 + nchar(probes$probe[f][1]))) {
## 		first <- c(first, f)
## 		second <- c(second, r)
## 		scores <- c(scores, -m[o[j]]/100)
## 		
## 		w_F <- which(index==w_o[1])
## 		w_R <- which(index==w_o[2])
## 		overlap_MMs <- match(MMs[w_F], MMs[w_R])
## 		w_S <- which(!is.na(overlap_MMs))
## 		if (length(w_S)==0)
## 			next
## 		EFFs <- tapply(c(effs[w_F[w_S]], effs[w_R[overlap_MMs[w_S]]]),
## 				rep(1:length(w_S), 2),
## 				min)
## 		# record set mismatches
## 		w1 <- which(EFFs >= -20)
## 		if (length(w1) > 0)
## 			mismatches <- c(mismatches, paste(MMs[w_F][w_S][w1],
## 				" (", formatC(EFFs[w1], digits=1, width=1, format="f"),
## 				"%)", sep="", collapse=", "))
## 	}
## }
## 
## pSets <- cbind(probes[first,], probes[second,])
## ns <- names(pSets)
## ns[1:10] <- paste(ns[1:10], "one", sep="_")
## ns[11:20] <- paste(ns[11:20], "two", sep="_")
## names(pSets) <- ns
## pSets$score_set <- scores
## pSets$mismatches_set <- mismatches
## 
## pSets[1, -which(names(pSets) %in% c("mismatches_one", "mismatches_two"))]


###################################################
### code chunk number 22: expr19 (eval = FALSE)
###################################################
## dna <- SearchDB(dbConn, nameBy="identifier", verbose=FALSE)
## dbDisconnect(dbConn)
## 
## # move the target group to the top of the sequence set
## w <- which(names(dna)=="Sphingopyxis")
## dna <- c(dna[w], dna[-w])
## 
## BrowseSeqs(dna, colorPatterns=c(pSets$start_aligned_one[1],
## 	pSets$start_aligned_one[1] + nchar(pSets$probe_one[1]) - 1,
## 	pSets$start_aligned_two[1],
## 	pSets$start_aligned_two[1] + nchar(pSets$probe_two[1]) - 1),
## 	highlight=1)


###################################################
### code chunk number 23: sessinfo
###################################################
toLatex(sessionInfo(), locale=FALSE)


