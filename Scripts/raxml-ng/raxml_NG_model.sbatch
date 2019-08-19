#!/bin/bash
#SBATCH --job-name=wwww
#SBATCH --ntasks=xxxx #IMPORTANT: CHANGE as needed. Run raxml-ng-mpi --parse first to determine no. threads appropriate
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=gggg
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=cactus@ufl.edu
#SBATCH --account=soltis
#SBATCH --qos=soltis-b
#SBATCH -t 96:00:00
#SBATCH --output=raxml_%j.out
#SBATCH --error=raxml_%j.err
#SBATCH --partition=hpg2-compute

#moduls
module load intel/2019.1.144  openmpi/4.0.0 raxml-ng/0.9.0

raxml-ng-mpi --all --msa wwww.raxml.rba --model mmmm --tip-inner --prefix wwww --threads xxxx -seed ${RANDOM} --tree rand{25},pars{25} --bs-metric fbp,tbe

