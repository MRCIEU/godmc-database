# GoDMC-Neo4J

## Setup

Download the neo4j software

```bash
wget https://neo4j.com/artifact.php?name=neo4j-community-3.4.6-unix.tar.gz
tar xzvf artifact.php?name=neo4j-community-3.4.6-unix.tar.gz
```

## Generate data

Bring together the mQTL, MR, community and 2D enrichment data

`trait_id_master.r` creates a key to map the trait IDs used in different steps of the analysis. Note that some data was destroyed which means that sometimes the exact data source is guessed - this is rare and it is unlikely to have any major effect

`organise_data.sh` brings together all the data. Note that first the mqtl and snp/cpg data needs to be generated using the scripts in `godmc-database/input_prep/scripts`. Then `cpgs.rdata`, `snps.rdata` and `assoc_meta_all.csv` need to be copied to  `data/mqtl`.

`build_neo4j.sh` will build the graph database


