### This python script will create a list of loci from the `populations` output genepop file ###

## ARGUMENTS: 
#ARG 1 - genepop file from `populations`. 
#ARG 2 - the .catalog file output from `cstacks` (unzipped)


import sys

#open the genepop file
genepop = open(sys.argv[1], "r")


#verify correct file
print "-----"
print "Reading loci from file:"
print sys.argv[1]



#create a list of loci from the genepop file (note - this will print out the heading line so it isn't included in the loci list)
UniqueLoci = []


print genepop.readline()
print ""


for line in genepop:
	if line.strip() != 'Pop':
		UniqueLoci.append(line.strip())
	else:
		break
genepop.close()


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
newfile = open("KORb4_final_filtered.fa", "w")
newfile.write(fasta)
newfile.close()
