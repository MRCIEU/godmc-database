library(meffil)
library(data.table)
library(SDMTools)
retaincpg <- scan("~/repo/godmc_phase1_analysis/07.snp_cpg_selection/data/retain_from_zhou.txt", what="character")
 
#exclusion probes from TwinsUK
excl<-read.table("~/repo/godmc_phase1_analysis/07.snp_cpg_selection/data/450k_exclusion_probes.txt",he=T)
#42446

y<-meffil.get.features("450k")
cpgs<-unique(y$name)
ncpg<-length(unique(y$name))
#486425

df<-data.frame(name=y$name,probetype=y$type,chr=y$chromosome,pos=y$position)
w<-which(df$name%in%retaincpg==FALSE)
df$qc_zhou<-"FALSE"
df$qc_zhou[w]<-"TRUE"
w<-which(df$name%in%excl[,1])
df$qc_twinsuk<-"FALSE"
df$qc_twinsuk[w]<-"TRUE"

load("/panfs/panasas01/shared-godmc/godmc_phase2_analysis/results/16/16_clumped.rdata")
clumped2<-clumped[which(clumped$cis==TRUE & clumped$pval<1e-8 | clumped$cis==FALSE & clumped$pval<1e-14),]
table(clumped2$cis)
# FALSE   TRUE 
# 23117 248607 
length(unique(clumped2$cpg))
#190102

data=as.data.table(clumped2)
# data[,cpgchr:=gsub("23","X",cpgchr),]
# data[,cpgchr:=gsub("24","Y",cpgchr),]
data$cpgchr <- as.numeric(gsub("chr", "", data$cpgchr))
data[,cpg_cis:=ifelse(all(cis),"cis only",ifelse(all(!cis),"trans only","ambivalent")),by=c("cpgchr","cpgpos")]

clumped2<-data.frame(data)

cpg_cis<-unique(data.frame(cpg=clumped2$cpg,cpg_cis=clumped2$cpg_cis))
table(cpg_cis$cpg_cis)

m<-match(df$name,cpg_cis$cpg)
df<-data.frame(df,assoc_class=cpg_cis$cpg_cis[m])
w<-which(df$qc_zhou==TRUE|df$qc_twinsuk==TRUE)
df$assoc_class<-as.character(df$assoc_class)
df$assoc_class[w]<-rep("probe didn't pass qc",length(w))

#
cohort_dir="/panfs/panasas01/shared-godmc/results/01/"
ss<-read.table("/panfs/panasas01/shared-godmc/godmc_phase2_analysis/data/descriptives/cohortsizeslambda.txt")
ss$V1<-gsub("_16","",ss$V1)
ss$V1<-gsub("00_ARIES","ARIES",ss$V1)
ss<-ss[which(ss$V1%in%c("MARS_omni","Factor_V_Leiden_Family_Study")==F),]
cohort<-ss$V1

sd.out<-data.frame(cpgs)
mean.out<-data.frame(cpgs)

for (i in 1:length(cohort)){
cat(cohort[i],"\n")
load(paste0(cohort_dir,cohort[i],"_01/results/01/methylation_summary.RData"))
m<-match(cpgs,row.names(meth_summary))
sd<-meth_summary[m,"sd"]
sd.out<-data.frame(sd.out,sd)
mean.df<-meth_summary[m,"mean"]
mean.out<-data.frame(mean.out,mean.df)

}
row.names(mean.out)<-cpgs

names(sd.out)[-1]<-cohort
sd.out<-sd.out[,-1]

names(mean.out)[-1]<-cohort
mean.out<-mean.out[,-1]

meanmean<-apply(mean.out,1,function(x) wt.mean(as.numeric(x),wt=as.numeric(ss$V2)))
sdmean<-apply(sd.out,1,function(x) wt.sd(as.numeric(x),wt=as.numeric(ss$V2)))

m<-match(cpgs,names(meanmean))
df2<-unique(data.frame(cpg=cpgs,weighted_mean=meanmean[m],weighted_sd=sdmean[m]))

ss<-read.table("/panfs/panasas01/shared-godmc/godmc_phase2_analysis/data/descriptives/descriptives.phase2.txt",sep="\t",he=T)
m<-match(names(mean.out),ss$study)
ss<-ss[m,c("study","nsamples01")]

n.out<-mean.out
for (i in 1:length(cohort)){
cat(cohort[i],"\n")
n.out[which(!is.na(n.out[,i])),i]<-ss$nsamples01[i]
}

cpg_n<-apply(n.out,1,function(x) sum(x,na.rm=T))
m<-match(df2$cpg,names(cpg_n))
df2<-data.frame(df2,samplesize=cpg_n[m])

m<-match(df$name,df2$cpg)
df<-data.frame(df,df2[m,-1])

df<-data.frame(df[,c("name","probetype","chr","pos","assoc_class","qc_zhou","qc_twinsuk","weighted_mean","weighted_sd","samplesize")])
df$name<-as.character(df$name)
df$chr<-as.character(df$chr)
save(df,file="/panfs/panasas01/shared-godmc/database_files/cpgs.rdata")
w<-which(df$probetype=="control")
df[w,c("chr","pos","assoc_class","qc_zhou","qc_twinsuk","weighted_mean","weighted_sd","samplesize")]<-"NULL"
write.csv(df,file="/panfs/panasas01/shared-godmc/database_files/cpgs.csv",na="NULL",row.names=FALSE)



