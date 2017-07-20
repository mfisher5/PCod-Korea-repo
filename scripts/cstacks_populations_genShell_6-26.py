###### Generate Shell Script to Run cstacks --> populations ######

## MF 3/8/2017 modified 4/29/2017
## For US Cod Data modified for Korean Cod Data



## At Command Line: python cstacks_populations_genShell_3-8 ARG1 ARG2
##---- ARG1 = samples for cstacks file 
##---- ARG2 = complete sample list file; in this script should be the population map


#############################################################################


import sys

catfilename = sys.argv[1]

sampfilename = sys.argv[2]

newfile = open("cstacks_populations_6-26.sh", "w")

#cstacks
newfile.write("\n"+"#cstacks"+"\n")
catFile = open(catfilename, "r")

filestring = "cstacks -b 6 "
for line in catFile: 			#for each sample file listed in the cstacks catalog file
	sampID = line.strip()	
	if sampID.startswith("#"): 
		newstring = ""
	else: 		
		newstring = "-s ../stacks_b6/" + sampID + " "
	filestring += newstring
catFile.close()
filestring += "-o ../stacks_b6 -n 3 -p 6"
newfile.write(filestring)



newfile.write("\n\n")



##sstacks: run by line
newfile.write("\n"+"#sstacks"+"\n")
samplefile = open(sampfilename, "r")

for line in samplefile: 			#for each line in the barcode file
	linelist=line.strip().split()
	newstring = "sstacks -b 6 -c ../stacks_b6 -s ../stacks_b6/" + linelist[0] + " -o ../stacks_b6 -p 6 2>> sstacks_out_b6"	#creates a new -s entry for that sample input file
	newfile.write(newstring + "\n")		# appends new -s string to "filestring"
samplefile.close()



newfile.write("\n\n")



##populations
newfile.write("populations -b 6 -P ../stacks_b6 -M PopMap_L1-4.txt -t 36 -r 0.75 -p 4 -m 5 --genepop --fasta 2>> populations_out_batch6")

newfile.close()

