#!/bin/bash

module load mafft

mkdir gene_failed mafft_align2
#make a summary table
echo "Gene,#sample" >gene_summary.csv

for file in `ls *.FNA`; do
	nn=$(grep -c ">" $file)
	name=$(basename $file .FNA)
	echo -e "g$name,$nn" >>gene_summary.csv
	#this value can be changed
	#but here we use 2, since at least 2 seqs can make a alignment
	# those genes failed or only have one sample moved to "gene_failed" folder
	if [ $nn -ge 2 ]; then
		mafft-linsi --thread 2 --op 3 --ep 0.123 $file >mafft_align2/g${name}.mft.fasta
	else
		mv $file gene_failed
	fi
done

echo -e "\n\n Mafft job is done!\n\n"