## Cleaning and filtering 16S files in dada2; demo with SRA data

# input: path to fastq files, other filtering/trimming parameters
# output: folder with filtered fastq files

## ---- install dada2 ----

## Skip this chunk if dada2 is already installed

# Install bioconductor

install.packages("BiocManager")
require(BiocManager)

# Install dada2 through Bioconductor
BiocManager::install("dada2", version = "3.10") # note that this needs R 3.6

# Once installed (or if already installed), load the package through R
require(dada2)

## ---- setVariables ----

# path to directory that contains fastq files
PATH = "/Users/emily/ganda-lab/recipe16S/data/tutorialreads"

# paired end characterization; most Illumina files are sample names + "_R1_001.fastq" for forward reads
# however, sequences downloaded from NCBI have patterns: "_1.fastq" for forward and "_2.fastq" for reverse
PATTERNF = "_1.fastq"
PATTERNR = "_2.fastq"

# Quality cut: "Truncate reads at the first instance of a quality score less than or equal to truncQ"
TRUNCQ = 2

# Length cut: "Truncate reads after `trunclen` bases; reads shorter than this are discarded"
# NOTE: if paired-end, need two values (one for forward and one for reverse)
TRUNCLEN = c(240, 220)

# Head trim: "Number of nucleotides to remove from the start of each read"
TRIMLEFT = 10

# Tail trim: "Number of nucleotides to remove from the end of each read"
TRIMRIGHT = 0

# Minimum length: "Remove reads with length less than minLen" -- this happens AFTER other trims/truncations
MINLEN = 150

# Maxmimum N: "After truncation, sequences with more than `maxN` are discarded"
MAXN = 0

# Minimum quality: "After truncation, reads contain a quality score less than `minQ` are discarded"
MINQ = 0

## ---- filterAndTrim ----


# get list of files
forward <- sort(list.files(PATH, pattern = PATTERNF, full.names = TRUE))
reverse <- sort(list.files(PATH, pattern = PATTERNR, full.names = TRUE))

# check to make sure that the lengths of both files are the same
if(length(forward) != length(reverse)) {
  stop("There is an unequal number of forward and reverse files")
}

# get sample names
sample.names <- sapply(strsplit(basename(forward), PATTERNF), `[`, 1)

# create subdirectory for filtered files
filtForward <- file.path(PATH, "filtered", paste0(sample.names, "_F_filt.fastq.gz"))
filtReverse <- file.path(PATH, "filtered", paste0(sample.names, "_R_filt.fastq.gz"))

# filter and trim
cleaned <- filterAndTrim(fwd = forward, rev = reverse,
                         filt = filtForward, filt.rev = filtReverse,
                         # add parameters that the user selected in previous chunk
                         truncQ = TRUNCQ,
                         truncLen = TRUNCLEN,
                         trimLeft = TRIMLEFT,
                         trimRight = TRIMRIGHT,
                         maxN = MAXN,
                         minLen = MINLEN,
                         minQ = MINQ
)

# plot quality profile of forward and reverse samples post-filter/trim
plotQualityProfile(filtForward[1:2])
plotQualityProfile(filtReverse[1:2])
  
