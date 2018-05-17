#!/bin/bash

#PBS -N db-assoc
#PBS -o assoc-output
#PBS -e assoc-error
#PBS -l walltime=12:00:00
#PBS -l nodes=1:ppn=8
#PBS -S /bin/bash
#PBS -t 501-600


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
R CMD BATCH --no-save --no-restore '--args '$i'' make_assoc_meta_table.R assoc$i.Rout
