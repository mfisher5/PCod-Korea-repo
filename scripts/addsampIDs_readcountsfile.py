#### This script takes a temporary input file with fastq readcounts and creates a tab deliminated file with the sample name and the associated read count ####


import argparse 

parser.add_argument("-s", "--samples", help="file with list of samples. should be in same order as read counts in input file")
parser.add_argument("-i", "--input", help="input file. should be temp file with just read counts")
parser.add_argument("-o", "--output", help="output file")

samplefile = open(args.samples, "r")
infile = open(args.input, "r")
outfile = open(args.output, "w")


outfile.write("sample\tn_reads")

samplelist = []
for line in samplefile:
	samplelist.append(line.strip())
samplefile.close()

readlist = []
for line in infile: 
	readlist.append(line.strip())
infile.close()

for i in range(0,len(samplelist-1)):
	outfile.write("\n" + samplelist[i]+ "\t" + readlist[i])

outfile.close()


	
