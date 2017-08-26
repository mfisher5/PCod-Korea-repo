###### Generate Shell Script to Run pstacks --> populations ######

## MF 3/10/2017
## For US Cod Data

## Edited by MF 5/3/2017 for Korea PCod Data
## Edited 6/25/2017 for Korea PCod Data, 8/21/2017 to include batch number as an argument

## At Command Line: python cstacks_populations_genShell_7-6 ARG1 ARG2
##---- ARG1 = complete sample list file, can be population map
##---- ARG2 = sample list for building cstacks catalog
##---- ARG3 = batch number


#############################################################################


import sys

sampfilename = sys.argv[1]
catfilename = sys.argv[2]
batch = sys.argv[3]

newfile = open("pstacks_sstacks_b" + batch + ".sh", "w")

#pstacks

newfile.write("\n"+"#pstacks"+"\n")
samplefile = open(sampfilename, "r")
ID_int = 1
for line in samplefile: 			#for each line in the barcode file	
	sampID = line.strip().split()[0]	
	if ID_int < 10: 
		ustacks_code = "pstacks -t sam -f ../stacks_b" + batch + "_wgenome/" + sampID + ".sam -o ../stacks_b" + batch + "_wgenome -i 00" + str(ID_int) + " -m 10 -p 6 --model_type bounded 2>> ../stacks_b" + batch + "_wgenome/pstacks_out_b" + batch + "_wgenome" + "\n"
	elif ID_int >= 10 and ID_int < 100: 
		ustacks_code = "pstacks -t sam -f ../stacks_b" + batch + "_wgenome/" + sampID + ".sam -o ../stacks_b" + batch + "_wgenome -i 0" + str(ID_int) + " -m 10 -p 6 --model_type bounded 2>> ../stacks_b" + batch + "_wgenome/pstacks_out_b" + batch + "_wgenome" + "\n"
	else: 
		ustacks_code = "pstacks -t sam -f ../stacks_b" + batch + "_wgenome/" + sampID + ".sam -o ../stacks_b" + batch + "_wgenome -i " + str(ID_int) + " -m 10 -p 6 --model_type bounded 2>> ../stacks_b" + batch + "_wgenome/pstacks_out_b" + batch + "_wgenome" + "\n"
	newfile.write(ustacks_code)	#append this new line of code to the output file
	ID_int += 1
samplefile.close()

newfile.write("\n\n")




#cstacks
newfile.write("\n"+"#cstacks"+"\n")
catFile = open(catfilename, "r")

filestring = "cstacks -b " + batch + " "
for line in catFile: 			#for each sample file listed in the cstacks catalog file
	sampID = line.strip()	
	if sampID.startswith("#"): 
		newstring = ""
	else: 		
		newstring = "-s ../stacks_b" + batch + "_wgenome/" + sampID + " "
	filestring += newstring
catFile.close()
filestring += "-o ../stacks_b" + batch + "_wgenome -g -p 6 2>> cstacks_out_b" + batch + "_wgenome"
newfile.write(filestring)



newfile.write("\n\n")



##sstacks: run by line
newfile.write("\n"+"#sstacks"+"\n")
samplefile = open(sampfilename, "r")

for line in samplefile: 			#for each line in the barcode file
	linelist=line.strip().split()
	newstring = "sstacks -b " + batch + " -c ../stacks_b" + batch+ "_wgenome/batch_" + batch + " -s ../stacks_b" + batch + "_wgenome/" + linelist[0] + " -o ../stacks_b" + batch + "_wgenome -p 6 2>> sstacks_out_b" + batch + "_wgenome"	#creates a new -s entry for that sample input file
	newfile.write(newstring + "\n")		# appends new -s string to "filestring"
samplefile.close()



newfile.close()



