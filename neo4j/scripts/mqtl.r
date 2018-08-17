library(dplyr)
source("utils.r")

cpgdat <- "../data/mqtl/cpgs.rdata"
graphdat <- "/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc_phase2_analysis/05_cis-trans-networks/results/graph.rdata"
snpdat <- "../data/mqtl/snps.rdata"
mqtldat <- "../data/mqtl/assoc_meta_all.csv"
outdir <- "../data/mqtl"

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


mqtl <- read.csv(mqtldat, nrows=5000)
names(mqtl) <- modify_rel_headers_for_neo4j(mqtl, "snp", "snp", "cpg", "cpg")

write.table(mqtl[0,], file=paste0(outdir, "/mqtl_header.csv"), row.names=FALSE, col.names=TRUE, sep=",")

