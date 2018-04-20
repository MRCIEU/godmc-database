tss<-read.table("/panfs/panasas01/shared-godmc/gencode/gencode.v19.annotation.gtf.gz",skip=5,sep="\t")
names(tss)[1:5]<-c("chromosome","source","type","start","end")
#2619444       9
table(tss$type)

#           CDS           exon           gene Selenocysteine    start_codon 
#        723784        1196293          57820            114          84144 
#    stop_codon     transcript            UTR 
#         76196         196520         284573 

#tss<-tss[tss$type=="transcript",]

gene<-tss[tss$type=="gene",]
#[1] 57820     9

spl<-do.call("rbind",strsplit(as.character(gene$V9),split=";"))
spl[,5]<-gsub(" gene_name ","",spl[,5])
gene<-data.frame(gene,gene_type=spl[,3],genename=spl[,5])

#https://www.gencodegenes.org/gencode_biotypes.html
data.frame(table(gene$gene_type))
#                                  Var1  Freq
#1   gene_type 3prime_overlapping_ncrna    21
#2                  gene_type antisense  5276
#3                  gene_type IG_C_gene    14
#4            gene_type IG_C_pseudogene     9
#5                  gene_type IG_D_gene    37
#6                  gene_type IG_J_gene    18
#7            gene_type IG_J_pseudogene     3
#8                  gene_type IG_V_gene   138
#9            gene_type IG_V_pseudogene   187
#10                   gene_type lincRNA  7114
#11                     gene_type miRNA  3055
#12                  gene_type misc_RNA  2034
#13                   gene_type Mt_rRNA     2
#14                   gene_type Mt_tRNA    22
#15    gene_type polymorphic_pseudogene    45
#16      gene_type processed_transcript   515
#17            gene_type protein_coding 20345
#18                gene_type pseudogene 13931
#19                      gene_type rRNA   527
#20            gene_type sense_intronic   742
#21         gene_type sense_overlapping   202
#22                    gene_type snoRNA  1457
#23                     gene_type snRNA  1916
#24                 gene_type TR_C_gene     5
#25                 gene_type TR_D_gene     3
#26                 gene_type TR_J_gene    74
#27           gene_type TR_J_pseudogene     4
#28                 gene_type TR_V_gene    97
#29           gene_type TR_V_pseudogene    27




gene<-gene[which(gene$gene_type%in%c(" gene_type protein_coding"," gene_type TR_C_gene"," gene_type TR_D_gene"," gene_type TR_J_gene"," gene_type TR_V_gene"," gene_type IG_C_gene"," gene_type IG_D_gene"," gene_type IG_J_gene"," gene_type IG_V_gene")),]

w<-which(gene$V7=="-")
gene$start.original<-gene$start
gene$end.original<-gene$end
 
gene$start[w]<-gene$end[w]
gene$end[w]<-gene$start.original[w]
 

names(gene)
df<-data.frame(chr=gene$chromosome,start_pos=gene$start.original,stop_pos=gene$end.original,genename=gene$genename,start.original=gene$start,stop.original=gene$end,source=gene$source,strand.original=gene$V7,annotation=gene$V9, gene_type=gene$gene_type)

write.csv(df,file="/panfs/panasas01/shared-godmc/database_files/genes.csv",na="NULL",row.names=FALSE)



