args <- commandArgs(TRUE)

# LOAD PARAMS
read_table_loc <- c(args[[1]])

errR1 <- readRDS(args[[2]])
errR2 <- readRDS(args[[3]])

out <- c(args[[4]])

threads <- as.integer(args[[5]])

read_tracking_loc <- c(args[[6]])


library("dada2")
reads <- read.table(file = read_table_loc, sep = '\t', header = TRUE)
print(threads)
derepR1 <- derepFastq(as.character(reads$R1))
poolR1 <- dada(derepR1, err=errR1, multithread=threads, pool=TRUE, verbose=TRUE)

derepR2 <- derepFastq(as.character(reads$R2))       
poolR2 <- dada(derepR2, err=errR2, multithread=threads, pool=TRUE, verbose=TRUE)
# saveRDS(pool, out)
# saveRDS(derep, derep_out)
# saveRDS(pool, out)
# saveRDS(derep, derep_out)

mergers <- mergePairs(poolR1, derepR1, poolR2, derepR2, verbose=TRUE, minOverlap = 18)
saveRDS(mergers, out)



getN <- function(x) sum(getUniques(x))

track <- cbind(sapply(derepR1, getN), sapply(derepR2, getN),sapply(poolR1, getN), sapply(poolR2, getN), sapply(mergers, getN))

colnames(track) <- c('derepR1', 'derepR2', "denoisedF", "denoisedR", "merged")

write.table(track, read_tracking_loc, sep='\t', col.names = NA, quote = FALSE)

