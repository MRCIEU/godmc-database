library(TwoSampleMR)
ao <- available_outcomes()
library(dplyr)
source("utils.r")

args <- commandArgs(T)
instdat <- args[1]
topdat <- args[2]
outdir <- args[3]


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
	ncontrol=gkeep$ncontrol.exposure,
	mrbid=gkeep$mrbid
)

names(inst) <- modify_rel_headers_for_neo4j(inst, "snp", "snp", "id", "trait")

temp2 <- filter(ao, name %in% gkeep$exposure) %>% group_by(name, id) %>% summarise(n=n()) %>% arrange(desc(n)) %>% filter(!duplicated(name))
trait <- subset(ao, id %in% temp2$id) %>% as_data_frame
names(trait)[names(trait) == "id"] <- "mrbid"
temp <- data_frame(id=gkeep$id.exposure, name=gkeep$exposure) %>% filter(!duplicated(id))
trait <- inner_join(trait, temp)
names(trait) <- modify_node_headers_for_neo4j(trait, "id", "trait")


# Write trait

# Write inst





