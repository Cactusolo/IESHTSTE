#!/bin/bash

#Author: Miao Sun
# this script will go inside each genus folder:
#1). copy original alignment from "UN-TrimAL" folder to "TrimAL" folder
#2). then modify "raxml_NG_check_alig_triml_issue.sbatch" script put into Genus/raxml/ folder
#3) create a job submission script for the specific gene in that genus

date

genus=$1
gene=$2

#prepare the alignment
cp ./Genus_aln/${genus}/UN-TrimAL/${gene}_${genus}.maft.fasta ./Genus_aln/${genus}/TrimAL/${gene}_${genus}.trm.fasta

#modify script

sed "s/nnnn/$genus/g;s/gggg/$gene/g" raxml_NG_check_alig_triml_issue.sbatch >./Genus_aln/${genus}/raxml/raxml_NG_check_${gene}.sbatch

cd ./Genus_aln/${genus}/raxml/

if [ -e "${gene}_${genus}.raxml.rba" ]; then
	rm ${gene}_${genus}*
fi

sbatch raxml_NG_check_${gene}.sbatch

cd ../../../
