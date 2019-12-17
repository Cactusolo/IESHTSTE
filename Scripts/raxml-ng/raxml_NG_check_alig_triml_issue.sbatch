#!/bin/bash
#SBATCH --job-name=gggg_nnnn
#SBATCH --ntasks=1 #IMPORTANT: CHANGE as needed. Run raxml-ng-mpi --parse first to determine no. threads appropriate
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=FAIL,END
#SBATCH --mem-per-cpu=512mb
#SBATCH --mail-user=cactus@ufl.edu
#SBATCH --account=soltis
#SBATCH --qos=soltis-b
#SBATCH -t 96:00:00
#SBATCH --output=nnnn_%j.out
#SBATCH --error=nnnn_%j.err
##SBATCH --array=1-343%10 #Number input msa
#SBATCH --partition=hpg2-compute #you have to specify to run raxml-ng on hpg2---chips

date
#moduls
module load intel/2019.1.144  openmpi/4.0.0 raxml-ng/0.9.0

#call each alignment
ALIGNMENT=$(ls ../TrimAL/*.fasta|grep "gggg")

#prefix for raxml
Title=$(basename $ALIGNMENT .trm.fasta)
echo $Title
#Run raxml-ng checking

raxml-ng-mpi --parse --msa $ALIGNMENT --model GTR+G --prefix $Title --threads 1

#getting specific model and threds memerical configuration
TT=$(grep "MPI processes" ${Title}.raxml.log|cut -f2 -d':'|sed 's/ //g')
Mem=$(grep "memory requirements" ${Title}.raxml.log|cut -f2 -d':'|sed 's/ //g;s/./\L&/g')

mv ${Title}.raxml.log ${Title}.raxml.check.log

if [[ $TT -eq 1 ]]; then
	raxml-ng-mpi --all --msa ${Title}.raxml.rba --tip-inner --prefix ${Title} --threads 1 -seed ${RANDOM} --tree rand{25},pars{25} --bs-metric fbp,tbe
elif [[ $TT -gt 1 ]]; then
	cp /ufrc/soltis/cactus/Dimension/Target_Enrichment/gene/Script/raxml_NG_model.sbatch ./raxml_NG_${Title}.sbatch
	sed -i "s/wwww/$Title/g;s/xxxx/$TT/g" raxml_NG_${Title}.sbatch
	sbatch raxml_NG_${Title}.sbatch
else
	echo -e "$Title\t$Model\t$TT\t$Mem" >>../../../failed_raxml_seq_log.txt
fi

date