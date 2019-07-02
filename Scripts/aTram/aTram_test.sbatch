#!/bin/bash
#SBATCH --job-name=atram.%j
#SBATCH --mail-user=cactus@ufl.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8 
#SBATCH --mem=2gb
#SBATCH --qos=soltis-b
#SBATCH -t 1:00:00
#SBATCH --output=atram.%j.out
#SBATCH --error=atram.%j.err
#SBATCH --array=1,2

echo This is task $SLURM_ARRAY_TASK_ID

echo -e "\nInfo: Starting a job on $(date) on $(hostname) in $(pwd).\n"

#Naming
R1FILE=$(ls trimmed_data/*_P1.fastq | head -n $SLURM_ARRAY_TASK_ID | tail -n 1)
name=$(basename ${R1FILE} _P1.fastq)
echo "Running atram on ${name}"
forward=${R1FILE}
reverse=$(echo ${R1FILE}|sed 's/_P1/_P2/g')

#Run aTRAM
module load atram

#preprocessing
atram_preprocessor.py -b ./dataset/$name --end-1 $forward --end-2 $reverse

#assembling
mkdir temp assemblies
for gene in ./genes/*.fasta; do
	echo -e "\n\n*************************************\n\nNow working on $name\t$gg\n\n*************************************\n\n"
	atram.py -b ./dataset/$name -q $gene -i 5 --cpus 8 --no-long-reads -o ./assemblies/atram2 --log-file ./assemblies/${name}.log -a spades -t temp
done
