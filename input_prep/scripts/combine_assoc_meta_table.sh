#!/bin/bash

head -n1 /panfs/panasas01/shared-godmc/database_files/assoc_meta1.csv > /panfs/panasas01/shared-godmc/database_files/assoc_meta_all.csv |

tail -n +2 /panfs/panasas01/shared-godmc/database_files/assoc_meta*.csv >>
 for i in {2..}



awk -F"," 'BEGIN{OFS=",";} {print $2,$1,$21,$4,$5,$15,$18,$19,$20,$3,$16,$23,$6,$7,$8,$9,$12,$22,$10,$11,$13,$14,$17;$18}' < assoc_meta_all.csv > assoc_meta_all.csv2
mv assoc_meta_all.csv2 assoc_meta_all.csv

