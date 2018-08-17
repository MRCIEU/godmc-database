#!/bin/bash

# nodes
# - snp data
# - cpg data
# - lola annotations
# - traits

# relationships
# - mQTL results - snp-cpg
# - 2D enrichment - annotation-annotation
# - cpg communities - cpg-cpg
# - MR of cpg-trait - cpg-trait
# - MR of trait-cpg - trait-cpg


# mqtl (josine generated these files - get froms sftp)
# /panfs/panasas01/shared-godmc/database_files
# cpgs.rdata
# snps.rdata
# assoc_meta_all.csv

mkdir -p $workdir/data/mqtl
mkdir -p $workdir/data/2d
mkdir -p $workdir/data/communities
mkdir -p $workdir/data/cpg-trait
mkdir -p $workdir/data/trait-cpg

Rscript trait_id_master.r

Rscript mqtl.r
sed 1d ../data/mqtl/assoc_meta_all.csv | gzip -c > ../data/mqtl/mqtl.csv.gz

Rscript communities.r

Rscript trait-cpg.r

Rscript cpg-trait.r

Rscript 2d.r
