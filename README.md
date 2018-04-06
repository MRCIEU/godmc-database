# godmc-database


There are 3 tables describing records - SNPs, CpGs, cohorts. There are two tables describing relationships: assoc_meta, assoc_cohort.

We can also create:

- cpg_cohort (to show the summary results for each CpG per cohort e.g. mean, sd, etc)
- snp_cohort (cohort specific allele frequencies, info scores etc)

## To do:

1. For each table write a script that will create the csv file that matches the schema
2. Upload each table to the MySQL database, probably on the docker cluster
3. Make sample queries for web developer to use

## Notes

- Missing values should be called NULL
- output as CSV, meaning if there is a field with commas then it should be in speech marks. e.g. use `write.csv` in R
- The gene information can be obtained from external sources e.g. UCSC mysql server. But we may need to bring this into our own


