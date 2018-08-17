#!/bin/bash

# nodes
# - snp data
# - cpg data
# - annotations
# - traits

# relationships
# - mQTL results - snp-cpg
# - 2D enrichment - annotation-annotation
# - cpg communities - cpg-cpg
# - MR of cpg-trait - cpg-trait
# - MR of trait-cpg - trait-cpg


workdir="/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc-database/neo4j"
phase2dir="/mnt/storage/private/mrcieu/research/GODMC_Analysis/godmc_phase2_analysis"
mkdir -p $workdir/data/mqtl
mkdir -p $workdir/data/2d
mkdir -p $workdir/data/communities
mkdir -p $workdir/data/cpg-trait
mkdir -p $workdir/data/trait-cpg


# mqtl
## sftp stuff

Rscript mqtl.r \
	../data/mqtl/cpgs.rdata \
	$phase2dir/05_cis-trans-networks/results/graph.rdata \
	../data/mqtl/snps.rdata \
	../data/mqtl/assoc_meta_all.csv \
	../data/mqtl
gzip -f ../data/mqtl/cpgs.csv
gzip -f ../data/mqtl/snps.csv

sed 1d ../data/mqtl/assoc_meta_all.csv | gzip -c > ../data/mqtl/mqtl.csv.gz


# communities

Rscript communities.r \
	$phase2dir/05_cis-trans-networks/results/graph.rdata \
	../data/communities
gzip -f ../data/communities/coloc.csv


# trait-cpg

Rscript trait-cpg.r \
	$phase2dir/06_mr-gwas-cpg/data/snps_gwas.rdata \
	$phase2dir/06_mr-gwas-cpg/results/mrbase_tophits_full.rdata \
	../data/trait-cpg


# 2d

Rscript 2d.r \
	$phase2dir/11_2d-enrichments/data/annotations.rdata \
	$phase2dir/11_2d-enrichments/results/difres/difres0.rdata \
	../data/2d




# cpg-trait

Rscript cpg-trait.r \
	$phase2dir/10_mr-cpg-gwas/results \
	../data/cpg-trait




rm -rf ../neo4j-community-3.4.5/data/databases/temp.db
../neo4j-community-3.4.5/bin/neo4j-admin import \
--database temp.db \
--id-type string \
--ignore-missing-nodes=true \
--nodes:cpg "../data/mqtl/cpgs_header.csv,../data/mqtl/cpgs.csv.gz" \
--nodes:snp "../data/mqtl/snps_header.csv,../data/mqtl/snps.csv.gz" \
--nodes:trait "../data/trait-cpg/trait_header.csv,../data/trait-cpg/trait.csv.gz" \
--relationships:mr:coloc "../data/communities/coloc_header.csv,../data/communities/coloc.csv.gz" \
--relationships:mr "../data/trait-cpg/res_header.csv,../data/trait-cpg/res.csv.gz" \
--relationships:mr "../data/trait-cpg/het_header.csv,../data/trait-cpg/het.csv.gz" \
--relationships:mr "../data/trait-cpg/plei_header.csv,../data/trait-cpg/plei.csv.gz" \
--relationships:mr "../data/trait-cpg/full_header.csv,../data/trait-cpg/full.csv.gz" \
--relationships:ga "../data/trait-cpg/inst_header.csv,../data/trait-cpg/inst.csv.gz" \
--relationships:ga:mqtl "../data/mqtl/mqtl_header.csv,../data/mqtl/mqtl.csv.gz"





