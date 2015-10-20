gi <- read.csv("gene_info.csv")
genes <- read.csv("genes.csv")
fSym <- merge(genes, gi)[, c(2,3,4)]

chr <- read.csv("chromosomes.csv")
fChr <- merge(genes, chr)[, c(2,3)]

go <- read.csv("go.csv")
fGO <- merge(genes, go)[, c(2,3,4)]

library(splitstackshape)
uniprot = read.table("entrez2uniprot.tab", header = T)
colnames(uniprot) = c("GID", "UNIPROT")
fUniprot = as.data.frame.matrix(cSplit(uniprot, "GID", ",", direction = "long"))

library(AnnotationForge)
makeOrgPackage(gene_info = fSym, chromosome = fChr, go = fGO, uniprot = fUniprot,
               version = "0.1",
               maintainer = "Kozo Nishida <knishida@riken.jp>",
               author = "Kozo Nishida <knishida@riken.jp>",
               outputDir = ".",
               tax_id = "4081",
               genus = "Solanum",
               species = "lycopersicum",
               goTable = "go")
