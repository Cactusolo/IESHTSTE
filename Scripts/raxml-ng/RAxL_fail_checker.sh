#!/bin/bash
#Author: Miao Sun
# this script will go inside each gene folder, and compare the raxml input files (TriMAL/*.fasta) 
# and the output files to see if any input files faild to generate the results
# then the user need to find out whythe reason, fix it, and rerun the raxml.

while read -r genus; do
	cd ./Genus_aln/$genus/
	ls ./TrimAL/*.fasta|cut -f3 -d'/'|cut -f1 -d'.' >aln_list.tmp
	ls ./raxml/*.supportTBE|cut -f3 -d'/'|cut -f1 -d'.' >tre_list.tmp
	sort aln_list.tmp tre_list.tmp|uniq -u >${genus}_fail_check_list.txt
	DD=$(sort aln_list.tmp tre_list.tmp|uniq -u |wc -l)
	echo -e "$genus\t$DD" >>../../CZD_genus_fail_summary.txt
	rm *.tmp
	cd ../../
done <genera_ZD.txt

echo -e "\n****************\nDone!!!\n****************\n"
