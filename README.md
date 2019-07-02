---
output:
  word_document: default
  pdf_document: default
  html_document: default
---
# IESHTSTE

### _**Intructions for extracting sequences from HTS target enrichment reads**_

## Data

This batch was generated by [RAPiD Genomics](www.rapid-genomics.com).  

Within the data directory there is a SampleSheet **csv** file with the barcodes, filenames, and sample codes.   

_**Note that Plates1-4 were sequenced on two lanes (L001 and L002), so there are two sets of fastq files per sample.**_

 

**Raw Data:**  

*  This data has been demultiplexed using Illuminas BCLtofastq. No quality trimming or processing has been done beyond demutiplexing. 

* The adapters used are below, _"BCBCBCBC"_ stands for the barcodes.

  + i7: GATCGGAAGAGCACACGTCTGAACTCCAGTCAC-BCBCBCBC-ATCTCGTATGCCGTCTTCTGCTTG

  + i5: AATGATACGGCGACCACCGAGATCTACAC-BCBCBCBC-ACACTCTTTCCCTACACGACGCTCTTCCGATCT


## Assembly methods

Currently, Three ways you can analyze high-throughput sequencing reads using target enrichment:  
  
  1. HybPiper 
  
  [Publication](https://bsapubs.onlinelibrary.wiley.com/doi/full/10.3732/apps.1600016)  
  
  [Code in github](https://github.com/mossmatters/HybPiper)
  
  2. aTRAM  
  
  [Publication](https://journals.sagepub.com/doi/10.1177/1176934318774546)  
  
  [Code in github](https://github.com/moskalenko/aTRAM)
  
  3. SECAPR  
  
  [Publication](https://peerj.com/articles/5175/)  
  
  [Code in github](https://github.com/AntonelliLab/seqcap_processor)
  
  
### HybPiper   

  _Credit to Andre A. Naranjo in Soltis Lab_  
  _Miao modified and add in Shell cmd and bash scripts_
  
  **Steps for Hybpiper:**  
  
  1. Concatenate all lanes (L001 and L002; only if you have them on separate plates!)  
    e.g.  
    `cat RAPiD-Genomics_F076_UFL_###_P003_WD02_i5-503_i7-72_S22_L001_R1_001.fastq.gz RAPiD-Genomics_F076_UFL_###_P003_WD02_i5-503_i7-72_S60_L002_R1_001.fastq.gz > P003_WD02_72_R1.fastq.gz`  
    
    or run in a batch manner:  
    
    `bash fastq_lane_cat.sh sample_ID_file Seq_ID_table`  
    
    e.g.,  
    
    `bash fastq_lane_cat.sh Evgeny_13.txt UFL_394803_SampleSheet.csv`
    
  This bash script will take two input files: one is sample ID file, and the other is sequence ID table.  
  
    e.g.,   
      `[cactus]$ head XXX_88.txt
      CPG00213
      CPG00216
      CPG05361
      CPG05783
      CPG07101
      CPG10128
      CPG11009
      CPG11189
      CPG11230  
      
      [cactus]$ head -6 UFL_XXX_SampleSheet_XXX86.csv
      RG_Sample_Code,Customer_Code,i5_Barcode_Seq,i7_Barcode_Seq,Sequence_Name,Sequencing_Cycle
      UFL_394803_P002_WG08,D_4566,TAAGATTA,TTCACGCA,RAPiD-Genomics_F076_UFL_394803_P002_WG08_i5-506_i7-68_S171_L001_R1_001.fastq.gz,2x150
      UFL_394803_P002_WG09,D_4567,TAAGATTA,CGACTGGA,RAPiD-Genomics_F076_UFL_394803_P002_WG09_i5-506_i7-41_S172_L001_R1_001.fastq.gz,2x150
      UFL_394803_P002_WG10,D_4568,TAAGATTA,CCGAAGTA,RAPiD-Genomics_F076_UFL_394803_P002_WG10_i5-506_i7-37_S173_L001_R1_001.fastq.gz,2x150 UFL_394803_P002_WG11,D_4570,TAAGATTA,GCCAAGAC,RAPiD-Genomics_F076_UFL_394803_P002_WG11_i5-506_i7-96_S174_L001_R1_001.fastq.gz,2x150 UFL_394803_P002_WG12,D_4571,TAAGATTA,CGCATACA,RAPiD-Genomics_F076_UFL_394803_P002_WG12_i5-506_i7-42_S175_L001_R1_001.fastq.gz,2x150
`
    
    
  3. ***fastqc** to quick check the quality; and later on can be used for comparison after trim and clean.  
  * scripts needed:  
    fastqc.sh check_result.sh mean.R
  
  e.g.,  
  `module load ufrc fastqc`  
  `srundev -t time`  
  `fastqc *.gz -o FastQC_result`  
  
  For slurm job scripts see:  
  **fastqc.sbatch**  
  + after runing _fastqc.sh_, it will put fastqc results in to folder called _FastQC_result_ ;
  + Move scripts _check_result.sh_, and _mean.R_, into _FastQC_result_, then excute the bash script, it will generate a summary table _Illumina_FastQC_report.csv_ for reads quality. Details see folder _unzip_file_.

  4. Trim and clean reads using Trimmomatic, and preapre for next step --- Hybpiper.
  * scripts needed:  
    Trimmomatic.sbatch  (if you have a few sample you can just go with bash Trimmomatic.sh)
    For large number of samples, submission to SLURM in HPC is required.
  * run: `bash Trimmomatic.sh`

  5. run hybpiper  
  
  6. if want introns run intron script on accession folders out putted from previous step  
  
  7. to retrieve the supercontig sequences from the above run  put them all in one place (so mv P*W* seq_dir):
> module load python
> python HybPiper/retrieve_sequences.py baits1.fasta seq_dir dna
(just exons use DNA, if you run intronerate use supercontig)

  8. run mafft script on individual gene
  9. Phyx
    + rename
    + concatenation
    + remove gaps and ambiguity
  10. run raxml


