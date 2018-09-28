library(dplyr)
source("utils.r")

annodat <- "/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc_phase2_analysis/11_2d-enrichments/data/annotations.rdata"
annobdat <- "/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc_phase2_analysis/11_2d-enrichments/data/blood.rdata"

difresdat <- "/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc_phase2_analysis/11_2d-enrichments/results/difres/difres0.rdata"

load(annodat)
a <- anno
load(annobdat)
load(difresdat)

anno$index <- paste0("lola", 1:nrow(anno))
names(anno)[names(anno) == "antibody2"] <- "name"
anno <- anno[,ncol(anno):1]
snpres$anno <- paste0("lola", snpres$anno)
cpgres$anno <- paste0("lola", cpgres$anno)

glimpse(difres)
difres$Var1 <- paste0("lola", difres$Var1)
difres$Var2 <- paste0("lola", difres$Var2)
names(difres) <- c("Var1", "Var2", "min", "q25", "median", "mean", "q75", "max", "val", "dif", "sds", "sddif")

names(anno) <- modify_node_headers_for_neo4j(anno, "index", "Lola")
write_out(anno, "../data/2d/lola", header=TRUE)

names(snpres) <- modify_rel_headers_for_neo4j(snpres, "anno", "Lola", "snp", "Snp")
write_out(snpres, "../data/2d/snp", header=TRUE)

names(cpgres) <- modify_rel_headers_for_neo4j(cpgres, "anno", "Lola", "cpg", "Cpg")
write_out(cpgres, "../data/2d/cpg", header=TRUE)

names(difres) <- modify_rel_headers_for_neo4j(difres, "Var1", "Lola", "Var2", "Lola")
write_out(difres, "../data/2d/2d", header=TRUE)

