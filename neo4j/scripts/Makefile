all: trait_id_master.r.Rout mqtl.r.Rout communities.r.Rout trait-cpg.r.Rout cpg-trait.r.Rout 2d.r.Rout

R := R CMD BATCH --vanilla

trait_id_master.r.Rout: trait_id_master.r
	$(R) $<

mqtl.r.Rout: mqtl.r trait_id_master.r.Rout
	$(R) $<

../data/mqtl/mqtl.csv.gz: ../data/mqtl/assoc_meta_all.csv
	sed 1d ../data/mqtl/assoc_meta_all.csv | gzip -c > ../data/mqtl/mqtl.csv.gz

communities.r.Rout: communities.r trait_id_master.r.Rout
	$(R) $<

trait-cpg.r.Rout: trait-cpg.r trait_id_master.r.Rout
	$(R) $<

cpg-trait.r.Rout: cpg-trait.r trait_id_master.r.Rout
	$(R) $<

2d.r.Rout: 2d.r trait_id_master.r.Rout
	$(R) $<

# import.report: neo4j.r organise
# 	# source build_neo4j.sh
#
#
