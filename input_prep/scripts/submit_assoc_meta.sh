#!/bin/bash

#PBS -N db-snp
#PBS -o db_snp-output
#PBS -e db_snp-error
#PBS -l walltime=12:00:00
#PBS -l nodes=1:ppn=4
#PBS -S /bin/bash
# PBS -t 1-23

echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`

set -e

if [ -n "${1}" ]; then
  echo "${1}"
  PBS_ARRAYID=${1}
fi

i=${PBS_ARRAYID}
cd /panfs/panasas01/sscm/epzjlm/repo/godmc-database/input_prep/scripts
R CMD BATCH --no-save --no-restore make_assoc_meta_table.R assoc.Rout

