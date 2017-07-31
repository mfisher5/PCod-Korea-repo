### This python script will create a list of loci from the `populations` output genepop file ###

## ARGUMENTS: 
#ARG 1 - genepop file from `populations`. 
#ARG 2 - the .catalog file output from `cstacks` (unzipped)

### output will appear in the same folder as this script and will automatically be named "seqsforBOWTIE.fa"

import sys

#open the genepop file
genepop = open(sys.argv[1], "r")


#verify correct file
print "-----"
print "Reading loci from file:"
print sys.argv[1]


#create a list of loci from the genepop file (note - this will include the heading line)
LociList = []

print genepop.readline()
LociList = genepop.readline().strip()

genepop.close()


#write out all contents of list into a temporary file
tempfile = open("temp_locilist.txt", "w")
tempfile.write(LociList)
tempfile.close()

print "Done reading loci"
print ""



#read row of loci names into a string
tempfile = open("temp_locilist.txt", "r")
Filestring = tempfile.read()
tempfile.close()

#import the temporary file
import os
os.remove("temp_locilist.txt")

#identify the unique loci
lociList = Filestring.split(",")
UniqueLoci = []
for locus in lociList:
	templocus = locus.split("_")
	if templocus[0] not in UniqueLoci:
		UniqueLoci.append(templocus[0])



#open the UNZIPPED catalog file
catalog = open(sys.argv[2], "r")
print "Using sequences from catalog file:"
print sys.argv[2]
print ""

#extract the sequences from the catalog file
fasta = ""
for line in catalog: 
	linelist = line.strip().split()
	if linelist[2] in UniqueLoci: 
		newline = ">"+linelist[2]+"\n"+linelist[9]+"\n"
		fasta += newline
catalog.close()


#open a new file to write into 
print "Writing new fasta file..."
newfile = open("seqsforBOWTIE.fa", "w")
newfile.write(fasta)
newfile.close()

print "Done."