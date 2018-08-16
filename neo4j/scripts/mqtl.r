library(dplyr)

args <- commandArgs(T)
cpgdat <- args[1]
snpdat <- args[2]
outdir <- args[3]


##

load(cpgdat)

df$id <- df$name
nom <- names(df)

nom[nom == "id"] <- "cpgId:ID(cpg)"
names(df) <- nom

write.csv(df, file=paste0(outdir, "/cpgs.csv"), row.names=FALSE, col.names=FALSE, na="")
write.csv(df[0,], file=paste0(outdir, "/cpgs_header.csv"), row.names=FALSE, col.names=FALSE)


##

load(snpdat)
out_df2 <- subset(out_df2, !duplicated(name))
out_df2$`snpId:ID(snp)` <- out_df2$name
write.csv(out_df2[0,], file=paste0(outdir, "/snps_header.csv"), row.names=FALSE, col.names=FALSE)
write.csv(out_df2, file=paste0(outdir, "/snps.csv"), row.names=FALSE, col.names=FALSE, na="")



