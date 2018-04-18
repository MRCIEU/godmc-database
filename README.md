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

* * *

# Running the mysql database in docker

## 1. Add data and set up local config

- Create local ```./data/``` directory and add csv files to this 
- Create ```/scripts-import/changepass.sh``` based on ```/scripts-import/changepass_template.sh```

## 2. Install docker 

[https://docs.docker.com/install/](https://docs.docker.com/install/)

## 3. Run docker-compose file to set up container

```
docker-compose up
```

## 4. Login to container

```
docker exec -it godmcdatabase_db_1 bash
```

## 5. Run importdata script within container

```
bash /scripts-import/importdata.sh
```


* * *

# Running the website in docker

## 1. Install docker 

[https://docs.docker.com/install/](https://docs.docker.com/install/)

## 2. Clone a docker image that can run php websites

```
docker pull fauria/lamp
```

## 3. Check to see if it works:

Run

```
docker run -d -p 2000:80 --name godmc_database fauria/lamp
```

and then go to http://localhost:2000 in the browser - it should show the apache default page

## 4. Now we need to load in the real website

Log into the docker container

```
docker exec -it godmc_database /bin/bash
```

Once you are in you need to clone the bitbucket repository in the correct location

```
cd /var/www/html
git clone https://bitbucket.org/paulsmith01/mqtldb.git
```

Now in your browser you should be able to go to http://localhost:2000/mqtldb and it will show the web page.

## 5. Updating

Every time the bitbucket repository is updated, login as in (4) and go to `/var/www/html/mqtldb` and run `git pull`




