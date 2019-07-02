#!/bin/bash
#SBATCH --job-name=trimmomatic.%j
#SBATCH --mail-user=cactus@ufl.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=2gb
#SBATCH --qos=soltis-b
#SBATCH -t 72:00:00
#SBATCH --output=trimmomatic.%j.out
#SBATCH --error=trimmomatic.%j.err
#SBATCH --array=1-142 #Number of samples, on run per sample; to rerun you can do 14,17, 30-35, etc.


ml trimmomatic/0.36

date

if [ -e "trimmed_data" ]
then
	rm -fr trimmed_data/*
else
	mkdir trimmed_data
fi

seq1=$(ls *_R1.fastq.gz| head -n $SLURM_ARRAY_TASK_ID|tail -1)
seq2=$(echo $seq1|sed 's/_R1/_R2/g')
name=$(basename $seq1 _R1.fastq.gz)
trimmomatic PE -threads 4 -trimlog Trimlog.txt $seq1 $seq2 ./trimmed_data/${name}_P1.fastq.gz ./trimmed_data/${name}_U1.fastq.gz ./trimmed_data/${name}_P2.fastq.gz ./trimmed_data/${name}_U2.fastq.gz ILLUMINACLIP:/apps/trimmomatic/0.36/adapters/TruSeq3-PE.fa:2:30:10:8:TRUE SLIDINGWINDOW:20:20

date
# USE P1 AND P2 FOR DOWNSTREAM APPLICATIONS