#!/bin/bash

version=`cat version.txt`


cd ../

#wget http://dist.neo4j.org/neo4j-community-${version}-unix.tar.gz
#tar xzvf neo4j-community-${version}-unix.tar.gz

#rsync -avu --progress data/ gh13047@shark.epi.bris.ac.uk:godmc-database/neo4j/data/

#rm -rf neo4j-community-${version}/data/databases/godmc.db
#rsync -avu --progress neo4j-community-${version}/ gh13047@shark.epi.bris.ac.uk:godmc-database/neo4j/neo4j-community-${version}/

rsync -avu --progress neo4j-community-${version}/ gh13047@shark.epi.bris.ac.uk:godmc-database/neo4j/import/${version}/

