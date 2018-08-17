library(dplyr)
library(GenomicRanges)
source("utils.r")

cpgdat <- "../raw/cpgs.rdata"
graphdat <- "/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc_phase2_analysis/05_cis-trans-networks/results/graph.rdata"
snpdat <- "../raw/snps.rdata"
mqtldat <- "../raw/assoc_meta_all.csv"
genedat <- "../raw/genes.csv"


##

load(cpgdat)
df$id <- df$name
load(graphdat)
names(mem) <- c("name", "community")
df <- left_join(df, mem)
df$assoc_class[df$assoc_class == "probe didn't pass qc"] <- "qc_fail"
names(df) <- modify_node_headers_for_neo4j(df, "id", "cpg")

write_out(df, "../data/mqtl/cpgs", header=TRUE)

##

load(snpdat)
out_df2 <- subset(out_df2, !duplicated(name))
out_df2$id <- out_df2$name
names(out_df2) <- modify_node_headers_for_neo4j(out_df2, "id", "snp")

write_out(out_df2, "../data/mqtl/snps", header=TRUE)


##


gen <- read.csv(genedat, stringsAsFactors=FALSE)
gen <- subset(gen, !duplicated(name))

# gen$chr <- as.character(gen$chr)
# gen$chr[gen$chr == "23"] <- "X"
# gen$chr[gen$chr == "24"] <- "Y"
# gen$chr[gen$chr == "25"] <- "MT"
# gen$chr <- paste0("chr", gen$chr)

df <- subset(df, !is.na(df$`pos:INT`))
df$chr <- gsub("chr", "", df$chr)
df$chr[df$chr == "X"] <- 23
df$chr[df$chr == "Y"] <- 24
df$chr <- as.numeric(df$chr)

gr <- GRanges(gen$chr, IRanges(start=gen$start_pos - 25000, end=gen$start_pos + 25000), name=gen$name)
cpg <- GRanges(df$chr, IRanges(start=df$`pos:INT`, end=df$`pos:INT`), cpg=df$name)
snp <- GRanges(out_df2$chr, IRanges(start=out_df2$`pos:INT`, end=out_df2$`pos:INT`), snp=out_df2$name)

cpgi <- findOverlaps(gr, cpg) %>% as_data_frame
snpi <- findOverlaps(gr, snp) %>% as_data_frame

cpgi <- data_frame(cpg=df$name[cpgi$subjectHits], gene=gen$name[cpgi$queryHits])
snpi <- data_frame(snp=out_df2$name[snpi$subjectHits], gene=gen$name[snpi$queryHits])

names(gen) <- modify_node_headers_for_neo4j(gen, "name", "gene")
names(cpgi) <- modify_rel_headers_for_neo4j(cpgi, "gene", "gene", "cpg", "cpg")
names(snpi) <- modify_rel_headers_for_neo4j(snpi, "gene", "gene", "snp", "snp")

write_out(gen, "../data/mqtl/gencode", header=TRUE)
write_out(cpgi, "../data/mqtl/cpg_gene", header=TRUE)
write_out(snpi, "../data/mqtl/snp_gene", header=TRUE)

## 


mqtl <- read.csv(mqtldat, nrows=5000)
names(mqtl) <- modify_rel_headers_for_neo4j(mqtl, "snp", "snp", "cpg", "cpg")

write.table(mqtl[0,], file="../data/mqtl//mqtl_header.csv", row.names=FALSE, col.names=TRUE, sep=",")

