#### Counts the number of unique loci in a text file containing the header of a .genepop file (Locus_SNP). To be used after running populations, to determine how many loci were retained ####

## MF 12/12/2016

## Edited 3/21/2017 after not putting out the same number of loci as the `genBOWTIEfasta_fromGENEPOP.py` script




import sys
genepop = open(sys.argv[1], "r")


##### original ###########
#read row of loci names into a string
#header = genepop.readline()
#print header
#Filestring = genepop.readline()
#genepop.close()

#lociList = Filestring.split(",")
#UniqueLoci = []
#for locus in lociList:
#	templocus = locus.split("_")
#	if templocus[0] not in UniqueLoci:
#		UniqueLoci.append(templocus[0])

#count the number of loci in the UniqueLoci list
#print "With the ORIGINAL script:"
#print "The number of unique loci in ", sys.argv[1], "is: ", len(UniqueLoci)
#print ""
#print ""
#print "With the NEW script, used in the pipeline:"



##### original ###########
#create a list of loci from the genepop file (note - this will include the heading line)
genepop = open(sys.argv[1], "r")
LociList = []

header = genepop.readline()
print header
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

#remove the temporary file
import os
os.remove("temp_locilist.txt")

#identify the unique loci
lociList = Filestring.split(",")
UniqueLoci = []
for locus in lociList:
	templocus = locus.split("_")
	if templocus[0] not in UniqueLoci:
		UniqueLoci.append(templocus[0])


#count the number of loci in the UniqueLoci list
print "The number of unique loci in ", sys.argv[1], "is: ", len(UniqueLoci)
