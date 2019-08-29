#!/bin/bash

file=$1

ml hybpiper

while IFS= read -r name; do
	cleanup.py $name
done < "$file"
	
