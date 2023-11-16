args <- commandArgs(TRUE)
read_table_loc <- c(args[[1]])
out_loc <- c(args[[2]])
strand <- c(args[[3]])
randomize <- as.logical(args[[4]])
MAX_CONSIST <- as.integer(args[[5]])
threads <- as.integer(args[[6]])

library("dada2")
reads <- read.table(file = read_table_loc, sep = '\t', header = TRUE)

if (strand == 'R1'){
    err <- learnErrors(as.character(reads$R1), nbases=1e+08, multithread=threads, randomize=TRUE, MAX_CONSIST=20, verbose=1)
    } else if (strand == 'R2'){
    err <- learnErrors(as.character(reads$R2), nbases=1e+08, multithread=threads, randomize=TRUE, MAX_CONSIST=20, verbose=1)
}


saveRDS(err, out_loc)

