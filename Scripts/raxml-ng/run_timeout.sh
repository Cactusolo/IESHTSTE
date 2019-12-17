#!/bin/bash

while read -r line; do
	echo $line
	genus=$(echo $line|cut -f2 -d'_')
	ls ./Genus_aln/$genus/raxml/raxml_NG_${line}.sbatch
	cd ./Genus_aln/$genus/raxml/
	#sed -i 's/=512mb/=128mb/g' raxml_NG_${line}.sbatch
	sed -i '/soltis-b/d;s/96:00:00/300:00:00/g;s/=512mb/=128mb/g' raxml_NG_${line}.sbatch
	sbatch raxml_NG_${line}.sbatch
	#pwd
	cd ../../../
done <time_out_list5
