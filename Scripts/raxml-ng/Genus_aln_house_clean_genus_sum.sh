#!/bin/bash
#Author: Miao Sun
# this script will go inside each genus folder:
#1). to investigate how many gene alignment involved into phylogeny recontruction in the final stage and which are they
echo -e "Genus\talignment_count\tsequence_count" >Genus_alignment_summary.table
while read -r genus; do
	echo -e "\n\n$genus\n\n"
	cd ./Genus_aln/${genus}/TrimAL
	#cheching how many alignments for each genus
	aa=$(ls *.fasta|wc -l)
	cc=$(cat *.fasta|grep -c ">")
	echo -e "$genus\t$aa\t$cc" >>../../../Genus_alignment_summary.table
	for aln in `ls *.fasta`; do
		dd=$(grep -c ">" $aln)
		fragment=$(basename $aln .trm.fasta|sed 's/_/\t/g')
		echo -e "$fragment\t$dd" >>../../../Genus_alignment_summary.table
	done
	cd ../../..
done <genera.txt

echo -e "\n****************\n     Done!!!\n****************\n"

date