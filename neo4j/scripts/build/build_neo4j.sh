#!/bin/bash

set -e

version=`cat version.txt`

rm -rf ../neo4j-community-${version}/data/databases/godmc.db

../neo4j-community-${version}/bin/neo4j-admin import \
--database godmc.db \
--id-type string \
--ignore-missing-nodes=true \
--nodes:Cpg "../data/mqtl/cpgs_header.csv,../data/mqtl/cpgs.csv.gz" \
--nodes:Snp "../data/mqtl/snps_header.csv,../data/mqtl/snps.csv.gz" \
--nodes:Gene "../data/mqtl/gencode_header.csv,../data/mqtl/gencode.csv.gz" \
--nodes:Trait "../data/trait-cpg/trait_header.csv,../data/trait-cpg/trait.csv.gz" \
--nodes:Lola "../data/2d/lola_header.csv,../data/2d/lola.csv.gz" \
--relationships:ANNO "../data/2d/snp_header.csv,../data/2d/snp.csv.gz" \
--relationships:ANNO "../data/2d/cpg_header.csv,../data/2d/cpg.csv.gz" \
--relationships:TWOD "../data/2d/2d_header.csv,../data/2d/2d.csv.gz" \
--relationships:COLOC "../data/communities/coloc_header.csv,../data/communities/coloc.csv.gz" \
--relationships:MR "../data/trait-cpg/res_header.csv,../data/trait-cpg/res.csv.gz" \
--relationships:MR "../data/trait-cpg/het_header.csv,../data/trait-cpg/het.csv.gz" \
--relationships:MR "../data/trait-cpg/plei_header.csv,../data/trait-cpg/plei.csv.gz" \
--relationships:MR "../data/trait-cpg/full_header.csv,../data/trait-cpg/full.csv.gz" \
--relationships:MR "../data/cpg-trait/full_header.csv,../data/cpg-trait/full.csv.gz" \
--relationships:COLOC "../data/cpg-trait/coloc_header.csv,../data/cpg-trait/coloc.csv.gz" \
--relationships:GA "../data/trait-cpg/inst_header.csv,../data/trait-cpg/inst.csv.gz" \
--relationships:GA "../data/mqtl/mqtl_header.csv,../data/mqtl/mqtl.csv.gz" \
--relationships:ANNO "../data/mqtl/snp_gene_header.csv,../data/mqtl/snp_gene.csv.gz" \
--relationships:ANNO "../data/mqtl/cpg_gene_header.csv,../data/mqtl/cpg_gene.csv.gz"

# rsync -avu --progress neo4j-community-${version}/ gh13047@shark.epi.bris.ac.uk:godmc-database/neo4j/neo4j-community-${version}/

