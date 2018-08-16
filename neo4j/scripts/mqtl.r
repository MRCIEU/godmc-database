library(dplyr)
load("cpgs.rdata")

df$id <- df$name
nom <- names(df)

nom[nom == "id"] <- "cpgId:ID(cpg)"
names(df) <- nom

write.csv(df, file="cpgs.csv", row.names=FALSE, col.names=FALSE, na="")
write.csv(df[0,], file="cpgs_header.csv", row.names=FALSE, col.names=FALSE)

load("snps.rdata")
out_df2 <- subset(out_df2, !duplicated(name))
out_df2$`snpId:ID(snp)` <- out_df2$name
write.csv(out_df2[0,], file="snps_header.csv", row.names=FALSE, col.names=FALSE)
write.csv(out_df2, file="snps.csv", row.names=FALSE, col.names=FALSE, na="")



