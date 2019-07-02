#!/bin/sh
#SBATCH --job-name=Hyb_intronerate
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=aanaranjo@ufl.edu 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=2gb
#SBATCH --time=100:00:00
#SBATCH --output=logs/HybPiperintron.%j.out
#SBATCH --error=logs/HybPiperintron.%j.err
#

#Change to the directory where the job was launched from
#echo Working directory is $SLURM_SUBMIT_DIR
#cd $SLURM_SUBMIT_DIR


#load the needed modules

module load python/2.7.6 exonerate/2.2.0 bwa/0.7.15 samtools/1.3.1 spades/3.8.0 velvet/1.2.10 cap3/20120705 ncbi_blast/2.4.0 parallel/20150122

for file in HybPiperOuts/RAPiD-Genomics_F078_UFL_394804_P0*
do
	name=`basename $file`
	echo "Running HybPiper_intronerate on $file"
	python HybPiperOuts/3_Hybpiper/HybPiper/intronerate.py --prefix $file
done


