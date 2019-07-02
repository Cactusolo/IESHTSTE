#!/bin/sh
#SBATCH --job-name=fastQC
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cactus@ufl.edu
#SBATCH -o fastqc-%j.log
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --mem-per-cpu=4gb
#SBATCH -t 24:00:00
##SBATCH --array=1-284
#SBATCH --qos=soltis-b

#mkdir FastQC_result

module load fastqc


fastqc *.gz -t 7 -o FastQC_result
