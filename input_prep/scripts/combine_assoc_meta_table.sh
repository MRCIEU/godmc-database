#!/bin/bash

head -n1 /panfs/panasas01/shared-godmc/database_files/assoc_meta1.csv > /projects/MRC-IEU/research/data/godmc/_devs/GODMC_Analysis/data/database-files/assoc_meta_all.csv &&

tail -n +2 -q /panfs/panasas01/shared-godmc/database_files/assoc_meta*.csv >> /projects/MRC-IEU/research/data/godmc/_devs/GODMC_Analysis/data/database-files/assoc_meta_all.csv

awk -F"," 'BEGIN{OFS=",";} {print $2,$1,$21,$4,$5,$15,$18,$19,$20,$3,$16,$23,$6,$7,$8,$9,$12,$22,$10,$11,$13,$14,$17,$18}' < /projects/MRC-IEU/research/data/godmc/_devs/GODMC_Analysis/data/database-files/assoc_meta_all.csv > /projects/MRC-IEU/research/data/godmc/_devs/GODMC_Analysis/data/database-files/assoc_meta_all.csv2
mv /projects/MRC-IEU/research/data/godmc/_devs/GODMC_Analysis/data/database-files/assoc_meta_all.csv2 /projects/MRC-IEU/research/data/godmc/_devs/GODMC_Analysis/data/database-files/assoc_meta_all.csv

cd ..
