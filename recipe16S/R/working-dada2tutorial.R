# CHange this on Linux
PATH="C:/Users/emily/AppData/Local/Packages/CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc/LocalState/rootfs/home/emily/"

# The trunaction
TRUNC=260

## WORKING: dada2

## TO RUN TUTORIAL: LOAD RDATA
load("C:/Users/emily/OneDrive - The Pennsylvania State University/Research/git/ganda-lab/recipe16S/data/dada2tutorial.RData")

## Install
if (!requireNamespace("BiocManager", quietly = TRUE))
  {install.packages("BiocManager")}
BiocManager::install("dada2", version = "3.10") # note that this needs R 3.6

# If already installed: 
require(dada2)

# path to reads
path <- PATH

#### ---- data massage and filter/trim ----

# get matched list of forward and reverse files
# this data set is single end reads
fnFs <- sort(list.files(path, pattern = "L001_R1_001.fastq.gz", full.names = TRUE))
##fnRs <- sort(list.files(path, pattern = "_R2_001.fastq.gz", full.names = TRUE))
sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1)
## inspect quality profile
plotQualityProfile(fnFs[1:2]) # looks like we should cut around 260

## filter and trim!
# create subdirectory
filtFs <- file.path(path, "filtered", paste0(sample.names, "_F_filt.fastq.gz"))
# filter
out <- filterAndTrim(fnFs, filtFs, truncLen=260, maxN=0, maxEE=2, truncQ=2,
                     rm.phix=TRUE, compress=TRUE, multithread=TRUE)
head(out)

## learn error rates - this runs for several minutes
errF <- learnErrors(filtFs, multithread = TRUE)
plotErrors(errF, nominalQ = TRUE)

#### ---- sample inference algorithm ---

dadaFs <- dada(filtFs, err = errF, multithread = TRUE)
# if paired; run the same for reverse reads
dadaFs[[1]]

# merge paired reads with mergePairs
# mergers <- mergePairs(dadaFs, filtFs, dadaRs, filtRs, verbose = T)

# construct sequence table of ASVs
seqtab <- makeSequenceTable(dadaFs)
dim(seqtab)

# inspect distribution of sequence lengths
table(nchar(getSequences(seqtab)))

# remove chimeras
seqtab.nochim <- removeBimeraDenovo(seqtab, method = "consensus", multithread = TRUE)
dim(seqtab.nochim)
sum(seqtab.nochim) / sum(seqtab) # frequency of chimeras

#### ---- track reads ----
# this allows us to see where we are losing reads along the way
getN <- function(x) sum(getUniques(x))
track <- cbind(out, sapply(dadaFs, getN), rowSums(seqtab.nochim))
colnames(track) <- c("input", "filtered", "denoisedF", "nonchim")
rownames(track) <- sample.names
head(track)
## my addition: percentage of reads lost from start to finish
track <- as.data.frame(track)
track$percentLost <- round((track$input - track$nonchim) / track$input * 100, 2)

## --- assign taxonomy ----

# note: follow instructions to download tarbell for the database
# path must point to downloaded database fa.gz

## older version: Silva database training set
taxa <- assignTaxonomy(seqtab.nochim, "~/Desktop/McArt/silva_nr_v132_train_set.fa",
                       multithread = TRUE)

## newer version: make species level assignment based on exact matching
# between ASV and sequenced reference strains.... 
taxa <- addSpecies(taxa, "~/Desktop/McArt/silva_species_assignment_v132.fa")
# inspect output - remove rownames for display
taxa.print <- taxa
rownames(taxa.print) <- NULL
head(taxa.print)

## another alternative: use IdTaxa from DECIPHER Bioconducter package
# is it beter than naive Bayesian classifer?
## CODE: from dada2 tutorial
## THIS RUNS TOO LONG
BiocManager::install("DECIPHER")
library(DECIPHER)
dna <- DNAStringSet(getSequences(seqtab.nochim)) # Create a DNAStringSet from the ASVs
load("~/Desktop/McArt/SILVA_SSU_r132_March2018.RData") # CHANGE TO THE PATH OF YOUR TRAINING SET
ids <- IdTaxa(dna, trainingSet, strand="top", processors=NULL, verbose=FALSE) # use all processors
ranks <- c("domain", "phylum", "class", "order", "family", "genus", "species") # ranks of interest
# Convert the output object of class "Taxa" to a matrix analogous to the output from assignTaxonomy
taxid <- t(sapply(ids, function(x) {
        m <- match(ranks, x$rank)
        taxa <- x$taxon[m]
        taxa[startsWith(taxa, "unclassified_")] <- NA
        taxa
}))
colnames(taxid) <- ranks; rownames(taxid) <- getSequences(seqtab.nochim)

### ---- phyloseq prep ----
BiocManager::install("phyloseq")
BiocManager::install("Biostrings")
require(phyloseq)
require(Biostrings)
require(ggplot2)
require(dplyr)

## need to read in sample dataframe
samples.out <- rownames(seqtab.nochim)
#subject <- sapply(strsplit(samples.out, "_F"), `[`, 1)
samp.data <- read.table("~/Desktop/McArt/cleanedSampData.txt", fill = TRUE,
                        header = TRUE, stringsAsFactors = TRUE) %>% 
  mutate(subject = paste0("R", SampleN, "_F_filt.fastq.gz"))
rownames(samp.data) <- samp.data$subject 
samp.data$subject <- NULL

# we're missing a sequence - remove #31
samp.data <- samp.data[!samp.data$SampleN == "31",]

# construct phyloseq object
ps <- phyloseq(otu_table(seqtab.nochim, taxa_are_rows=FALSE), 
               tax_table(taxa),
               sample_data(samp.data))
# convert full DNA string to ASV name
dna <- Biostrings::DNAStringSet(taxa_names(ps))
names(dna) <- taxa_names(ps)
ps <- merge_phyloseq(ps, dna)
taxa_names(ps) <- paste0("ASV", seq(ntaxa(ps)))
# examine phyloseq object
ps



## A FEW SHORT PHYLOSEQ
plot_richness(ps, x = "Case", measure = c("Shannon", "Simpson"))

ps.prop <- transform_sample_counts(ps, function(otu) otu/sum(otu))
ord.nmds.bray <- ordinate(ps.prop, method="NMDS", distance="bray")
plot_ordination(ps.prop, ord.nmds.bray, color="Case", title="Bray NMDS")

top20 <- names(sort(taxa_sums(ps), decreasing=TRUE))[1:20]
ps.top20 <- transform_sample_counts(ps, function(OTU) OTU/sum(OTU))
ps.top20 <- prune_taxa(top20, ps.top20)
plot_bar(ps.top20, x="Case", fill="Family") + facet_wrap(~Case, scales="free_x")


### --- save image ----
# for later: save .RData
#save.image("~/git/ganda-lab/recipe16S/data/dada2tutorial.RData")