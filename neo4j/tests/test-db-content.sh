#!/bin/bash

version=`cat version.txt`

cd ../neo4j-community-${version}/bin

./neo4j start

echo "match (n:Trait) return n.name limit 25;" | ./cypher-shell -u neo4j -p 123qwe
echo "match (n) return distinct count(labels(n)), labels(n);" | ./cypher-shell -u neo4j -p 123qwe

echo "match (n1:Trait)-[r:MR]->(n2:Cpg) return count(r);" | ./cypher-shell -u neo4j -p 123qwe

./neo4j stop


