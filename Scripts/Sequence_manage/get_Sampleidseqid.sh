#!/bin/bash
group=$1
file="UFL_394803_SampleSheet_${group}.csv"
for i in `sed '1d' $file| cat`; do
	Samid=$(echo $i|cut -f2 -d',')
	Seqid=$(echo $i|cut -f5 -d','|cut -f5,6,8 -d'_'|sed 's/i7-//g')
	echo "$Samid,$Seqid" >>${group}.tmp
	echo "$Seqid" >>${group}namelist.tmp
done
sort ${group}.tmp|uniq >${group}.csv
sort ${group}namelist.tmp|uniq >${group}namelist.txt
rm *.tmp
