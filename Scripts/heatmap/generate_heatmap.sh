#!/bin/bash

ml R

file=$1
sed -i "s/xxxxxxxx/$file/g" gene_recovery_heatmap.R

Rscript gene_recovery_heatmap.R

name=$(echo $file|sed 's/_lengths.txt//g')

mv Rplots.pdf ${name}_heatmap.pdf

