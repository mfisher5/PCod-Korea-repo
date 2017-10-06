#### This script will take a text file containing the R output from BAYESCAN's function plot_bayescan() and find the correct outlier loci's IDs ####

## MF 10/6/2017
## Note that input file should be a text file of R output in the console copied directly into a text file 

#######################################################################################################################
import argparse 

parser = argparse.ArgumentParser(description="produce SNPmat file, and files containing loci / population lists for OutFLANK outlier analysis.")

parser.add_argument("-i", "--input", help="text file containing plot_bayescan() R consol output")
parser.add_argument("-gen", "--genepop", help="the genepop file used in PGD spyder to create BAYESCAN input file")
parser.add_argument("-sep", "--separator", help="are the loci in your genepop file separated by a 'comma' or a 'newline'?")
parser.add_argument("-o", "--output", help="output text file")
parser.add_argument("-head", "--header", help="header for output text file. should start with #")


args = parser.parse_args()

infile = open(args.input, "r")
genepop = open(args.genepop, "r")
outfile = open(args.output, "w")


## get list of loci IDs from bayescan output
print "reading BAYESCAN outliers.."
line = infile.readline()
while not line.startswith("$outliers"):
    line = infile.readline()

pgdspyder_loci = []

for line in infile:
    linelist = line.strip().split()
    if len(linelist) > 1:
		for locus in linelist[1:]:
			pgdspyder_loci.append(locus)

infile.close()
print "You have ", len(pgdspyder_loci), " outlier loci."


## put stacks loci in a list so indices will correspond to bayescan locus IDs 
print "indexing stacks loci..."
stacks_loci = []

genepop.readline() #header of genepop

line = genepop.readline()

if args.separator == "comma":
	stacks_loci = line.strip().split(",")
elif args.separator == "newline":
	while not line.startswith("Pop"):
		stacks_loci.append(line.strip())
		line = genepop.readline()
else:
	print "ERROR: unacceptable separator argument."
genepop.close()


## correlate bayescan loci IDs to stacks IDs

stacks_outlier_loci = []

for i in pgdspyder_loci: 
	 	stacks_outlier_loci.append(stacks_loci[int(i)-1])		# pgdspyder index numbers start from '1', python indices start from '0'



## write to output file
print "writing to output..."
outfile.write(args.header + "\n")
for i in stacks_outlier_loci:
	outfile.write(i + "\n")
outfile.close()

print "Done."