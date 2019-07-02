#!/bin/bash
#
echo -e "\nInfo: Starting a job on $(date)\n\non $(hostname)\n\nin $(pwd).\n"

module load python/2.7.6 hybpiper/1.2 exonerate/2.2.0 bwa/0.7.15 samtools/1.3.1 spades/3.8.0 velvet/1.2.10 cap3/20120705 ncbi_blast/2.4.0 parallel/20150122

Total=$(ls paired/*_P1.fastq|wc -l)

for i in $(eval echo {1..$Total}); do

	R1FILE=$(ls paired/*_P1.fastq|sed -n ${i}p)
	
	name=$(basename ${R1FILE} _P1.fastq)
	
	echo -e "\n\nRunning HybPiper on ${name} and unpaired file is $Unpaired\n\n"
	
	forward=${R1FILE}
	reverse=$(echo ${R1FILE}|sed 's/_P1/_P2/g')
	
	echo -e "\nRun log: reads_first.py -r $forward $reverse -b /ufrc/soltis/cactus/Dimension/Target_Enrichment/data/Angiosperms353_targetSequences.fasta --cpu 2 --bwa --prefix $name"
	
	reads_first.py -r ${forward} ${reverse} -b /ufrc/soltis/cactus/Dimension/Target_Enrichment/data/Angiosperms353_targetSequences.fasta --cpu 1 --bwa --prefix ${name}

done

echo -e "\nInfo: Job finished  on $(date)"
