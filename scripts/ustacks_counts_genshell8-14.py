###### Produce Shell script to run ustacks to populations, for Lanes 1 and 2 combined data ######
## MF 11/15/2016
## Edited MF 1/17/2017
## Edited MF 4/7/2017 FOR ALL POPULATIONS
## Edited MF 8/14/2017 for Lane 5 Data

###############
## At the command line: python radtags_ustacks_genShellSR.py ARG1
#ARG 1: input file, lane 5 barcodes. line format: <barcode> \t <sampleID>

#should be run from within the "scripts" folder

###############
## Each time the script is run, make sure to change:
## (1) output shell name
## (2) absolute path to root directory, from which all local paths will be run. 
## (3) combined sample list name (3x , one for writing in beginning, and two for reading in ustacks and sstacks)
## (4) "ustacks" input and output file paths within ustacks code, input file type if necessary
## (5) "ustacks" stack depth !!! AS OF 4/7, STACK DEPTH 5, BOUNDED SNP MODEL W/ DEFAULT LIMITS


import sys
newfile = open("ustacks_counts_lane5.sh", "w")	#create a new file where the ustacks code will go
newfile.write("#!/bin/bash\n")

newfile.write("cd /mnt/hgfs/Shared\ Drive\ D/Pacific\ cod/DataAnalysis/PCod-Korea-repo/scripts"+"\n")


#=== Lane5: make list of sample names
samplelist = []
myfile = open(sys.argv[1], "r")
for line in myfile: 			#for each line in the barcode file	
	linelist=line.strip().split()	 	
	samplelist.append(linelist[1])
myfile.close()
	


#ustacks 
newfile.write("\n"+"#ustacks"+"\n")

ID_int = 265
for sampID in samplelist: 			#for each sample in the list	
	ustacks_code = "ustacks -t fastq -f samplesT142/" + sampID + ".fq -r -d -o stacks_b7 -i " + str(ID_int) + " -m 5 -M 3 -p 6 --model_type bounded" + "\n"
								#create a line of code for ustacks that includes the new sample ID (with no leading 0s)
	newfile.write(ustacks_code)	#append this new line of code to the output file
	ID_int += 1





# count the number of reads per file
newfile.write("\n#count total reads\n")
newfile.write("cd /mnt/hgfs/Shared\ Drive\ D/Pacific\ cod/DataAnalysis/PCod-Korea-repo/samplesT142\n")
samplefile = open("../scripts/L5_sampleList.txt", "w")
for sampID in samplelist:
	newstr = "awk '((NR-2)%4==0){read=$1;total++;count[read]++}END;print total}' " + sampID + ".fq >> ../fastq_readcounts_temp.txt"
	newfile.write(newstr + "\n")
	samplefile.write(sampID+"\n")
samplefile.close()


# call file that organizes the fastq_readcounts.txt so that it includes sample names. 
newfile.write("cd /mnt/hgfs/Shared\ Drive\ D/Pacific\ cod/DataAnalysis/PCod-Korea-repo\n")
newfile.write("\n\npython scripts/addsampIDs_readcountsfile.py -s scripts/L5_sampleList.txt -i fastq_readcounts_temp.txt -o fastq_readcounts_Lane5.txt\n\n")


# count the number of loci per ustacks file
newfile.write("\n#count loci\n")
newfile.write("python scripts/countloci_tagsfiles.py -s scripts/L5_sampleList.txt -d /mnt/hgfs/Shared\ Drive\ D/Pacific\ cod/DataAnalysis/PCod-Korea-repo/stacks_b7 -o tagcounts_ustacks_Lane5.txt\n\n")



newfile.close()
