# Author: Miao Sun
# This script one step in the automatic pipeline
# that it takes one argument as gene; then it will find the gene tree
# check if the outgroup present; if not the use mad to root the tree by minimal ancestor deviation
# see [Tria et al. (2017)](https://www.nature.com/articles/s41559-017-0193)

rm(list=ls())
library("ape")
suppressWarnings(suppressMessages(library("phytools")))
source("~/mad.R")

if (!dir.exists("genetree_reroot")){
dir.create("genetree_reroot")
}

nametag <- commandArgs(TRUE)
genus <- strsplit(nametag, split="_")[[1]][2]
OU <- read.csv("/blue/soltis/cactus/Dimension/Target_Enrichment/gene/gene_aln/Dimension_OutGroup_list.csv", sep="\t", header=TRUE)
OG <- OU$Outgroup[grep(genus, OU$Genus)]
tree <- read.tree(paste0("./gene_trees/", nametag, ".tre", sep=""))

# define a Outgroup vector
Outgroup <- NULL
for(i in OG){
	#get outgroup from tip lables
	gg <- tree$tip.label[grep(i, tree$tip.label)]
	if (length(gg)>0){
		Outgroup <-c(Outgroup, gg)
	}
}

if(sum(Outgroup %in% tree$tip.label) != 0){
	Ogstring <- paste0(paste0(Outgroup, sep=","), collapse="")
	
# if outgroup present reroot use outgroup via phyx function 'pxrr'
	cat("#!/bin/bash\n\nmodule load newickutils gcc/8.2.0 phyx/20190403\n\n", file="phyx_reroot.sh")
	cat(paste0("pxrr -t ./gene_trees/", nametag, ".tre -r -g ", Ogstring, " -o ./genetree_reroot/", nametag, ".rt.tre\n\n", sep=""), file="phyx_reroot.sh", append=TRUE)
	# cat("echo Done with phyx rooting \n", file="phyx_reroot.sh", append=TRUE)
	print(paste0("Rerooting ", nametag, " tree using phyx...", sep=""))
} else {
# otherwise use MAD see [Tria et al. (2017)](https://www.nature.com/articles/s41559-017-0193)
	cat(mad(tree), file=paste0("./genetree_reroot/", nametag, ".rt.tre", sep=""))
	print(paste0("Done with rerooting ", nametag, " gene tree using MAD...", sep=""))
}