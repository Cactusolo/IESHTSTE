#!/bin/bash

#${XXX}namelist.txt need to prepared before hand

ml hybpiper R samtools/1.2

XXX=$1


echo -e "\n\n Working on $XXX ... \n\n"
date

#get the sequence length summary
# reference file
# sequence ID name list (folder name)

echo -e "\n\n Will generate sequence length table...\n\n
Looking for a file called ${XXX}seq_length.txt ... \n\n"

get_seq_lengths.py /ufrc/soltis/cactus/Dimension/Target_Enrichment/data/Angiosperms353_targetSequences.fasta ${XXX}namelist.txt dna >${XXX}seq_length.txt 2>${XXX}_Longer_seqlen1.5x_warning.txt


echo -e "\n\n Now Working on assembling stats for each gene and each sample ... \n\n"
hybpiper_stats.py ${XXX}seq_length.txt ${XXX}namelist.txt >${XXX}_assemble_stats.txt


echo -e "\n\n Working on a heatmap ... \n\n"

cp /ufrc/soltis/cactus/Dimension/Target_Enrichment/data/Scripts/heatmap/gene_recovery_heatmap.R .

file=$(echo ${XXX}seq_length.txt)

sed -i "s/xxxxxxxx/$file/g" gene_recovery_heatmap.R

Rscript gene_recovery_heatmap.R

mv Rplots.pdf ${XXX}_heatmap.pdf

echo done!!

date
