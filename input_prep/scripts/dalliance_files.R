library(readr)
#r<-read_tsv("gwas_catalog_180627.txt")
#r<-data.frame(r)

#downloaded from  http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/
r2<-read_tsv("gwasCatalog.txt",col_names=F)
r2<-data.frame(r2)
r2<-r2[which(r2$X18<5e-8),]
r3<-data.frame(r2$X2,r2$X3,r2$X4)
p<-paste0(r2$X5,";",r2$X11,"(",r2$X7,")")
p<-gsub(" ","_",p)
write.table(r3,"gwasCatalog.bed",sep=" ",col.names=F,quote=F,row.names=F)

#sort -k1,1 -k2,2n gwasCatalog.bed >gwasCatalog_sorted.bed
#bedToBigBed gwasCatalog_sorted.bed chrom.sizes gwasCatalog_sorted.bb

r2<-read_tsv("EWAS_Catalog_20-02-2018.txt.gz")
r2<-data.frame(r2)
r2<-r2[which(r2$P<1e-7),]
chr<-strsplit(r2$Location,split=":")
chr<-do.call("rbind",chr)
start<-as.numeric(chr[,2])-1
stop<-chr[,2]
name<-paste0(r2$CpG,";",r2$Trait,"(",r2$Author,")")
name<-gsub(" ","_",name)
bed<-data.frame(chr[,1],start,stop,name)
write.table(r3,"ewasCatalog.bed",sep=" ",col.names=F,quote=F,row.names=F)

#sort -k1,1 -k2,2n ewasCatalog.bed >ewasCatalog_sorted.bed
#bedToBigBed ewasCatalog_sorted.bed chrom.sizes ewasCatalog_sorted.bb
