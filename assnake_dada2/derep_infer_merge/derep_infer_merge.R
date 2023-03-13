args <- commandArgs(TRUE)

# LOAD PARAMS
read_table_loc <- c(args[[1]])

errR1 <- readRDS(args[[2]])
errR2 <- readRDS(args[[3]])

out <- c(args[[4]])

threads <- as.integer(args[[5]])

read_tracking_loc <- c(args[[6]])

seqtab_out <- c(args[[7]])

library("dada2")
library("Biostrings")

# save_path <- '/mnt/disk1/RUNS/fedorov_de/KYH/dada2/merged_pooledNonchim/renamed/'

# priorsR1 <- readDNAStringSet(paste(save_path, 'priorsR1.fa', sep=''), format="fasta")
# priorsR2 <- readDNAStringSet(paste(save_path, 'priorsR1.fa', sep=''), format="fasta")

# priorsR1 <- as.character(priorsR1)
# priorsR2 <- as.character(priorsR2)


reads <- read.table(file = read_table_loc, sep = '\t', header = TRUE)
print(threads)
derepR1 <- derepFastq(as.character(reads$R1), n=1e+08)
poolR1 <- dada(derepR1, err=errR1, multithread=threads, pool=F, verbose=TRUE)

derepR2 <- derepFastq(as.character(reads$R2), n=1e+08)       
poolR2 <- dada(derepR2, err=errR2, multithread=threads, pool=F, verbose=TRUE)
# saveRDS(pool, out)
# saveRDS(derep, derep_out)
# saveRDS(pool, out)
# saveRDS(derep, derep_out)

mergers <- mergePairs(poolR1, derepR1, poolR2, derepR2, verbose=TRUE, minOverlap = 18)
saveRDS(mergers, out)

seqtab <- makeSequenceTable(mergers)
saveRDS(seqtab, seqtab_out)


getN <- function(x) sum(getUniques(x))

track <- cbind(sapply(derepR1, getN), sapply(derepR2, getN),sapply(poolR1, getN), sapply(poolR2, getN), sapply(mergers, getN))

colnames(track) <- c('derepR1', 'derepR2', "denoisedF", "denoisedR", "merged")

write.table(track, read_tracking_loc, sep='\t', col.names = NA, quote = FALSE)

