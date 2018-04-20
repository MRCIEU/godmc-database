#!/bin/bash
mysql -u root -p"qnwNQ6wBW" godmc < /scripts-import/schema.sql
mysql -u root -p"qnwNQ6wBW" godmc  -e "LOAD DATA LOCAL INFILE '/data-import/assoc_meta_all.csv' IGNORE INTO TABLE assoc_meta FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES"
mysql -u root -p"qnwNQ6wBW" godmc  -e "LOAD DATA LOCAL INFILE '/data-import/cohort.csv' IGNORE INTO TABLE cohort FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES"
mysql -u root -p"qnwNQ6wBW" godmc  -e "LOAD DATA LOCAL INFILE '/data-import/cpgs.csv' IGNORE INTO TABLE cpg FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES"
mysql -u root -p"qnwNQ6wBW" godmc  -e "LOAD DATA LOCAL INFILE '/data-import/genes.csv' IGNORE INTO TABLE gene FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES"
mysql -u root -p"qnwNQ6wBW" godmc  -e "LOAD DATA LOCAL INFILE '/data-import/snps.csv' IGNORE INTO TABLE snp FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES"

/bin/bash /scripts-import/changepass.sh