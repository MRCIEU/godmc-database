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





rm -rf ../neo4j-community-3.4.5/data/databases/temp.db
../neo4j-community-3.4.5/bin/neo4j-admin import \
--database temp.db \
--id-type string \
--ignore-missing-nodes=true \
--nodes:cpg "../data/mqtl/cpgs_header.csv,../data/mqtl/cpgs.csv.gz" \
--nodes:snp "../data/mqtl/snps_header.csv,../data/mqtl/snps.csv.gz" \
--nodes:trait "../data/trait-cpg/trait_header.csv,../data/trait-cpg/trait.csv.gz" \
--nodes:lola "../data/2d/lola_header.csv,../data/2d/lola.csv.gz" \
--relationships:anno "../data/2d/snp_header.csv,../data/2d/snp.csv.gz" \
--relationships:anno "../data/2d/cpg_header.csv,../data/2d/cpg.csv.gz" \
--relationships:2d "../data/2d/2d_header.csv,../data/2d/2d.csv.gz" \
--relationships:mr:coloc "../data/communities/coloc_header.csv,../data/communities/coloc.csv.gz" \
--relationships:mr "../data/trait-cpg/res_header.csv,../data/trait-cpg/res.csv.gz" \
--relationships:mr "../data/trait-cpg/het_header.csv,../data/trait-cpg/het.csv.gz" \
--relationships:mr "../data/trait-cpg/plei_header.csv,../data/trait-cpg/plei.csv.gz" \
--relationships:mr "../data/trait-cpg/full_header.csv,../data/trait-cpg/full.csv.gz" \
--relationships:mr "../data/cpg-trait/full_header.csv,../data/cpg-trait/full.csv.gz" \
--relationships:mr:coloc "../data/cpg-trait/coloc_header.csv,../data/trait-cpg/coloc.csv.gz" \
--relationships:ga "../data/trait-cpg/inst_header.csv,../data/trait-cpg/inst.csv.gz" \
--relationships:ga:mqtl "../data/mqtl/mqtl_header.csv,../data/mqtl/mqtl.csv.gz"

