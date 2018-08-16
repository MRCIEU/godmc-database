source("utils.r")

args <- commandArgs(T)

datfile <- args[1]
outdir <- args[2]

load(datfile)
names(dat) <- modify_rel_headers_for_neo4j(dat, "creg", "cpg", "tcpg", "cpg")

write.table(dat[0,], file=paste0(outdir, "/coloc_header.csv"), row.names=FALSE, col.names=TRUE, sep=",")
write.table(dat, file=paste0(outdir, "/coloc.csv"), row.names=FALSE, col.names=FALSE, na="", sep=",")

