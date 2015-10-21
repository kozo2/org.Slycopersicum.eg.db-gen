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

ensemble = read.table("Solanum_lycopersicum.GCA_000188115.2.28.uniprot.tsv", header = T)
fItag = merge(fUniprot, ensemble, by.x = "UNIPROT", by.y = "xref")
fItag = unique(fItag[, c(2,4)])
colnames(fItag) = c("GID", "ITAG")

solgenomics = read.csv("tomato_unigenes_solyc_conversion_annotated.csv", header = F)
solg = solgenomics[, c(1,2)]
colnames(solg) = c("SGN", "ITAG")
fSgn = merge(fItag, solg)[, c(2,3)]

library(AnnotationForge)
makeOrgPackage(gene_info = fSym, chromosome = fChr, go = fGO, uniprot = fUniprot, itag = fItag, sgn = fSgn,
               version = "0.1",
               maintainer = "Atsushi Fukushima <atsushi.fukushima@riken.jp>",
               author = "Kozo Nishida <knishida@riken.jp>",
               outputDir = ".",
               tax_id = "4081",
               genus = "Solanum",
               species = "lycopersicum",
               goTable = "go")
