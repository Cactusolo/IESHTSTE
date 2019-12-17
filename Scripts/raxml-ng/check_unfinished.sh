#!/bin/bash
genus=$1

mkdir -p temp
ls ./${genus}/TrimAL/*.fasta|cut -f4 -d'/'|cut -f1 -d'_' >./temp/${genus}_alig_gene.txt
ls ./${genus}/raxml/*.raxml.rba.raxml.bestTree|cut -f4 -d'/'|cut -f1 -d'_' >./temp/${genus}_raxml_gene.txt

sort ./temp/${genus}_alig_gene.txt ./temp/${genus}_raxml_gene.txt|uniq -u >./temp/${genus}_un_finished.txt

cat ./temp/${genus}_un_finished.txt
