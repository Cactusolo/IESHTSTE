#!/bin/bash

ml trimmomatic/0.36

date

if [ -e "trimmed_data" ]
then
	rm -fr trimmed_data/*
else
	mkdir trimmed_data
fi

Total=$(ls *_R1.fastq.gz|wc -l)

for i in $(eval echo {1..$Total}); do

seq1=$(ls *_R1.fastq.gz| head -n $i|tail -1)
seq2=$(echo $seq1|sed 's/_R1/_R2/g')
name=$(basename $seq1 _R1.fastq.gz)

#echo -e "$seq1\t$seq2\t$name"

trimmomatic PE -threads 4 -trimlog Trimlog.txt $seq1 $seq2 ./trimmed_data/${name}_P1.fastq.gz ./trimmed_data/${name}_U1.fastq.gz ./trimmed_data/${name}_P2.fastq.gz ./trimmed_data/${name}_U2.fastq.gz ILLUMINACLIP:/apps/trimmomatic/0.36/adapters/TruSeq3-PE.fa:2:30:10:8:TRUE SLIDINGWINDOW:20:20

done

cd trimmed_data
gunzip *.gz

mkdir unpaired paired

mv  P*_W*_P*.fastq paired
mv  P*_W*_U*.fastq unpaired

cd ..

date
echo "Done!"

# USE P1 AND P2 FOR DOWNSTREAM APPLICATIONS
