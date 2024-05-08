# Load required libraries
library(argparse)
library(dada2)
library(Biostrings)

#' Process sequencing data.
#' 
#' This function takes input file paths and parameters for denoising and merging paired-end sequencing data,
#' and performs the following steps:
#' 1. Load sequencing data from input file.
#' 2. Denoise R1 reads using DADA2.
#' 3. Denoise R2 reads using DADA2.
#' 4. Merge paired-end reads.
#' 5. Save merged sequences, sequence table, and tracking information.
#' 
#' @param input_file Path to the input file containing sequencing data (in TSV format).
#' @param errR1 Path to the error rate file for R1 reads (RDS format).
#' @param errR2 Path to the error rate file for R2 reads (RDS format).
#' @param output_file Path to the output file for merged sequences (RDS format).
#' @param threads Number of threads for parallel processing.
#' @param read_tracking Path to the read tracking output file (TSV format).
#' @param seqtab_output Path to the sequence table output file (RDS format).
#' @return NULL
#' @export
process_sequencing_data <- function(input_file, errR1, errR2, output_file, threads, read_tracking, seqtab_output) {
  # Load sequencing data
  reads <- read.table(file = input_file, sep = '\t', header = TRUE)
  
  # Denoise R1
  derepR1 <- derepFastq(as.character(reads$R1), n=1e+08)
  poolR1 <- dada(derepR1, err=readRDS(errR1), multithread=threads, pool=TRUE, verbose=TRUE)
  
  # Denoise R2
  derepR2 <- derepFastq(as.character(reads$R2), n=1e+08)
  poolR2 <- dada(derepR2, err=readRDS(errR2), multithread=threads, pool=TRUE, verbose=TRUE)
  
  # Merge paired-end reads
  mergers <- mergePairs(poolR1, derepR1, poolR2, derepR2, verbose=TRUE, minOverlap = 12, maxMismatch = 1)
  
  # Save results
  saveRDS(mergers, output_file)
  
  # Create sequence table
  seqtab <- makeSequenceTable(mergers)
  saveRDS(seqtab, seqtab_output)
  
  # Calculate and save tracking information
  getN <- function(x) sum(getUniques(x))
  track <- cbind(sapply(derepR1, getN), sapply(derepR2, getN), sapply(poolR1, getN), sapply(poolR2, getN), sapply(mergers, getN))
  print(track)
  colnames(track) <- c('derepR1', 'derepR2', "denoisedF", "denoisedR", "merged")
  write.table(track, read_tracking, sep='\t', col.names = NA, quote = FALSE)
}

# Create an argument parser
parser <- ArgumentParser(description = "Denoising and merging paired-end sequencing data")

# Define command-line arguments with descriptions
parser$add_argument("--input-file", type = "character", help = "Path to the input file containing sequencing data (in TSV format)")
parser$add_argument("--errR1", type = "character", help = "Path to the error rate file for R1 reads (RDS format)")
parser$add_argument("--errR2", type = "character", help = "Path to the error rate file for R2 reads (RDS format)")
parser$add_argument("--output-file", type = "character", help = "Path to the output file for merged sequences (RDS format)")
parser$add_argument("--threads", type = "integer", help = "Number of threads for parallel processing") 
parser$add_argument("--read-tracking", type = "character", help = "Path to the read tracking output file (TSV format)")
parser$add_argument("--seqtab-output", type = "character", help = "Path to the sequence table output file (RDS format)")

# Parse command-line arguments
args <- parser$parse_args()

# Call the processing function with parsed arguments
process_sequencing_data(args$input_file, args$errR1, args$errR2, args$output_file, args$threads, args$read_tracking, args$seqtab_output)
