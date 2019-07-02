#!/bin/sh
#SBATCH --job-name=maf_nr
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=3gb
#SBATCH --time=1:00:00
#SBATCH --qos=soltis-b
#SBATCH --output=logs/mafft_nr.%j.out
#SBATCH --error=logs/mafft_nr.%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=aanaranjo@ufl.edu


# MAFFT is compiled to run on multiple cores, use the --thread <cores> option to specify the number of cores to use. 
# Make sure that this number corresponds to the resources requested in your #PBS -l nodes=1:ppn=<cores> statement.

# This job's working directory
#echo Working directory is $PBS_O_WORKDIR
#cd $PBS_O_WORKDIR

#NCPUS=`wc -l < $PBS_NODEFILE`

start_step=1

module load mafft/7.215

if [[ $start_step -le 1 ]]
then
	for file in forgotten/*.FNA
	do
		name=`basename $file .FNA`
		seq=$name".FNA"
		echo "Doing mafft alignent on $seq"
		mafft --thread -4 --op 3 --ep 0.123 --auto forgotten/$seq > forgotten_aligned/$name.FNA

	done
fi


# Automatically chooses algorithm based on number of taxa, it may not choose an iterative algorithm is the data set is more then 200 sequences
#mafft --thread $NCPUS 6_Plastomes/Plastomes.fasta > Plastomes_aligned.fasta

#G-INS-i assumes entire region can be aligned
#ginsi --thread $NCPUS infile > outfile 

#L-INS-i can align a set of sequences containing sequences flanking around one alignable domain
#linsi --thread $NCPUS infile > outfile

#E-INS-i can align a set of sequences containing mutiple alignable domain with flaking unalignable regions also has the less assumptions and should be used when it is unknow
#linsi --thread $NCPUS infile > outfile

# another cool option is to adjust direction automatically with --adjustdirection and it can be used with ginsi,einsi, linsi as well
#mafft --adjustdirection input > output

#for more options see http://mafft.cbrc.jp/alignment/software/algorithms/algorithms.html