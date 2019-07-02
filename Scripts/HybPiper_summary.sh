#!/bin/bash

#${group}namelist.txt need to prepared before hand

ml hybpiper R samtools/1.2

group=$1


echo -e "\n\n Working on $group ... \n\n"
date

#get the sequence length summary
# reference file
# sequence ID name list (folder name)

echo -e "\n\n Will generate sequence length table...\n\n
Looking for a file called ${group}seq_length.txt ... \n\n"

get_seq_lengths.py /ufrc/soltis/cactus/Dimension/Target_Enrichment/data/Angiosperms353_targetSequences.fasta ${group}namelist.txt dna >${group}seq_length.txt 2>${group}_Longer_seqlen1.5x_warning.txt


echo -e "\n\n Now Working on assembling stats for each gene and each sample ... \n\n"
hybpiper_stats.py ${group}seq_length.txt ${group}namelist.txt >${group}_assemble_stats.txt


echo -e "\n\n Working on a heatmap ... \n\n"

cp /ufrc/soltis/cactus/Dimension/Target_Enrichment/data/Scripts/heatmap/gene_recovery_heatmap.R .

file=$(echo ${group}seq_length.txt)

sed -i "s/xxxxxxxx/$file/g" gene_recovery_heatmap.R

Rscript gene_recovery_heatmap.R

mv Rplots.pdf ${group}_heatmap.pdf

echo done!!

date
