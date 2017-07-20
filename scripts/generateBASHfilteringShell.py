### THIS SCRIPT GENERATES THE BASH SHELL THAT WILL CREATE YOUR REFERENCE GENOME BY RUNNING BOWTIE AND BLAST FILTERING ###

## arguments: input file, pre-formatted
##MF 2/11/2017

###################################################################################################

import sys
input = open(sys.argv[1], "r")
shell = open("REFERENCE_filtering.sh", "w")

#set variable names from input file
input.readline()
HOME = input.readline().split("\t")[0]
stacksDIRECT = input.readline().split("\t")[0]
BATCH = input.readline().split("\t")[0]
scriptDIRECT = input.readline().split("\t")[0]
scriptDIRECTbowtie = input.readline().split("\t")[0]
scriptDIRECTblast = input.readline().split("\t")[0]
print ""
print "You input the following:"
print ""
print "location of new bash shell:", HOME
print "location of your stacks files:", stacksDIRECT
print "batch: ", BATCH
print "first script directory:", scriptDIRECT
print "second script directory:", scriptDIRECTbowtie
print "third script directory:", scriptDIRECTblast


#initiate the shell with intro text 
shell.write("#!/bin/bash" + "\n")
shell.write("### This shell script will create the fasta file for BOWTIE, and then run BOWTIE for you ###\n## M.Fisher 2/11/2017\n\n\n")

shell.write("echo 'Before running running this script, please be sure that you have the following:'\necho ''\necho '1. BLAST installed to run from any folder'\necho ''\necho '2. A single folder containing (1) stacks populations output, and (2) bowtie'\necho ''\necho '3. These additional python scripts: (1) genBOWTIEfasta_fromGENEPOP.py, (2) parseBowtie_DD.py, (3) checkBlastResults_DD.py'\necho ''\n")

shell.write("echo 'Are you ready for the script to run?'\nread ANSWER\nif [ $ANSWER == 'no' ]; then\n\texit 1\nfi\n")



#unzip catalog.tags.tsv file if needed
shell.write("echo 'Is your catalog.tags.tsv file zipped? [yes / no]'\nread ZIPPED\nif [ $ZIPPED == 'yes' ]; then\n\tgzip -d " + stacksDIRECT + "/batch_" + BATCH + ".catalog.tags.tsv.gz\nfi\n")



#generate the fasta file for bowtie
shell.write("\n#generate the fasta file for bowtie\n")
shell.write("python " + scriptDIRECT + "/genBOWTIEfasta_fromGENEPOP.py " + stacksDIRECT + "/batch_" + BATCH + ".genepop " + stacksDIRECT + "/batch_" + BATCH + ".catalog.tags.tsv")

shell.write("\necho '---'\n")
shell.write("echo 'WE WILL NOW FILTER WITH BOWTIE.'\n")
shell.write("echo ''\n")

shell.write("mv seqsforBOWTIE.fa " + stacksDIRECT + "/seqsforBOWTIE.fa\n")

#build a bowtie catalog and filter with bowtie
shell.write("\n# build a bowtie catalog\n")
shell.write("cd " + stacksDIRECT + "\n\n")
shell.write("bowtie-build seqsforBOWTIE.fa batch_" + BATCH + "\n\nbowtie -f -v 3 --sam --sam-nohead batch_" + BATCH + " seqsforBOWTIE.fa batch_" + BATCH+ "_BOWTIEout.sam\n\n")


#parse out "good" loci using Dan's script
shell.write("\n# parse out only good loci using Dan's script\n")
shell.write("echo 'PARSING OUT ONLY GOOD LOCI FROM BOWTIE FILTERING...'\n")
shell.write("cd " + HOME + "\n\n")
shell.write("python " + scriptDIRECTbowtie + "/parseBowtie_DD.py " + stacksDIRECT + "/batch_" + BATCH + "_BOWTIEout.sam " + stacksDIRECT + "/batch_" + BATCH + "_BOWTIEout_filtered.fa\n")

#filter with BLAST
shell.write("\n# BLAST filtering\n")
shell.write("echo 'CREATING BLAST DATABASE...'\n")
shell.write("cd " + stacksDIRECT + "\n")
shell.write("makeblastdb -in batch_" + BATCH + "_BOWTIEout_filtered.fa -parse_seqids -dbtype nucl -out batch_" + BATCH + "_BOWTIEfilteredDB\n\necho 'querying database...'\n\nblastn -query batch_" + BATCH + "_BOWTIEout_filtered.fa -db batch_" + BATCH + "_BOWTIEfilteredDB -out batch_" + BATCH + "_BOWTIEout_BLASTout\n\n") 

#parse out good loci using Dan's script
shell.write("\n# filter out blast results\n")
shell.write("echo 'PARSING OUT ONLY GOOD LOCI FROM BLAST FILTERING...'\n")
shell.write("cd " + HOME + "\n\n")
shell.write("python " + scriptDIRECTblast + "/checkBlastResults_DD.py " + stacksDIRECT + "/batch_" + BATCH + "_BOWTIEout_BLASTout " + stacksDIRECT + "/batch_" + BATCH + "_BOWTIEout_filtered.fa " + stacksDIRECT + "/batch_" + BATCH + "_BOWTIEout_BLASTout_filtered.fa " + stacksDIRECT + "/batch_" + BATCH + "_BOWTIEout_BLASTout_bad.fa\n\n") 

shell.write("echo ''\necho 'Number of loci in reference file:'\ngrep -c '^>' batch_" + BATCH + "_BOWTIEout_BLASTout_filtered.fa\necho ''\n\n")

#create final SAM file
shell.write("\n# create final SAM file\n")
shell.write("echo 'CREATING FINAL SAM FILE OF THE REFERENCE DATABASE OF LOCI...'\n")
shell.write("cd " + stacksDIRECT + "\n\n")
shell.write("bowtie-build batch_" + BATCH + "_BOwTIEout_BLASTout_filtered.fa batch_" + BATCH + "_ref_genome\n\n")
shell.write("echo 'REFERENCE GENOME CREATED.'")
