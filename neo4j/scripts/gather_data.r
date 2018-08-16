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


# trait-cpg

Rscript trait-cpg.r \
	$phase2dir/06_mr-gwas-cpg/data/snps_gwas.rdata \
	$phase2dir/06_mr-gwas-cpg/results/mrbase_tophits_full.rdata \
	$workdir/data/trait-cpg


# 2d

Rscript 2d.r \
	$phase2dir/11_2d-enrichments/data/annotations.rdata \
	$phase2dir/11_2d-enrichments/results/difres/difres0.rdata \
	$workdir/data/2d


# communities

Rscript communities.r \
	$phase2dir/05_cis-trans-networks/results/graph.rdata
	$workdir/data/communities


# cpg-trait

Rscript cpg-trait.r \
	$phase2dir/10_mr-cpg-gwas/results \
	$workdir/data/cpg-trait




$neo4j/bin/neo4j-admin import \
--database temp.db \
--id-type string \
--nodes:cpg "cpgs_header.csv,cpgs.csv" \
--nodes:snp "snps_header.csv,snps.csv"

rm -rf $neo4j/data/databases/temp.db





