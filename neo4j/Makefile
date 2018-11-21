all: build data
build: import.report data
data: data/mqtl/mqtl.csv.gz scripts/trait_id_master.r.Rout scripts/mqtl.r.Rout scripts/communities.r.Rout scripts/trait-cpg.r.Rout scripts/cpg-trait.r.Rout scripts/2d.r.Rout

R := R CMD BATCH --vanilla

scripts/trait_id_master.r.Rout: scripts/trait_id_master.r
	cd $(<D);$(R) $(<F)

scripts/mqtl.r.Rout: scripts/mqtl.r scripts/trait_id_master.r.Rout
	cd $(<D);$(R) $(<F)

data/mqtl/mqtl.csv.gz: data/raw/assoc_meta_all.csv
	sed 1d data/raw/assoc_meta_all.csv | gzip -c > data/mqtl/mqtl.csv.gz

scripts/communities.r.Rout: scripts/communities.r scripts/mqtl.r.Rout
	cd $(<D);$(R) $(<F)

scripts/trait-cpg.r.Rout: scripts/trait-cpg.r scripts/mqtl.r.Rout
	cd $(<D);$(R) $(<F)

scripts/cpg-trait.r.Rout: scripts/cpg-trait.r scripts/mqtl.r.Rout
	cd $(<D); $(R) $(<F)

scripts/2d.r.Rout: scripts/2d.r
	cd $(<D); $(R) $(<F)

import.report scripts/build_neo4j.sh.out: scripts/build_neo4j.sh data version.txt
	cd scripts; ./build_neo4j.sh > build_neo4j.sh.out

test:
	./tests/test-db-content.sh

deploy:
	cd deploy; docker build -t godmc-neo4j .; docker-compose up -d

transfer:
	./deploy/rsync.sh

