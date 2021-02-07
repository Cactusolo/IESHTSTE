#!/bin/bash
#SBATCH --job-name=Piecharts
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=cactusresponsible@gmail.com
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=1gb
#SBATCH --account=soltis
#SBATCH -t 30:00:00
#SBATCH --output=Piecharts_%A-%a.log
#SBATCH --error=Piecharts_%A-%a.err
#SBATCH --array=1-32%10

module load R newickutils gcc/8.2.0 phyx/20190403 ete3 java/14

genus=$(sed -n ${SLURM_ARRAY_TASK_ID}p genera.txt)

echo -e "\n\n Working on $genus\n\n"
cd ./Genus_aln/${genus}/ASTRAL
mkdir -p phyparts10 phyparts50
NN=$(ls ./genetree_reroot/*.tre|wc -l)
echo -e "\n\n Step I: Running phyparts ...\n\n"

# option `-s 50` increase the cout off value for phyparts to summarize
sed -i 's/ $//g' ${genus}_BS*_species.tre ./gene_trees/*.tre ./genetree_reroot/*.tre

java -jar ~/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d genetree_reroot -m ${genus}_BS10_species.tre -o ./phyparts10/phyparts10

java -jar ~/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -s 50 -v -d genetree_reroot -m ${genus}_BS10_species.tre -o ./phyparts50/phyparts50

echo -e "\n\n Step II: Running phypartspiecharts ...\n\n"

display=$(shuf -i 100-200 -n 1)
export DISPLAY=:${display}
Xvfb :${display} -screen 0 1024x768x16 > /dev/null 2>&1 &
echo "export DISPLAY=:${display}" > ~/.xvfb

python3 ~/phypartspiecharts.py ${genus}_BS10_species.tre ./phyparts10/phyparts10 $NN --svg_name ${genus}_BS10_phypartspiecharts10.svg --to_csv
mv phyparts_dist.csv phyparts_dist_BS10.csv
mv phyparts_pies.csv phyparts_pies_BS10.csv

python3 ~/phypartspiecharts.py ${genus}_BS10_species.tre ./phyparts50/phyparts50 $NN --svg_name ${genus}_BS10_phypartspiecharts50.svg --to_csv
mv phyparts_dist.csv phyparts_dist_BS50.csv
mv phyparts_pies.csv phyparts_pies_BS50.csv

echo -e "\n****************\nDone!!!\n****************\n"
