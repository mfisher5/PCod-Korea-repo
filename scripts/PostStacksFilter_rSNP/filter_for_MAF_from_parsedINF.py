####### This script will filter for MAF based on the parsed output file #########

## MF 8/29/2017

## Written for write_random_snp post stacks filtering

##################################################################################


import argparse

parser = argparse.ArgumentParser(description="filter for MAF using parsed .INF genepop file.")

parser.add_argument("-inf", "--INFinput", help="parsed .INF file")
parser.add_argument("-mat", "--MATRIXinput", help="half filtered matrix file that was used to make genepop file")
parser.add_argument("-og", "--output_good", help="output file, good loci")
parser.add_argument("-ob", "--output_bad", help="output file, bad loci")
parser.add_argument("-ofg", "--outputfreqs_good", help="output file, frequencies of good loci")
parser.add_argument("-ofb", "--outputfreqs_bad", help="output file, frequencies of bad loci")
parser.add_argument("-p", "--path_stacks", help="path to stacks files, including .INF file")
parser.add_argument("-a", "--alleles", help="maximum number of alleles; this should have been printed out during the parsing script.")
parser.add_argument("-b", "--batch", help="stacks batch number")

args = parser.parse_args()


# open files 
infile = open(args.path_stacks + "/" + args.INFinput, "r")
goodfreqs = open(args.path_stacks + "/" + args.outputfreqs_good, "w")
badfreqs = open(args.path_stacks + "/" + args.outputfreqs_bad, "w")


header = infile.readline()
goodfreqs.write(header)
badfreqs.write(header)
header_list = header.strip().split()



loci_to_keep = []
for line in infile:
	linelist = line.strip().split("\t")
	locus = linelist[0]
	freqs = linelist[1:]
	if int(args.alleles) == 2:
		allele1_freqs = freqs[0::2]
		allele2_freqs = freqs[1::2]
		alleles_list = [allele1_freqs, allele2_freqs]
	elif int(args.alleles0) == 3:
		allele1_freqs = freqs[0::3]
		allele2_freqs = freqs[1::3]
		allele3_freqs = freqs[2::3]
		alleles_list = [allele1_freqs, allele2_freqs, allele3_freqs]
	elif int(args.alleles) == 4:
		allele1_freqs = freqs[0::4]
		allele2_freqs = freqs[1::4]
		allele3_freqs = freqs[2::4]
		allele4_freqs = freqs[3::4]
		alleles_list = [allele1_freqs, allele2_freqs, allele3_freqs, allele4_freqs]
	count_good_alleles = 0
	n_alleles = 0
	for freq_list in alleles_list:
		if len([freq for freq in freq_list if freq != '-']) > 0:
			n_alleles += 1
			genotyped_alleles = [i for i in freq_list if i != '-']
			if any(float(freq) > 0.05 for freq in genotyped_alleles):
				count_good_alleles += 1
	if count_good_alleles == n_alleles:
		goodfreqs.write(line)
		loci_to_keep.append(locus)
	else:
		badfreqs.write(line)

infile.close()
goodfreqs.close()
badfreqs.close()

		
infile2 = open(args.path_stacks + "/" + args.MATRIXinput, "r")
goodfile = open(args.path_stacks + "/" + args.output_good, "w")
badfile = open(args.path_stacks + "/" + args.output_bad, "w")

header = infile2.readline()
goodfile.write(header)
badfile.write(header)

loci_to_good = 0
loci_to_bad = 0
for line in infile2:
	locus = line.strip().split()[0]
	if locus in loci_to_keep:
		goodfile.write(line)
		loci_to_good += 1
	else:
		badfile.write(line)
		loci_to_bad += 1

infile.close()
goodfile.close()
badfile.close()

print loci_to_good, " loci written to filtered output file."
print "Filtered out ", loci_to_bad, " loci."
	
		


