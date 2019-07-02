#!/bin/sh

module load fastqc

mkdir FastQC_result

fastqc *.gz -t 7 -o FastQC_result
