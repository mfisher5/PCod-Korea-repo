############### CREATE FASTA FILE FROM GENEPOP #######################
#
# MF 12/1/2017
# PURPOSE: create a fasta file using a filtered genepop file and the corresponding stacks catalog 'tags' file. 
#
#
######################################################################

import argparse 

parser = argparse.ArgumentParser(description="create fasta file for all loci in a genepop file.")

parser.add_argument("-g", "--genepop", help="genepop file input.")
parser.add_argument("-t", "--tags", help="stacks catalog 'tags' file.")
parser.add_argument("-split", "--split_by", help="type of delimiter used for loci in genepop file ['comma' / 'newline'].")
parser.add_argument("-o", "--output", help="fasta output file")


args = parser.parse_args()


#######################################################################

## open files ##
infile = open(args.genepop, "r")
tags = open(args.tags, "r")
outfile = open(args.output, "w")


## read in loci IDs ##
header = infile.readline()

if args.split_by == "comma":
	loci_list = infile.readline().strip().split(",")
elif args.split_by == "newline":
	loci_list = []
	for line in infile:
		if "pop" not in line and "Pop" not in line:
			loci_list.append(line.strip())
		else: 
			break
infile.close()
print "You have ", len(loci_list), " loci."


## grap the consensus sequence for each locus out of the stacks tags file ##
added_loci = 0
for line in tags:
	linelist = line.strip().split()
	if linelist[2] in loci_list:
		outfile.write(">Locus_" + linelist[2] + "\n" + linelist[9] + "\n")
		added_loci += 1
print added_loci, " written to fasta file."
tags.close()
outfile.close()





