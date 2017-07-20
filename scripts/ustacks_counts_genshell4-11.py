###### Produce Shell script to run ustacks to populations, for Lanes 1 and 2 combined data ######
## MF 11/15/2016
## Edited MF 1/17/2017
## Edited MF 4/7/2017 FOR ALL POPULATIONS

###############
## At the command line: python radtags_ustacks_genShellSR.py ARG1
#ARG 1: input file, lane 1 barcodes. line format: <barcode> \t <sampleID>
#ARG 2: input file, lane 2 barcodes
#ARG 3: input file, lane 3 barcodes
#ARG 4: input file, lane 4 barcodes. 

#should be run from within the "scripts" folder

###############
## Each time the script is run, make sure to change:
## (1) output shell name
## (2) absolute path to root directory, from which all local paths will be run. 
## (3) combined sample list name (3x , one for writing in beginning, and two for reading in ustacks and sstacks)
## (4) "ustacks" input and output file paths within ustacks code, input file type if necessary
## (5) "ustacks" stack depth !!! AS OF 4/7, STACK DEPTH 5, BOUNDED SNP MODEL W/ DEFAULT LIMITS


import sys
newfile = open("ustacks_counts_batch4.sh", "w")	#create a new file where the ustacks code will go
newfile.write("#!/bin/bash\n")

newfile.write("cd /mnt/hgfs/Shared\ Drive\ D/Pacific\ cod/DataAnalysis/PCod-Korea-repo/"+"\n")



#Take the four input files and make a master list of sample names, including adding ".1" to the end of the paired end samples. 
samplefile = open("L1-4_sampleList.txt", "w")

#=== Lanes 1 and 4: forward sequences of paired end
myfile = open(sys.argv[1], "r")
for line in myfile: 			#for each line in the barcode file	
	linelist=line.strip().split()	
	sampID = linelist[1] + ".1" 		#save the third object as "sampID"
	samplefile.write(sampID + "\n")
myfile.close()

myfile4 = open(sys.argv[4], "r")
for line in myfile4: 			#for each line in the barcode file	
	linelist=line.strip().split()	
	sampID = linelist[1] + ".1" 		#save the third object as "sampID"
	samplefile.write(sampID + "\n")
myfile4.close()

#=== Lanes 2 and 3: single read
myfile2 = open(sys.argv[2], "r")
for line in myfile2: 			#for each line in the barcode file	
	linelist=line.strip().split()	 	
	samplefile.write(linelist[1] + "\n")
myfile2.close()
	
myfile3 = open(sys.argv[3], "r")
for line in myfile3: 			#for each line in the barcode file	
	linelist=line.strip().split()	 	
	samplefile.write(linelist[1] + "\n")
myfile3.close()	


samplefile.close()


#Make directory for stacks output
newfile.write("mkdir stacks_b4" + "\n")


#ustacks 
newfile.write("\n"+"#ustacks"+"\n")
samplefile = open("L1-4_sampleList.txt", "r")

ID_int = 1
for line in samplefile: 			#for each line in the barcode file	
	sampID = line.strip()	
	if ID_int < 10: 
		ustacks_code = "ustacks -t fastq -f samplesT142/" + sampID + ".fq -r -d -o stacks_b4 -i 00" + str(ID_int) + " -m 5 -M 3 -p 6 --model_type bounded" + "\n"
	elif ID_int >= 10 and ID_int < 100: 
		ustacks_code = "ustacks -t fastq -f samplesT142/" + sampID + ".fq -r -d -o stacks_b4 -i 0" + str(ID_int) + " -m 5 -M 3 -p 6 --model_type bounded" + "\n"
								#create a line of code for ustacks that includes the new sample ID (with 1 leading 0)
	else: 
		ustacks_code = "ustacks -t fastq -f samplesT142/" + sampID + ".fq -r -d -o stacks_b4 -i " + str(ID_int) + " -m 5 -M 3 -p 6 --model_type bounded" + "\n"
								#create a line of code for ustacks that includes the new sample ID (with no leading 0s)
	newfile.write(ustacks_code)	#append this new line of code to the output file
	ID_int += 1
samplefile.close()





# count the number of reads per file
newfile.write("\n#count total reads\n")
newfile.write("cd /mnt/hgfs/Shared\ Drive\ D/Pacific\ cod/DataAnalysis/PCod-Korea-repo/samplesT142\n")
samplefile = open("L1-4_sampleList.txt", "r")
for line in samplefile:
	sampID = line.strip()
	newstr = "awk '((NR-2)%4==0){read=$1;total++;count[read]++}END;print total}' " + sampID + ".fq >> ../fastq_readcounts_temp.txt"
	newfile.write(newstr + "\n")

samplefile.close()


# call file that organizes the fastq_readcounts.txt so that it includes sample names. 
newfile.write("cd /mnt/hgfs/Shared\ Drive\ D/Pacific\ cod/DataAnalysis/PCod-Korea-repo\n")
newfile.write("\n\npython scripts/addsampIDs_readcountsfile.py -s scripts/L1-4_sampleList.txt -i fastq_readcounts_temp.txt -o fastq_readcounts.txt\n\n")


# count the number of loci per ustacks file
newfile.write("\n#count loci\n")
newfile.write("python scripts/countloci_tagsfiles.py -s scripts/L1-4_sampleList.txt -d /mnt/hgfs/Shared\ Drive\ D/Pacific\ cod/DataAnalysis/PCod-Korea-repo/stacks_b4 -o tagcounts_ustacks.txt\n\n")



newfile.close()
