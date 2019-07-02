#!/bin/bash
#SBATCH --job-name=HybPiper
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cactus@ufl.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem-per-cpu=1gb
#SBATCH --time=96:00:00
#SBATCH --qos=soltis-b
#SBATCH --output=HybP_%A_%a.out
#SBATCH --error=HybP_%A_%a.error
#SBATCH --array=1-150

echo -e "\nInfo: Starting a job on $(date)\n\non $(hostname)\n\nin $(pwd).\n"

module load python/2.7.6 hybpiper/1.2 exonerate/2.2.0 bwa/0.7.15 samtools/1.3.1 spades/3.8.0 velvet/1.2.10 cap3/20120705 ncbi_blast/2.4.0 parallel/20150122



R1FILE=$(ls paired/*_P1.fastq|sed -n ${SLURM_ARRAY_TASK_ID}p)

name=$(basename ${R1FILE} _P1.fastq)
#Unpaired=$(echo ${R1FILE}|sed 's/paired/unpaired/g;s/_P1/_U1/g')

echo -e "\n\nRunning HybPiper on ${name}\n\n"

forward=${R1FILE}

reverse=$(echo ${R1FILE}|sed 's/_P1/_P2/g')

echo -e "\nRun log: reads_first.py -r $forward $reverse -b  /ufrc/soltis/cactus/Dimension/Target_Enrichment/data/Angiosperms353_targetSequences.fasta --cpu 2 --bwa --prefix $name"

reads_first.py -r ${forward} ${reverse} -b ../../../Angiosperms353_targetSequences.fasta --cpu 6 --bwa --prefix ${name}

# --unpaired ${Unpaired}

echo -e "\nInfo: Job finished on $(date)"
