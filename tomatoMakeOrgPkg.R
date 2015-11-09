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

lycocyc = read.csv("lycocyc.csv", header = F)
trimmedItag = fItag
library(stringi)
trimmed = stri_sub(fItag$ITAG, 1, -3)
trimmedItag$tITAG = trimmed
itaggedLycocyc = merge(lycocyc, trimmedItag, by.x = "V4", by.y = "tITAG")

colnames(itaggedLycocyc) = c("tITAG", "lycocyc", "ec", "enzyme", "GID", "ITAG")
fEC = itaggedLycocyc[, c(5,3)]
fEC = unique(fEC)

fEnzyme = itaggedLycocyc[, c(5, 4)]
fEnzyme = unique(fEnzyme)

fLycocyc = itaggedLycocyc[, c(5, 2)]
fLycocyc = unique(fLycocyc)

library(GO.db)
library(AnnotationForge)
makeOrgPackage(gene_info = fSym, chromosome = fChr, go = fGO, uniprot = fUniprot, itag = fItag, sgn = fSgn, ec = fEC, enzyme = fEnzyme, lycocyc = fLycocyc,
               version = "0.1",
               maintainer = "Atsushi Fukushima <atsushi.fukushima@riken.jp>",
               author = "Kozo Nishida <knishida@riken.jp>",
               outputDir = ".",
               tax_id = "4081",
               genus = "Solanum",
               species = "lycopersicum",
               goTable = "go")
