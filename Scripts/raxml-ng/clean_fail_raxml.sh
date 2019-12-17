#!/bin/bash

while read -r genus; do
	echo $genus
	rm -fr ./Genus_aln/$genus/raxml
done <genera3.txt

echo -e "\n****************\nDone!!!\n****************\n"
