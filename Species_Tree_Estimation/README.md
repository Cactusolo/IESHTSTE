---
output:
  word_document: default
  html_document: default
  pdf_document: default
---
### General Information for Analysis Pipeline and Date Structure

**Dr. Miao Sun**  
_Post-Doc Associate_  
_Plant Evolution and Biodiversity (PEB) Group_  
_Department of Biology - Ecoinformatics and Biodiversity_  
_Aarhus University, Denmark_  

_Email: miaosun@bios.au.dk_  


The information list here is about the data folder structure and how each of steps of analyses conducted and what scripts are used.  

#### File structure  
**Acer**  
├── **ASTRAL** # see _Note_ below  
│  ├── **genetree_reroot** # gene trees rerooted either by `phyx` or MAD (see [here](https://www.sunmiao.name/post/check-the-performance-of-a-rooting-method-using-minimal-ancestor-deviation-mad/))  
│  ├── **gene_trees** # gene trees from RAxML-NG  
│  ├── **phyparts10** # phypart analyses with defaults setting (BS10% collaps)  
│  └── **phyparts50** # same data phypart `-s 50` (phyparts BS50% collaps)  
├── **Not_Analyzed** # alignments that only has <3 samples, not able to build trees  
├── **Raw_cmb** # see _Note_ below  
├── **raxml** # all the RAxML Slurm Jobs scripts and results  
├── **TrimAL** # the MAFFT alignmets with gaps further trimmed by TrimAL  
└── **UN-TrimAL** # self explanatory  

_Note:_  
+ **ASTRAL**  
Some important files under `ASTRAL` directory  

		# Species Tree
		`genus`_BS10_species.tre  
		`genus`_BS75_species.tre # strict---collaps at 75% BS  
		
		# concatenated all rerooted gene trees
		`genus`_genetrees_BS10.rt.tre  
		`genus`_genetrees_BS75.rt.tre # strict---collaps at 75% BS  
		
		# phypartspiecharts only using `genus`_BS10_species.tre tree
		`genus`_BS10_phypartspiecharts10.svg  
		`genus`_BS10_phypartspiecharts50.svg # strict---collaps at 50% BS by phyparts  
		
	_Note:_ The tree file is in newick formate, it can be viewed by most phylogentic tree view software: [Figtree](http://tree.bio.ed.ac.uk/software/figtree/), [MEGA](https://www.megasoftware.net/), [Dendroscope3](https://github.com/husonlab/dendroscope3), [IcyTree](https://icytree.org/), etc.  
	"phypartspiecharts" in `svg` format is a vector file, can be viewed  by Adobe Illustrator, [Inkscape](https://inkscape.org/release/inkscape-1.0.2/), [Gapplin](http://gapplin.wolfrosch.com/), ect. (or saved as `pdf`)  
	
		
+ **Raw_cmb**  
	- Using `seq_genus_aln_V2.sh` to combine all seqeunce from different research group (e.g, Jenny, ZD, etc), but the same gene into one file  
	- For each gene fasta file, this script will parse sequences from one of 353 genes based on each genus  
	- then distribute alignment of each gene under each genus folder  
	- Using mafft to aligment; if the some sequences is reverse direction, then automatically reverse-complemented it  
	- See `genus`_sequence_summary.table file for summary  

#### Analyses steps
+ **For data assembly and RAxML-NG analyses (see [here](https://github.com/Cactusolo/IESHTSTE))** 
	- [Progress schedule list](https://docs.google.com/spreadsheets/d/1ehxYBvys3bFPOa5MY7C5QL_v9k5VacqobNFAMu6sfM0/edit#gid=642174692)

+ **Species Tree Estimation**  
	See script `ASTRAL_laucher.sbatch`. This script will loop through all the 32 disjucted genera as a serial of `SLURM` array jobs, doing: 1) create `ASTRAL` folder, rename and reroot RAxML best ML trees, into `gene_trees` and `genetree_reroot`, respectively. 2) Grap outgroup tips in the tree based on file `Dimension_OutGroup_list.csv`; so if the Outgroup present a gene tree, then using `Phyx` to reroot it, otherwise, the tree will be rerooted based on the [Minimal Ancestor Deviation (MAD)](https://www.nature.com/articles/s41559-017-0193); 3) using `newickutils` to collaps any nodes that below 10% BS or 75% BS (strict measure); 4) lastly, using the [ASTRAL-III](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-018-2129-y) to estimated the species tree.  

+ **PhypartsPiecharts**  
	See script `Phyparts_paiecharts_laucher.sbatch`. Similarly, this script will loop through all the 32 disjucted genera as a serial of `SLURM` array jobs, doing: 1) running the first step --- [phyparts](https://bitbucket.org/blackrim/phyparts/src) with species tree `genus_BS10_species.tre`, and also with another strict measure that letting phyparts collaps any node that below 50% BS support then summarize, 2) then pass to the second step for [PhyPartsPieCharts](https://github.com/mossmatters/MJPythonNotebooks/blob/master/PhyParts_PieCharts.ipynb). New version of `phypartspiecharts.py`, also puke out two `csv` table for all the statistics about node support and pie portion. Also see my post [here](https://www.sunmiao.name/post/phypartspiecharts/).  

Last update: Mon Feb 22 2021
