library(dplyr)
source("utils.r")

datfile <- "/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc_phase2_analysis/05_cis-trans-networks/results/graph.rdata"

load(datfile)
names(dat) <- modify_rel_headers_for_neo4j(dat, "creg", "cpg", "tcpg", "cpg")

write_out(dat, "../data/communities/coloc", header=TRUE)

