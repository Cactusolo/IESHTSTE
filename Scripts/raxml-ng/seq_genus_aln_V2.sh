#!/bin/bash
#author: Miao Sun
# this script will parse equences from one of 353 genes based on each genus
# then distribute alignment of each gene under each genus folder 
# then serve for the phylogeny for each gene for each genus
# using mafft to aligment; if the some sequences is reverse direction, then 
# automatically reverse-complemented it
date
module load gcc/5.2.0 mafft/7.407
if [ ! -e "seq_combined" ]; then
	mkdir seq_combined
fi
 
echo "Gene,sequences#" >gene_summary.txt

while read -r gene; do
	echo -e "\n\n$gene\n\n"
	cat ../${gene}_*.fasta >seq_combined/${gene}.fasta
	TT=$( grep -c ">" seq_combined/${gene}.fasta)
	echo -e "$gene,$TT" >>gene_summary.txt
	for genus in `cat genera.txt`; do
		echo $genus
		grep -EA 1 *${genus}_* seq_combined/${gene}.fasta >./Genus_aln/${genus}/${gene}_${genus}.fasta
		NN=$(wc -l ./Genus_aln/${genus}/${gene}_${genus}.fasta|cut -f1 -d' ')
		if [[ $NN -gt 0 ]]; then
			sed "/$genus/d" ./Genus_aln/${genus}/${genus}.txt >./Genus_aln/${genus}/${genus}_ed.txt
			#summarize each genus count
			grep -f ./Genus_aln/${genus}/${genus}_ed.txt seq_combined/${gene}.fasta|cut -f1 -d'_'|sort|uniq -c|sort -nr|sed 's/ //g' >tmp_var.txt
			aa=$(cut -f1 -d'>' tmp_var.txt|head -1) #calculate count for each genus
			echo "$aa"
			if [[ $aa -le 2 ]]; then
				grep -EA 1 -f ./Genus_aln/${genus}/${genus}_ed.txt seq_combined/${gene}.fasta >>./Genus_aln/${genus}/${gene}_${genus}.fasta
			else
				bb=$(cut -f2 -d'>' tmp_var.txt|head -1) #which genus has more than 2 entries
				cc=$(grep $bb seq_combined/${gene}.fasta|head -1|sed 's/>//g') #get first species name
				sed -i "s/$bb/$cc/g" ./Genus_aln/${genus}/${genus}_ed.txt #update it into the query list
				grep -EA 1 -f ./Genus_aln/${genus}/${genus}_ed.txt seq_combined/${gene}.fasta >>./Genus_aln/${genus}/${gene}_${genus}.fasta
			fi
			mafft-linsi --adjustdirectionaccurately --thread 2 --op 3 --ep 0.123 ./Genus_aln/${genus}/${gene}_${genus}.fasta >./Genus_aln/${genus}/${gene}_${genus}.maft.fasta
			if [ -e "./Genus_aln/${genus}/Alignment" ]; then
				mv ./Genus_aln/${genus}/${gene}_${genus}.maft.fasta ./Genus_aln/${genus}/Alignment
			else
				mkdir ./Genus_aln/${genus}/Alignment
				mv ./Genus_aln/${genus}/${gene}_${genus}.maft.fasta ./Genus_aln/${genus}/Alignment
			fi
		else #skip no sequence gene file
			continue
		fi
	done
done <353_gene_num.txt

echo "Done!!!"

date
exit 0