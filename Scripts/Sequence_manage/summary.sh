#!/bin/bash

#summarize gene
echo "Gene,#sample" >gene_summary.csv
for f in `ls *.FNA`; do
	gene=$(basename $f .FNA)
	nn=$(grep -c ">" $f)
	echo -e "g$gene,$nn" >>gene_summary.csv
done

#summarize sample
cat *.FNA >matrix.tmp

echo "sample,#gene" >sample_summary.csv
for s in `cat current_name.txt`; do
	SS=$(grep -Fw $s Evgeny13.csv)
	gg=$(grep -c $s matrix.tmp)
	echo -e "$SS,$gg" >>sample_summary.csv
done
rm *.tmp