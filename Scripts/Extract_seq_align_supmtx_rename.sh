#!/bin/bash

group=$1

#prepare ${group}.csv before hand

Date=$(date|awk -F ' ' '{print$2$3$NF}')
ml hybpiper R
ml gcc/8.2.0 phyx/20190403

#create folder for data storage
mkdir results_pairedreads sequence_dir DNA_seq

#move all the sample run into folder "sequence_dir"
mv P*W* sequence_dir

#copy reference seq
cp /ufrc/soltis/cactus/Dimension/Target_Enrichment/data/Angiosperms353_targetSequences.fasta .

echo -e "\n\nretrieve_sequences.py is luanched...\n\n"
# retrieve seq data
retrieve_sequences.py Angiosperms353_targetSequences.fasta sequence_dir dna
#retrieve_sequences.py Angiosperms353_targetSequences.fasta sequence_dir aa

echo -e "\n\nMoving sequence data with FNA format with in to folder DNA_seq for future alignment ...\n\n"
mv ${group}.csv *.FNA DNA_seq

cd DNA_seq

cp /ufrc/soltis/cactus/Dimension/Target_Enrichment/data/Scripts/Mafft_alignment.sh .

bash Mafft_alignment.sh


echo -e "\n\nNow create a supermtrix using phyx\n\n"

cd mafft_align2
ls *.fasta >maftt_genes.txt 
pxcat -f maftt_genes.txt -p gene_partition.txt -o ${group}_supermatrix.${Date}.fasta

#remove 50% gaps and ambiguities
pxclsq -s ${group}_supermatrix.${Date}.fasta -o ${group}_supermatrix0.5.${Date}.fasta

#old name and new name to replace
grep ">" ${group}_supermatrix.${Date}.fasta|sed 's/>//g' >current_name.txt

cp current_name.txt ../current_name.txt

for i in `cat current_name.txt`; do grep -Fw $i ../${group}.csv|cut -f1 -d',' >>new_name.txt;done

pxrls -s ${group}_supermatrix.${Date}.fasta -c current_name.txt -n new_name.txt  -o ${group}_supermatrix_rename.${Date}.fasta
pxrls -s ${group}_supermatrix0.5.${Date}.fasta -c current_name.txt -n new_name.txt  -o ${group}_supermatrix0.5_rename.${Date}.fasta

cd ..
echo -e "\n\ngenerating gene sample present absent binary matrix...\n\n"
cp ../${group}seq_length.txt .
cp /ufrc/soltis/cactus/Dimension/Target_Enrichment/data/Scripts/matrix_creator.R .

Rscript matrix_creator.R

#summarize sample
cat *.FNA >matrix.tmp

echo "sample,#gene" >sample_summary.csv

for s in `cat current_name.txt`; do
	SS=$(grep -Fw $s ${group}.csv)
	gg=$(grep -c $s matrix.tmp)
	echo -e "$SS,$gg" >>sample_summary.csv
done
rm *.tmp

mkdir Seq_unaligned matrix_summ

mv *.FNA Seq_unaligned
mv *_summary.csv ${group}_gene_sample_absent_prsent_matrix.csv mafft_align2/${group}*.fasta mafft_align2/gene_partition.txt matrix_summ

echo "done!!!"
