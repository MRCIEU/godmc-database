ao <- TwoSampleMR::available_outcomes()
library(dplyr)
source("utils.r")

load("../data/trait_id_master.rdata")


# tophits with coloc
load("/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc_phase2_analysis/10_mr-cpg-gwas/results/cpg_trait_coloc.rdata")

master <- subset(master, !id_mrb %in% subset(ao, access == "developer")$id)

idlist <- subset(master, !is.na(id_06))$id_mrb
res <- subset(res, outcome %in% idlist)


temp <- data_frame(outcome=as.character(master$id_mrb), id=master$id_06) %>% filter(!is.na(id))
res <- left_join(res, temp) 
res <- subset(res, select=-c(outcome))
names(res)[names(res) == "snp"] <- "rsid"
names(res)[names(res) == "b"] <- "beta"
names(res)[names(res) == "p"] <- "pval"

names(res) <- modify_rel_headers_for_neo4j(res, "exposure", "Cpg", "id", "Trait")
write_out(res, "../data/cpg-trait/coloc", header=TRUE)

##

# full

idlist10 <- subset(master, id_mrb %in% idlist)$id_10 %>% na.omit %>% as.character

fn <- paste0("/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc_phase2_analysis/10_mr-cpg-gwas/results/mr_ld/out_", idlist10, ".rdata")

load(fn[1])

res <- data_frame(exposure=res$cpg, outcome=res$outcome, method=res$method, beta=res$Estimate, se=res$StdError, pval=res$Pvalue, Q_pval=res$heter, nsnp=res$nsnp)
names(res) <- modify_rel_headers_for_neo4j(res, "exposure", "Cpg", "outcome", "Trait")

write.table(res[0,], file="../data/cpg-trait/full_header.csv", row=FALSE, col=TRUE, sep=",")


g <- gzfile("../data/cpg-trait/full.csv.gz", "w")
for(i in 1:length(fn))
{
	message(i, " of ", length(fn))
	load(fn[i])

	newout <- subset(master, id_10 == res$outcome[1])$id_06
	if(length(newout) == 0)
	{
		message("skip")
	} else {
		if("exposure" %in% names(res))
		{
			names(res)[names(res) == "exposure"] <- "cpg"
		}
		res <- data_frame(exposure=res$cpg, outcome=res$outcome, method=res$method, beta=res$Estimate, se=res$StdError, pval=res$Pvalue, Q_pval=res$heter, nsnp=res$nsnp)
		res$outcome <- newout		
		res <- filter(res, !is.infinite(se))
		write.table(res, g, row=FALSE, col=FALSE, sep=",", na="")
	}
}
close(g)






