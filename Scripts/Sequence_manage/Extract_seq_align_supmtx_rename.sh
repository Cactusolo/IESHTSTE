#!/bin/bash

XXX=$1

#prepare ${XXX}.csv before hand

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
mv ${XXX}.csv *.FNA DNA_seq

cd DNA_seq

cp /ufrc/soltis/cactus/Dimension/Target_Enrichment/data/Scripts/Mafft_alignment.sh .

bash Mafft_alignment.sh


echo -e "\n\nNow create a supermtrix using phyx\n\n"

cd mafft_align2
ls *.fasta >maftt_genes.txt 

#If you don't want to make a combined matrix, 
# you should comment out scipts bewteen "####" block

#################################################################
pxcat -f maftt_genes.txt -p gene_partition.txt -o ${XXX}_supermatrix.${Date}.fasta

#remove 50% gaps and ambiguities
pxclsq -s ${XXX}_supermatrix.${Date}.fasta -o ${XXX}_supermatrix0.5.${Date}.fasta

#old name and new name to replace
grep ">" ${XXX}_supermatrix.${Date}.fasta|sed 's/>//g' >current_name.txt

cp current_name.txt ../current_name.txt

for i in `cat current_name.txt`; do grep -Fw $i ../${XXX}.csv|cut -f1 -d',' >>new_name.txt;done

pxrls -s ${XXX}_supermatrix.${Date}.fasta -c current_name.txt -n new_name.txt  -o ${XXX}_supermatrix_rename.${Date}.fasta
pxrls -s ${XXX}_supermatrix0.5.${Date}.fasta -c current_name.txt -n new_name.txt  -o ${XXX}_supermatrix0.5_rename.${Date}.fasta
#################################################################

cd ..
echo -e "\n\ngenerating gene sample present absent binary matrix...\n\n"
cp ../${XXX}seq_length.txt .

#modify the path for the Rscript as needed
cp ../Scripts/matrix_creator.R .

Rscript matrix_creator.R

#summarize sample
cat *.FNA >matrix.tmp

echo "sample,#gene" >sample_summary.csv

for s in `cat current_name.txt`; do
	SS=$(grep -Fw $s ${XXX}.csv)
	gg=$(grep -c $s matrix.tmp)
	echo -e "$SS,$gg" >>sample_summary.csv
done
rm *.tmp

mkdir Seq_unaligned matrix_summ

mv *.FNA Seq_unaligned
mv *_summary.csv ${XXX}_gene_sample_absent_prsent_matrix.csv mafft_align2/${XXX}*.fasta mafft_align2/gene_partition.txt matrix_summ

echo "done!!!"
