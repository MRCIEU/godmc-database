library(dplyr)
source("utils.r")

args <- commandArgs(T)
cpgdat <- args[1]
graphdat <- args[2]
snpdat <- args[3]
mqtldat <- args[4]
outdir <- args[5]

##

load(cpgdat)
df$id <- df$name
load(graphdat)
names(mem) <- c("name", "community")
df <- left_join(df, mem)
df$assoc_class[df$assoc_class == "probe didn't pass qc"] <- "qc_fail"
names(df) <- modify_node_headers_for_neo4j(df, "id", "cpg")



write.table(df, file=paste0(outdir, "/cpgs.csv"), row.names=FALSE, col.names=FALSE, na="", sep=",")
write.table(df[0,], file=paste0(outdir, "/cpgs_header.csv"), row.names=FALSE, col.names=TRUE, sep=",")


##

load(snpdat)
out_df2 <- subset(out_df2, !duplicated(name))
out_df2$id <- out_df2$name
names(out_df2) <- modify_node_headers_for_neo4j(out_df2, "id", "snp")

write.table(out_df2[0,], file=paste0(outdir, "/snps_header.csv"), row.names=FALSE, col.names=TRUE, sep=",")
write.table(out_df2, file=paste0(outdir, "/snps.csv"), row.names=FALSE, col.names=FALSE, na="", sep=",")



## 


mqtl <- read.csv(mqtldat, nrows=500)
names(mqtl) <- modify_rel_headers_for_neo4j(mqtl, "snp", "snp", "cpg", "cpg")
write.table(mqtl[0,], file=paste0(outdir, "/mqtl_header.csv"), row.names=FALSE, col.names=TRUE, sep=",")

