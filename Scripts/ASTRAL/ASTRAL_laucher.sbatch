#!/bin/bash
#SBATCH --job-name=DASTRAL
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=cactusresponsible@gmail.com
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=1gb
#SBATCH --account=soltis
#SBATCH -t 30:00:00
#SBATCH --output=D-ASTRAL_%A-%a.log
#SBATCH --error=D-ASTRAL_%A-%a.err
#SBATCH --array=1-32%10

module load R newickutils gcc/8.2.0 phyx/20190403 astral/5.6.2

genus=$(sed -n ${SLURM_ARRAY_TASK_ID}p genera.txt)

# bash ASTRAL_laucher_test.sh $genus

echo -e "\n\n Working on $genus\n\n"
cd ./Genus_aln/${genus}/
mkdir -p ASTRAL && cd ASTRAL
mkdir -p gene_trees genetree_reroot
cp ../../../reroot_genetree_phyx_mad.R .
### copy and rename
for i in `ls ../raxml/*.supportFBP`; do
	newname=$(basename $i .raxml.rba.raxml.supportFBP)
	#copy and rename
	cp  $i ./gene_trees/${newname}.tre
	#### reroot gene trees
	Rscript reroot_genetree_phyx_mad.R $newname
	if [ -e phyx_reroot.sh ]; then
		bash phyx_reroot.sh
	fi
done

### Estimate species tree

#collaps <10% BS support
cat ./genetree_reroot/*.tre|nw_ed - 'i & b<=10' o >${genus}_genetrees_BS10.rt.tre
astral -i ${genus}_genetrees_BS10.rt.tre -o ${genus}_BS10_species.tre 2> ${genus}_BS10_species.log

#collaps <75% BS support
cat ./genetree_reroot/*.tre|nw_ed - 'i & b<=75' o >${genus}_genetrees_BS75.rt.tre
astral -i ${genus}_genetrees_BS75.rt.tre -o ${genus}_BS75_species.tre 2> ${genus}_BS75_species.log

echo -e "\n****************\nDone!!!\n****************\n"
