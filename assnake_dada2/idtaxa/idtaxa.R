args <- commandArgs(TRUE)

library(phyloseq)
library(DECIPHER)

# LOAD PARAMS
seqtab_loc <- c(args[[1]])
threads <- as.integer(args[[2]])
idtaxa_res_loc <- c(args[[3]])
idtaxa_table_loc <- c(args[[4]])

seqtab <- readRDS(seqtab_loc) 
ps <- phyloseq(otu_table(seqtab, taxa_are_rows=FALSE))
dna <- Biostrings::DNAStringSet(taxa_names(ps))
names(dna) <- taxa_names(ps)


seqs <- RemoveGaps(dna)

# load a training set object (trainingSet)
# see http://DECIPHER.codes/Downloads.html
load("/ssd/DATABASES/SILVA_SSU_r138_2019.RData")

# classify the sequences
ids <- IdTaxa(seqs,
   trainingSet,
   strand="both", # or "top" if same as trainingSet
   threshold=50, # 60 (cautious) or 50 (sensible)
   processors=threads) # use all available processors

idtaxa_res <- ids

saveRDS(idtaxa_res, idtaxa_res_loc)


ranks <- c("rootrank", "domain", "phylum", "class", "order", "family", "genus", "species")
decipherCS_tax <- t(sapply(idtaxa_res, function(x) {
      m <- match(ranks, x$rank)
      taxa <- x$taxon[m]
      taxa[startsWith(taxa, "unclassified_")] <- NA
      taxa
}))

colnames(decipherCS_tax) <- c('Root', 'Kingdom','Phylum','Class','Order','Family', 'Genus', 'Species')
MatrixC <- cbind(SEQ_ID=rownames(decipherCS_tax), decipherCS_tax) 
write.table(MatrixC, file = idtaxa_table_loc, sep = "\t", quote = FALSE, row.names=F)

