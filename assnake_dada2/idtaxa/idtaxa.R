args <- commandArgs(TRUE)

# LOAD PARAMS
read_table_loc <- c(args[[1]])

errR1 <- readRDS(args[[2]])
errR2 <- readRDS(args[[3]])

out <- c(args[[4]])

threads <- as.integer(args[[5]])
threshold <- as.integer(args[[5]])


wd_path = '/data11/bio/mg_data/COVID_FEB2021/dada2/merged/learn_erros__def.b0a376b5/'
# Load raw data
seqtab <- readRDS(paste(wd_path, 'seqtab_nochim__20.rds', sep=''))
rownames(seqtab) <- gsub('.{3}$', '', sapply(strsplit(rownames(seqtab), ".", fixed = TRUE), `[`, 1))

# Construct phyloseq object
psasv <- phyloseq(otu_table(seqtab, taxa_are_rows=FALSE))

# Rename ACTGTCCA*** with ASV002 for readability
dna <- Biostrings::DNAStringSet(taxa_names(psasv))
names(dna) <- taxa_names(psasv)
psasv <- merge_phyloseq(psasv, dna)
taxa_names(psasv) <- paste0("ASV", seq(ntaxa(psasv)))
names(dna) <- taxa_names(psasv)
psasv

# remove singletons
psasv <- filter_taxa(psasv, function(x) sum(x) > 1, TRUE)
psasv

# Remove short sequences
dna.len.sort <- dna[order(width(dna), decreasing = F),]
short_asvs <- dna[(width(dna) < 386), ]
dna <- dna[(width(dna) >= 386), ]

psasv = prune_taxa(names(dna), psasv)
psasv

# IDTAXA
database <- "/ssd/DATABASES/SILVA_SSU_r138_2019.RData"
fas <- "/data11/bio/mg_data/COVID_FEB2021/dada2/merged/learn_erros__def.b0a376b5/filtered_1_read_total_no_short/raw_seqs.fa"
# load the sequences from the file
seqs <- readDNAStringSet(fas) # or readRNAStringSet
# remove any gaps (if needed)
seqs <- RemoveGaps(seqs)

# for help, see the IdTaxa help page (optional)
# ?IdTaxa

# load a training set object (trainingSet)
# see http://DECIPHER.codes/Downloads.html
load(database)

# classify the sequences
ids <- IdTaxa(seqs,
   trainingSet,
   strand="both", # or "top" if same as trainingSet
   threshold=threshold, # 60 (cautious) or 50 (sensible)
   processors=threads) # use all available processors

# look at the results
print(ids)
plot(ids)

idtaxa_res <- ids

saveRDS(idtaxa_res, './idtaxa_res.rds')

assignment <- sapply(idtaxa_res, function(x) paste(x$taxon, collapse=";"))
assignment <- sapply(idtaxa_res, function(x) x$taxon
                     )
n.obs <- sapply(assignment, length)
seq.max <- seq_len(max(n.obs))
mat <- t(sapply(assignment, "[", i = seq.max))

as.data.frame(assignment)



colnames(mat) <- c('Root','Kingdom','Phylum','Class','Order','Family', 'Genus')

# Because R
MatrixC <- cbind(SEQ_ID=rownames(mat), mat)  
write.table(MatrixC, file = 'idTaxa.tsv', sep = "\t", quote = FALSE, row.names=F)