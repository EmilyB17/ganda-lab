## Assign ESVs with dada2

# input: 1. filtered and trimmed paired-end files 2. Path to dada2-formatted database
# outputs: 1. ESV table (analogous to OTU table) 2. Taxonomy table of lineages for each ESV

## ---- setVariables ----

# load R package
require(dada2)

# path to filtered and cleaned reads
CLEANEDPATH = "/Users/emily/ganda-lab/recipe16S/data/tutorialreads/filtered"

# pattern that specifies which reads are forward or reverse
# if single-read pairs, only specific forward 
PATTERNF = "_F_filt.fastq.gz"
PATTERNR = "_R_filt.fastq.gz"

# path to taxonomy database
DBPATH = "/Users/emily/ganda-lab/recipe16S/data/tutorialdbs/silva_nr_v132_train_set.fa"

## ---- dada2 ----

# get forward and reverse reads
forward <- sort(list.files(CLEANEDPATH, pattern = PATTERNF, full.names = TRUE))
reverse <- sort(list.files(CLEANEDPATH, pattern = PATTERNR, full.names = TRUE))

# check to make sure that the lengths of both files are the same
if(length(forward) != length(reverse)) {
  stop("The number of forward and reverse files do not match.")
}

# perform error learning
errF <- learnErrors(forward, multithread = TRUE)
errR <- learnErrors(reverse, multithread = TRUE)

# perform dada2
dadaForward <- dada(forward, err = errF, multithread = TRUE)
dadaReverse <- dada(reverse, err = errR, multithread = TRUE)

# merge paired reads
mergers <- mergePairs(dadaF = dadaForward,
                      derepF = forward,
                      dadaR = dadaReverse,
                      derepR = reverse,
                      verbose = TRUE)

# construct sequence table of ASVs
seqtab <- makeSequenceTable(mergers)

# remove chimeras
seqtab.nochim <- removeBimeraDenovo(seqtab, 
                                    method = "consensus",
                                    multithread = TRUE,
                                    verbose = TRUE)

# assign taxonomy
taxa <- assignTaxonomy(seqtab.nochim, DBPATH, multithread = TRUE)
