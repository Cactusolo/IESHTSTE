#!/bin/bash
#Author: Miao Sun
# this script will go inside each gene folder, and compare the raxml input files (TriMAL/*.fasta) 
# and the output files to see if any input files faild to generate the results
# then the user need to find out whythe reason, fix it, and rerun the raxml.

genus=$1
#cd ./Genus_aln/$genus/
ls ./TrimAL/*.fasta|cut -f3 -d'/'|cut -f1 -d'.' >aln_list.tmp
ls ./raxml/*.supportTBE|cut -f3 -d'/'|cut -f1 -d'.' >tre_list.tmp
sort aln_list.tmp tre_list.tmp|uniq -u >${genus}_fail_check_list.txt
DD=$(sort aln_list.tmp tre_list.tmp|uniq -u |wc -l)
echo -e "$genus\t$DD" >>../../All_genus_fail_summary.txt
rm *.tmp

while read -r line; do
	logfile=$(grep $line raxml/*.out|tail -1|cut -f1 -d':')
	echo -e "\n****************\n$line\n****************\n" >>${genus}_check_list_dignosed_file.txt
	tail $logfile >>${genus}_check_list_dignosed_file.txt
done <${genus}_fail_check_list.txt

echo -e "\n****************\nDone!!!\n****************\n"
