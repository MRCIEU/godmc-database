library(readr)
library(dplyr)
bim<-read_table2("/panfs/panasas01/shared-godmc/1kg_reference_ph3/eur.bim.orig2",col_names=FALSE)
#10090068

#Add MAF
f <- read_table2(paste0("/panfs/panasas01/shared-godmc/1kg_reference_ph3/eur.frq.frq"))
f<-data.frame(f)
spl<-strsplit(bim$X2,split=":")
spl<-do.call("rbind",spl)
bim<-data.frame(bim,snptype=spl[,3],snp=f$SNP,MAF_1000G=f$MAF,NCHROMS_1000G=f$NCHROBS)
g<-grep("duplicate",bim$snp)
bim<-bim[-g,] #10085072


##
rs<-read_tsv("/panfs/panasas01/shared-godmc/1kg_reference_ph3/eur.bim.orig",col_names=FALSE)
#10090068
rs_df<-data.frame(rs)
g<-grep("duplicate",rs_df[,2])
rs<-rs[-g,] #10087432

out<-left_join(bim,rs,by=c("X1","X4","X5","X6")) 
#[1]  10086353       11

out_df<-data.frame(out)
out_df[out_df[,2]%in%c("chr23:99929532:SNP"),]
#        X1               X2.x X3.x       X4 X5 X6           X2.y X3.y
#9976202 23 chr23:99929532:SNP    0 99929532  C  G chr23:99929532    0
#9976203 23 chr23:99929532:SNP    0 99929532  C  G         rs8780    0

t<-data.frame(table(paste(out_df[,2],out_df[,5],out_df[,6])))
t2<-t[t$Freq>1,]
table(t2$Freq)
#   2 
#1281

dupl<-out_df[which(paste(out_df[,2],out_df[,5],out_df[,6])%in%t2$Var1[1]),]
#        X1              X2.x X3.x      X4 X5 X6                      X2.y X3.y
#6787269 12 chr12:8024909:SNP    0 8024909  C  G ss1388054857;ss1388054858    0
#6787270 12 chr12:8024909:SNP    0 8024909  C  G              ss1388054859    0


dupl<-out_df[which(paste(out_df[,2],out_df[,5],out_df[,6])%in%t2$Var1),]
dupl.out<-data.frame()
for (i in 1:nrow(t2)){
dupl2<-dupl[which(paste(dupl[,2],dupl[,5],dupl[,6])%in%t2$Var1[i]),]
g1<-grep("rs",dupl2[,7])
g2<-grep("ss",dupl2[,7])
g<-unique(c(g1,g2))
if(length(g)>1){
dupl2[,7]<-paste(dupl2[,7],collapse=";")
dupl2<-unique(dupl2)}

if(length(g)==1){
dupl2<-dupl2[g,]}
cat(nrow(dupl2),"\n")
cat(i,"\n")
dupl.out<-rbind(dupl.out,dupl2)
rm(g)
}

w<-which(paste(out_df[,2],out_df[,5],out_df[,6])%in%t2$Var1)
out_df<-out_df[-w,]
out_df<-rbind(out_df,dupl.out)
o<-order(out_df[,1],out_df[,4])
out_df<-out_df[o,]
names(out_df)<-c("chr","snp","cM","pos","allele1","allele2","type","snp2","freq1_1000G","nchrs_1000G","rsid","cM2")

###
out_df2<-data.frame()
for (i in 1:23){
out_df.chr<-out_df[out_df$chr==i,]
snp_cis<-read_tsv(paste0("/panfs/panasas01/shared-godmc/godmc_phase2_analysis/results/16/snpcpgpval.chr",i,".cistrans.txt.gz"))

snp_cis<-unique(snp_cis[,c("snp","snp_cis","min_pval","max_abs_Effect")])
names(snp_cis)<-c("snp_tested","snp_cis","min_pval","max_abs_Effect")
max(snp_cis$min_pval)
#[1] 0.9815

m<-match(out_df.chr[,2],snp_cis$snp_tested)
out_df.chr<-data.frame(out_df.chr,snp_cis[m,])

out_df2<-rbind(out_df2,out_df.chr)
}

#add clumped mqtl
load("/panfs/panasas01/shared-godmc/godmc_phase2_analysis/results/16/16_clumped.rdata")
clumped <- subset(clumped, (pval < 1e-14 & cis == FALSE) | (pval < 1e-8 & cis == TRUE ))
cl.snp<-unique(data.frame(mqtl_clumped=clumped$snp))
dim(cl.snp)

out_df2$mqtl_clumped<-out_df2$snp_tested
w<-which(!is.na(out_df2$mqtl_clumped))
out_df2$mqtl_clumped[w]<-"FALSE"

w<-which(out_df2$snp%in%cl.snp$mqtl_clumped)
out_df2$mqtl_clumped[w]<-"TRUE"
w<-which(is.na(out_df2$mqtl_clumped))
out_df2$mqtl_clumped[w]<-"not tested"

print(table(out_df2$mqtl_clumped))

#out_df2<-data.frame(name=out_df2$snp,rsid=out_df2$rsid,chr=out_df2$chr,out_df2$pos,allele1=out_df2$allele1,allele2=out_df2$allele2,freq1_1000G=out_df2$freq1_1000G,nchrs_1000G=out_df2$nchrs_1000G,freq1_se="",type=out_df2$snptype,assoc_class=out_df2$snp_cis,min_pval=out_df2$min_pval,max_abs_Effect=out_df2$max_abs_Effect,mqtl_clumped=out_df2$mqtl_clumped)
w<-which(names(out_df2)%in%c("cM","cM2","snp2"))
out_df2<-out_df2[,-w]
w<-which(names(out_df2)%in%c("snp_cis"))
names(out_df2)[w]<-"assoc_class"
w<-which(names(out_df2)%in%c("snp"))
names(out_df2)[w]<-"name"

out_df2$assoc_class<-gsub("FALSE","trans_only",out_df2$assoc_class)
out_df2$assoc_class<-gsub("TRUE","cis_only",out_df2$assoc_class)
w<-which(!is.na(out_df2$snp_tested))
out_df2$snp_tested[w]<-"TRUE"
out_df2$snp_tested[-w]<-"FALSE"

a1<-which(nchar(out_df2[,"allele1"])>nchar(out_df2[,"allele2"]))
out_df2[a1,"allele1"]<-"I"
out_df2[a1,"allele2"]<-"D"

a2<-which(nchar(out_df2[,"allele2"])>nchar(out_df2[,"allele1"]))
out_df2[a2,"allele2"]<-"I"
out_df2[a2,"allele1"]<-"D"

w<-which(nchar(out_df2$allele1)>1|nchar(out_df2$allele2)>1)

# remove indels of same length
ind <- which(out_df2$allele1 %in% c("A", "C", "T", "G", "D", "I") & out_df2$allele2 %in% c("A", "C", "T", "G", "D", "I"))
out_df2$snp_qc<-"PASS"
out_df2$snp_qc[-ind]<-"FAILED:indels with alleles of same length"

badsnps <- scan("/panfs/panasas01/shared-godmc/godmc_phase2_analysis/04_conditional_16/badsnps.txt", what=character())

ind <- which(out_df2$name %in% badsnps)
out_df2$snp_qc[ind]<-"FAILED:multiallelic"

save(out_df2,file="/panfs/panasas01/shared-godmc/database_files/snps.rdata")



