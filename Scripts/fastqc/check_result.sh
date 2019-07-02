#!/bin/bash
#this script will check 
ml R

mkdir html zip_folder unzip_file
#
for i in `ls *.zip`; do 
	unzip $i -d unzip_file
	mv $i zip_folder
done

echo "Seq_ID,Seq_len,Total_reads,QC45_mean,T_Deduplicated%" >Illumina_FastQC_report.csv
for i in `ls zip_folder/*.zip`; do 
	seq=$(basename $i .zip)
	#mv $i zip_folder
	#capture values
	file="./unzip_file/${seq}/fastqc_data.txt"
	Len=$(grep -w "length" $file|awk -F ' ' '{print $NF}')
	Deduplicated=$(grep -w "Deduplicated" $file|awk -F ' ' '{print $NF}'|python -c "print round(float(raw_input()),2)")
	T_reads=$(grep -w "Total Sequences" $file|awk -F ' ' '{print $NF}')
	#capture last 10 row of mean value from "Per base sequence quality	pass" table
	head -n 51 $file|tail -10|cut -f2 >Last_45_base.tmp
	QC_mean=$( Rscript mean.R|cut -f2 -d' ')
	echo -e "$seq,$Len,$T_reads,$QC_mean,$Deduplicated" >>Illumina_FastQC_report.csv
	rm *.tmp
done
mv *.html html
