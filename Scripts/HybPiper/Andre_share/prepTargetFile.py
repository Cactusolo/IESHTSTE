#!/usr/bin/env python

import argparse
from Bio import SeqIO
from Bio.Alphabet import IUPAC, Gapped
from Bio.Seq import Seq
import os
import re

# Remove all gaps from the sequences in a fasta file.
#
# Matt Gitzendanner
# University of Florida
# 
# version: 1.0: Initial release, June 15, 2016
#
# Usage: python remove_gaps.py -i fasta_file.fa -o fasta_file_no_gaps.fa

parser = argparse.ArgumentParser()
parser.add_argument("-i", help="Input fasta file")
parser.add_argument("-o", help="Output fasta file with gaps removed")

args = parser.parse_args()

InFile = args.i
OutFile= args.o


try:
	IN=open(InFile, 'r')
except:
	print("Can't open infile for reading: %s" %(InFile))
	
try:
	OUT=open(OutFile, 'w')
except:
	print("Can't open outfile for writing: %s" %(OutFile))
		

for Record in SeqIO.parse(IN, "fasta"):	
	Record.seq=Seq.ungap(Record.seq, gap="-")
	
	SeqIO.write(Record, OUT, "fasta")