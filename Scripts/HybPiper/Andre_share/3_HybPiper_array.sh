#!/bin/sh
#SBATCH --job-name=HybPiper
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=cactus@ufl.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=3gb
#SBATCH --time=190:00:00
#SBATCH --output=HybP.out
#SBATCH --error=HybP.err
#SBATCH --array=1-7
echo -e "\nInfo: Starting a job on $(date) on $(hostname) in $(pwd).\n"

module load python/2.7.6 exonerate/2.2.0 bwa/0.7.15 samtools/1.3.1 spades/3.8.0 velvet/1.2.10 cap3/20120705 ncbi_blast/2.4.0 parallel/20150122

DIR="1adapt_removed"
R1FILE=$(ls ${DIR}/*_R1.fastq | head -n $SLURM_ARRAY_TASK_ID | tail -n 1)
name=$DIR/`basename ${R1FILE} _R1.fastq`
echo "Running HybPiper on ${name}"
forward="${name}_R1.fastq"
reverse="${name}_R2.fastq"

echo -e "\nRun log: python 3_Hybpiper/HybPiper/reads_first.py -r $forward $reverse -b 3_Hybpiper/allbaits.fasta --cpu 4 --bwa --prefix $name"

python 3_Hybpiper/HybPiper/reads_first.py -r ${forward} ${reverse} -b 3_Hybpiper/allbaits.fasta --cpu 2 --bwa --prefix ${name}

echo -e "\nInfo: Job finished  on $(date)"
