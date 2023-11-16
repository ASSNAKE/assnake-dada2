args <- commandArgs(TRUE)

# LOAD PARAMS
seqtab <- readRDS(args[[1]])
out <- c(args[[2]])

threads <- as.integer(args[[3]])

library("dada2")
seqtab_nochim <- removeBimeraDenovo(seqtab, allowOneOff=F, method="consensus", verbose=TRUE, multithread=threads)
saveRDS(seqtab_nochim, out)

