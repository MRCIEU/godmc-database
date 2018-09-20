library(TwoSampleMR)
ao <- available_outcomes()
library(dplyr)
source("utils.r")

instdat <- "/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc_phase2_analysis/06_mr-gwas-cpg/data/snps_gwas.rdata"

load(instdat)


gkeep <- filter(a, grepl("mr", data_source.exposure))
gkeeps <- gkeep %>% group_by(id.exposure, trait, exposure) %>% summarise(n=n()) %>% arrange(desc(n)) %>% ungroup %>% filter(!duplicated(trait))
gkeep <- gkeep %>% filter(id.exposure %in% gkeeps$id.exposure) %>% as_data_frame

ao$name <- paste(ao$trait, "||", ao$consortium, "||", ao$year, "||", ao$unit)

traits <- unique(gkeep$exposure)
table(traits %in% ao$name)
rename <- traits[which(!traits %in% ao$name)]

gkeep$exposure[gkeep$exposure == rename[1]] <- "Serum creatinine (eGFRcrea) || CKDGen || 2015 || log ml/min/1.73 m^2"
gkeep$exposure[gkeep$exposure == rename[2]] <- "Serum cystatin C (eGFRcys) || CKDGen || 2015 || log ml/min/1.73 m^2"
gkeep$exposure[gkeep$exposure == rename[3]] <- "Father's age at death || UK Biobank || 2016 || SD"
gkeep$exposure[gkeep$exposure == rename[4]] <- "Mother's age at death || UK Biobank || 2016 || SD"

traits <- unique(gkeep$exposure)
table(traits %in% ao$name)


temp <- group_by(gkeep, exposure, id.exposure) %>% summarise(n=n())
temp2 <- filter(ao, name %in% gkeep$exposure) %>% group_by(name, id) %>% summarise(n=n()) %>% arrange(desc(n)) %>% filter(!duplicated(name))
temp2 <- data_frame(exposure = temp2$name, mrbid=temp2$id)

gkeep <- left_join(gkeep, temp2)
gkeep$trait <- strsplit(gkeep$exposure, split="\\|") %>% sapply(function(x) x[1]) %>% gsub(" $", "", .)

inst <- data_frame(
	snp = gkeep$id,
	rsid = gkeep$SNP,
	effect_allele=gkeep$effect_allele.exposure,
	other_allele=gkeep$other_allele.exposure,
	beta=gkeep$beta.exposure,
	se=gkeep$se.exposure,
	pval=gkeep$pval.exposure,
	trait=gkeep$trait,
	mr_keep=gkeep$mr_keep.exposure,
	units=gkeep$units.exposure_dat,
	id=gkeep$id.exposure,
	samplesize=gkeep$samplesize.exposure,
	ncase=gkeep$ncase.exposure,
	ncontrol=gkeep$ncontrol.exposure
)

names(inst) <- modify_rel_headers_for_neo4j(inst, "snp", "snp", "id", "trait")

temp2 <- filter(ao, name %in% gkeep$exposure) %>% group_by(name, id) %>% summarise(n=n()) %>% arrange(desc(n)) %>% filter(!duplicated(name))
trait_firstpass <- subset(ao, id %in% temp2$id) %>% as_data_frame
names(trait_firstpass)[names(trait_firstpass) == "id"] <- "mrbid"
temp <- data_frame(id=gkeep$id.exposure, name=gkeep$exposure) %>% filter(!duplicated(id))
trait_firstpass <- inner_join(trait_firstpass, temp)
names(trait_firstpass) <- modify_node_headers_for_neo4j(trait_firstpass, "id", "trait")



#################





a <- read.csv("/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc_phase2_analysis/data/gwas/00info.csv", stringsAsFactors=FALSE)
a$index <- 1:nrow(a)

# b <- read.table("/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc-database/neo4j/data/trait-cpg/trait.csv.gz", header=FALSE, sep=",", stringsAsFactors=FALSE)
# c <- scan("/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc-database/neo4j/data/trait-cpg/trait_header.csv", sep=",", what="character")
# names(b) <- c
b <- trait_firstpass

a$trait[grepl("Father", a$trait)] <- "Father's age at death"
a$trait[grepl("Mother", a$trait)] <- "Mother's age at death"


table(b$trait %in% a$trait)
b$trait[!b$trait %in% a$trait]

a$trait[grep("Weight", a$trait, ignore.case=TRUE)]

traits10 <- a
traits10$id <- as.character(traits10$id)

temp1 <- data_frame(id=b$mrbid, newid=b$`traitId:ID(trait)`)
traits10 <- left_join(traits10, temp1, by="id")
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
traits10_k <- subset(traits10, id %in% traits$mrbid)




# name and id for 10
# name and id for 06
# name and id for mrbase



backmatch <- data_frame(id_mrb=traits$mrbid, id_06=traits$`traitId:ID(trait)`, name_06=traits$name)

table(backmatch$id_mrb %in% traits10$id)

traits10 <- subset(traits10, select=-c(newid))
traits10_m <- full_join(traits10, backmatch, by=c("id"="id_mrb"))

master <- data_frame(
	id_10=traits10_m$index, 
	name_10=traits10_m$trait,
	id_06=traits10_m$id_06,
	name_06=traits10_m$name_06,
	id_mrb=traits10_m$id
)

temp <- data_frame(id_mrb=ao$id, name_mrb=ao$trait)
master <- full_join(master, temp)


master <- subset(master, !id_mrb == 1102)
master$id_mrb[master$id_mrb == 991] <- 1102



save(master, file="../data/trait_id_master.rdata")
write.table(master, file="../data/trait_id_master.txt")


library(magrittr)
ao <- TwoSampleMR::available_outcomes()
b <- subset(ao, id %in% subset(master, !is.na(id_06))$id_mrb) %$% 
	data_frame(trait, author, pmid, sample_size, ncase, ncontrol, subcategory)
write.csv(b, "../data/traits_06.csv")