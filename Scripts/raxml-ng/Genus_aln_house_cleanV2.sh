#!/bin/bash
#Author: Miao Sun
# this script will go inside each genus folder:
#1). mv any gene alignment with less than 3 seqs into a newly created folder "Not_Analyze"
#2). the suvivors from step 1 will go through trimal treatment with -automated1 option and put into "trimal" folder, and original goes to "untrimal" folder.
#3). generate sumamry table for each gene alignment, including how many sequences, and which species, and which species has more than one seqs.

date

ml trimal/1.2

echo -e "Genus\talignment_count\tsequence_count" >Genus_alignment_summary.table

while read -r genus; do
	echo -e "\n\n$genus\n\n"
	cd ./Genus_aln/${genus}/
	mkdir -p Not_Analyzed TrimAL UN-TrimAL Raw_cmb
	
	#generate a summary table
	for file in `ls *.fasta`; do
		AA=$(grep -c ">" $file) #sequences in each gene alignment
		echo -e "\n\n$file\t$AA\n" >>${genus}_sequence_summary.table
		grep ">"  $file|sed 's/>//g'|sort|uniq -c|tr -s \ |sed 's/^ //g' >>${genus}_sequence_summary.table
		mv $file Raw_cmb
		done
	#orgnized file in alignment and do trimal
	for aln in `ls Alignment/*.fasta`; do
		dd=$(grep -c ">" $aln)
		if [[ $dd -gt 3 ]]; then #the phylogeny should at least has 4 tips
			name=$(basename $aln .maft.fasta)
			trimal -in $aln -fasta -out TrimAL/${name}.trm.fasta -automated1
			mv $aln UN-TrimAL
		else
			mv $aln Not_Analyzed
		fi
	done
	rmdir Alignment
	#summary for trimal aln before raxml
	cd ./TrimAL
	sed -i 's/ [0-9]* bp//g' *.trm.fasta
	#cheching how many alignments for each genus
	aa=$(ls *.fasta|wc -l)
	cc=$(cat *.fasta|grep -c ">")
	echo -e "$genus\t$aa\t$cc\n" >>../../../Genus_alignment_summary.table
	for aln in `ls *.fasta`; do
		dd=$(grep -c ">" $aln)
		fragment=$(basename $aln .trm.fasta|sed 's/_/\t/g')
		echo -e "$fragment\t$dd" >>../../../Genus_alignment_summary.table
	done
	cd ../../../
done <genera.txt

echo -e "\n****************\nDone!!!\n****************\n"

date