#!/bin/bash



cd ../

version=`cat version.txt`
#wget http://dist.neo4j.org/neo4j-community-${version}-unix.tar.gz
#tar xzvf neo4j-community-${version}-unix.tar.gz

#rsync -avu --progress data/ gh13047@shark.epi.bris.ac.uk:godmc-database/neo4j/data/

#rsync -avu --progress neo4j-community-${version}/ gh13047@shark.epi.bris.ac.uk:godmc-database/neo4j/neo4j-community-${version}/

sudo rm -rf neo4j-community-${version}
rsync -avu --progress gh13047@bc4login.acrc.bris.ac.uk:godmc/godmc-database/neo4j/neo4j-community-${version}/ neo4j-community-${version}/

