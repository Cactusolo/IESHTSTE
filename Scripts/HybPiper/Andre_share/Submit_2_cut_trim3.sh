#!/bin/bash
#SBATCH --job-name=trim_filter
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=aanaranjo@ufl.edu
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=4gb
#SBATCH --time=24:00:00
#SBATCH -o trim_filter_%j.out
#SBATCH -e trim_filter.%j.err

pwd; hostname; date

module load repeatmasker

# Script written by Matt Gitzendanner (magitz@ufl.edu)
# Before running the script, need to creat new folders titled adapt_removed and trimmed_filtered
#Control where to start the process (1 is beginning):
start_step=1

#Change to the directory where the job was launched from
#echo Working directory is $SLURM_SUBMIT_DIR
#cd $SLURM_SUBMIT_DIR

#Use modules to load the needed modules

module load cutadapt
module load sickle
module load fastx_toolkit
module load python

#Run cutadapt; before running change the folder location to where the raw reads are
if [[ $start_step -le 1 ]]
then
	for file in *.fastq
	do
		echo "Running cutadapt on $file"
		name=`basename $file .fastq`
		cutadapt -b TACACTCTTTCCCTACACGACGCTCTTCCGATCT -b GTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT $file > adapt_removed/$name.fastq
	done
fi
#run sickle
if [[ $start_step -le 2 ]]
then
	for file in adapt_removed/*_R1.fastq
	do
		name=`basename $file _R1.fastq`
		echo "Running sickle on $name"
		forward=$name"_R1.fastq"
		reverse=$name"_R2.fastq"
		single=$name"_singletons.fastq"
		sickle pe -f adapt_removed/$forward -r adapt_removed/$reverse -t sanger -o trim_filt/$forward -p trim_filt/$reverse -s trim_filt/$single
	done
fi



