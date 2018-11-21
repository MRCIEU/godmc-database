ao <- TwoSampleMR::available_outcomes()
library(dplyr)
library(data.table)
a <- fread("zcat ../data/trait-cpg/res.csv.gz")
b <- scan("../data/trait-cpg/res_header.csv", what="character", sep=",")
names(a) <- c("trait", "cpg", "method", "nsnp", "beta", "se", "pval", "chunk", "decision", "pass")
a <- subset(a, select=-c(chunk))
load("../data/trait_id_master.rdata")
master <- subset(master, !id_mrb %in% subset(ao, access == "developer")$id)

temp <- subset(master, select=c(name_10, id_06))
index <- match(a$trait, master$id_06)
a$trait <- master$name_10[index]



b <- fread("zcat ../data/cpg-trait/coloc.csv.gz")
names(b) <- c("sentinel_snp", "cpg", "nsnp", "H0", "H1", "H2", "H3", "H4", "effect_allele", "other_allele", "effect_allele_freq", "waldratio_beta", "waldratio_se", "waldratio_pval", "trait_samplesize", "trait")

index <- match(b$trait, master$id_06)
b$trait <- master$name_10[index]

setcolorder(b, c("cpg", "trait", "nsnp", "H0", "H1", "H2", "H3", "H4", "sentinel_snp", "effect_allele", "other_allele", "effect_allele_freq", "waldratio_beta", "waldratio_se", "waldratio_pval", "trait_samplesize"))


b <- subset(b, H4 > 0.5) %>% arrange(desc(H4))

write.csv(a, file="../data/trait-cpg.csv")
write.csv(b, file="../data/cpg-trait.csv")


