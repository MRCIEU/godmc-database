library(dplyr)
source("utils.r")

a <- read.csv("/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc_phase2_analysis/data/gwas/00info.csv", stringsAsFactors=FALSE)
a$index <- 1:nrow(a)

b <- read.table("/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc-database/neo4j/data/trait-cpg/trait.csv.gz", header=FALSE, sep=",", stringsAsFactors=FALSE)
c <- scan("/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc-database/neo4j/data/trait-cpg/trait_header.csv", sep=",", what="character")
names(b) <- c


a$trait[grepl("Father", a$trait)] <- "Father's age at death"
a$trait[grepl("Mother", a$trait)] <- "Mother's age at death"


table(b$trait %in% a$trait)
b$trait[!b$trait %in% a$trait]

a$trait[grep("Weight", a$trait, ignore.case=TRUE)]

traits10 <- a

temp1 <- data_frame(id=b$mrbid, newid=b$`traitId:ID(trait)`, trait=b$trait)
traits10 <- left_join(traits10, temp1)
temp2 <- data_frame(id=traits10$id, trait=traits10$trait)

temp <- subset(traits10, trait %in% b$trait)

t2 <- subset(b, !mrbid %in% temp$id & trait %in% temp$trait)

dim(t2)

t2 <- left_join(t2, temp2)

dim(t2)

head(t2)
table(t2$mrbid == t2$id)
t2$mrbid <- t2$id
t2 <- subset(t2, select=-c(id))
t1 <- subset(b, !`traitId:ID(trait)` %in% t2$`traitId:ID(trait)`)

traits <- rbind(t1, t2)
stopifnot(all(names(traits) == c))
traits10_k <- subset(traits10, id %in% traits$mrbid)

write_out(traits, "../data/trait-cpg/trait", header=TRUE)


##

# tophits with coloc
load("/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc_phase2_analysis/10_mr-cpg-gwas/results/cpg_trait_coloc.rdata")
res <- subset(res, outcome %in% traits$mrbid)

temp <- data_frame(outcome=as.character(traits$mrbid), id=traits$`traitId:ID(trait)`)
res <- left_join(res, temp)
res <- subset(res, select=-c(outcome))
names(res)[names(res) == "snp"] <- "rsid"
names(res)[names(res) == "b"] <- "beta"
names(res)[names(res) == "p"] <- "pval"

names(res) <- modify_rel_headers_for_neo4j(res, "exposure", "cpg", "id", "trait")
write_out(res, "../data/cpg-trait/coloc")

##

# full

fn <- paste0("/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc_phase2_analysis/10_mr-cpg-gwas/results/mr_ld/out_", traits10_k$index, ".rdata")

load(fn[1])
if("maxnsnp" %in% names(res))
{
	res <- subset(res, select=-c(maxnsnp))
}
names(res) <- c("exposure", "outcome", "method", "beta", "se", "pval", "Q_pval", "nsnp")
names(res) <- modify_rel_headers_for_neo4j(res, "exposure", "cpg", "outcome", "trait")

write.table(res[0,], file="../data/cpg-trait/full_header.csv", row=FALSE, col=TRUE, sep=",")


g <- gzfile("../data/cpg-trait/full.csv.gz", "w")
for(i in 1:length(fn))
{
	message(i)
	load(fn[i])
	newout <- subset(traits, mrbid %in% traits10$id[res$outcome[1]])$`traitId:ID(trait)`
	if(length(newout) == 0)
	{
		message("skip")
	} else {
		res$outcome <- newout		
		if("maxnsnp" %in% names(res))
		{
			res <- subset(res, select=-c(maxnsnp))
		}
		names(res) <- c("exposure", "outcome", "method", "beta", "se", "pval", "Q_pval", "nsnp")
		names(res) <- modify_rel_headers_for_neo4j(res, "exposure", "cpg", "outcome", "trait")
		write.table(res, g, row=FALSE, col=FALSE, sep=",", na="")
	}
}
close(g)





