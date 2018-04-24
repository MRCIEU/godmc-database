library(data.table)
library(dplyr)
###
load("/panfs/panasas01/shared-godmc/database_files/snps.rdata")

#chunks<-c(1:962)
arguments<-commandArgs(T)
chunk<-as.numeric(arguments[1])


#res.all<-data.frame()
#for (chunk in 1:length(chunks)){

load(paste("/panfs/panasas01/shared-godmc/godmc_phase2_analysis/results/16/16_cleaned_",chunk,".rdata",sep=""))
res$chunk<-chunk
cat(nrow(res),"\n")
m<-match(res$snp,out_df2$name)
snpdf<-out_df2[m,]
res$Allele1<-toupper(res$Allele1)
res$Allele2<-toupper(res$Allele2)

w<-which(res$Allele1==snpdf$allele2&res$Allele2==snpdf$allele1)
res$allele1.new<-res$Allele1
res$allele2.new<-res$Allele2
res$Freq.new<-res$Freq1
res$Effect.new<-res$Effect
res$EffectARE.new<-res$EffectARE

res$allele1.new[w]<-res$Allele2[w]
res$allele2.new[w]<-res$Allele1[w]
res$Freq.new[w]<-1-res$Freq1[w]
res$Effect.new[w]<--(res$Effect[w])
res$EffectARE.new[w]<--(res$EffectARE[w])
res$num_studies<-res$HetDf+1
w<-which(names(res)%in%c("snpchr","snppos","snptype","cpgchr","cpgpos","Allele1","Allele2","Freq1","Effect","HetDf","EffectARE"))
res<-res[,-w]

#res.all<-rbind(res.all,res)
#}

#names(res.all)<-c("snp","cpg","freq_se","se","pval","direction","hetisq","hetchisq","hetpval","se_are","pval_are","tausq","se_mre","pval_mre","samplesize","cistrans","chunk","allele1","allele2","freq_a1","beta_a1","beta_are_a1","num_studies")
#save(res.all,"/panfs/panasas01/shared-godmc/database_files/assoc_meta.rdata")
#write.csv(res.all,file="/panfs/panasas01/shared-godmc/database_files/assoc_meta.csv",na="NULL")

names(res)<-c("snp","cpg","freq_se","se","pval","direction","hetisq","hetchisq","hetpval","se_are","pval_are","tausq","se_mre","pval_mre","samplesize","cistrans","chunk","allele1","allele2","freq_a1","beta_a1","beta_are_a1","num_studies")

write.csv(res,paste0(file="/panfs/panasas01/shared-godmc/database_files/assoc_meta",chunk,".csv"),na="NULL",row.names=F)

#awk -F"," 'BEGIN{OFS=",";} {print $2,$1,$21,$4,$5,$15,$18,$19,$20,$3,$16,$23,$6,$7,$8,$9,$12,$22,$10,$11,$13,$14,$17;}' <assoc_meta_all.csv >assoc_meta_all.csv2
#mv assoc_meta_all.csv2 assoc_meta_all.csv