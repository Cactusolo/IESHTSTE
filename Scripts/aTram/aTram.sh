#!/bin/bash

#Run aTRAM

module load atram/2.1.2

#mkdir temp assemblies
#
#echo -e "\nInfo: Starting a job on $(date)\n\non $(hostname)\n\nin $(pwd).\n"
#
#
for R1FILE in `ls trimmed_data/*_P1.fastq`; do

#Naming
#R1FILE=$(ls ./../reads/P001_*_P1.fastq | head -n $SLURM_ARRAY_TASK_ID | tail -n 1)
	name=$(basename ${R1FILE} _P1.fastq)
	echo  -e"Running atram on ${name}\n\n"
	#forward=${R1FILE}
	#reverse=$(echo ${R1FILE}|sed 's/_P1/_P2/g')

	#preprocessing
	#atram_preprocessor.py -b ./dataset/$name --end-1 $forward --end-2 $reverse
	
	#assembling
	for gene in ./genes/*.fasta; do
	gg=$(basename $gene .fasta)
	echo -e "\n\n*************************************\n\nNow working on $name\t$gg\n\n*************************************\n\n"
	atram.py -b ./dataset/$name -q $gene --cpus 4 --no-long-reads -o ./assemblies/atram2 --log-file ./assemblies/${name}.log -a spades -t temp
	done
done

