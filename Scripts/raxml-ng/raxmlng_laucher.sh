#!/bin/bash
#Author: Miao Sun
# this script will go inside each genus folder:
#1). create a folder called "raxml" for raxml analyses
#2). create a job submission script for each genus and gene
#3) using trimmed and aligned sequences in "TrimAL" folder

date

#genus=$1

while read -r genus; do
	echo -e "\n\n$genus\n\n"
	cd ./Genus_aln/${genus}/
	mkdir -p raxml
	cd raxml
	cp /ufrc/soltis/cactus/Dimension/Target_Enrichment/gene/Script/raxml_NG_check.sbatch .
	# how many genes assembled for this genus
	ss=$(ls ../TrimAL/*.fasta|wc -l)
	sed -i "s/XXXX/$ss/g;s/tttt/$genus/g" raxml_NG_check.sbatch
	sbatch raxml_NG_check.sbatch
	cd ../../../
done <genera.txt

echo -e "\n****************\nDone!!!\n****************\n"

date