#!/bin/bash
SampleID=$1
SeqTable=$2

mkdir combined raw_data

for id in `cat $SampleID`; do
	#echo $id
	seqR1=$(grep -Fw $id $SeqTable|awk -F ',' '{print $(NF-1)}')
	dd=$(grep -Fwc $id $SeqTable)
	echo $dd
	seqR2=$(echo $seqR1|uniq|sed 's/_R1_/_R2_/g')
	
	nnR1=$(echo $seqR1|cut -f5,6,8,11 -d'_'|sed 's/i7-//g'|uniq)
	nnR2=$(echo $seqR2|cut -f5,6,8,11 -d'_'|sed 's/i7-//g'|uniq)
	nn=$(echo $seqR1|cut -f5,6,8 -d'_'|sed 's/i7-//g'|uniq)
	echo "$id,$nn" >>../SampleID_SeqID.csv
	#echo -e "$seqR1\t$nnR1\t$seqR2\t$nnR2\ncombined/${nnR1}.fastq.gz\tcombined/${nnR2}.fastq.gz"
	if [ $dd -eq 2 ]
		then
			cat $seqR1 >combined/${nnR1}.fastq.gz
			cat $seqR2 >combined/${nnR2}.fastq.gz
		else
			cp $seqR1 combined/${nnR1}.fastq.gz
			cp $seqR2 combined/${nnR2}.fastq.gz
	fi
	mv $seqR1 $seqR2 raw_data
done

ls combined/*.gz|wc -l