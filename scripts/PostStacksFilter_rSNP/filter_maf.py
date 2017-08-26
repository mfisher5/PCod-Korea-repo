### Filter loci for MAF ###

## MF 8/25/2017
## Step 3 for Post-Stacks filtering with random SNP
## This filtering retains alleles that have a frequency of greater than 0.05 in ANY population.


#################################################################################

import argparse 

parser = argparse.ArgumentParser(description="filter for minor allele frequency (MAF)")

parser.add_argument("-f", "--input", help="genotype file in 2 x 2 matrix, with loci filtered for missing data")
parser.add_argument("-og", "--output_good", help="output file containing 'good' loci")
parser.add_argument("-ofg", "--outputfreqs_good", help="output file containing allele frequencies from 'good' loci")
parser.add_argument("-ob", "--output_bad", help="output file containing 'bad' loci")
parser.add_argument("-ofb", "--outputfreqs_good", help="output file containing allele frequencies from 'good' loci")
parser.add_argument("-s", "--stacks_path", help="path to the directory containing your stacks files")
parser.add_argument("-p", "--percent", help="threshold to remove missing data: ___ percent or more missing genotypes")

args = parser.parse_args()

#open infile and write heading to each output file's string
infile = open(args.stacks_path + "/" + args.input, "r")

good_loci = ""
bad_loci = ""
header_list = infile.readline().split(" ").strip()
header = ",".join(header_list)
good_loci += header + "\n"
bad_loci += header + "\n"


#

for mystring in genotypes_file:
	stripped_string = mystring.strip('\n')
	locus = stripped_string.split(' ')[0]
	locus_freqs = []
	bad_locus_freqs = []
	Pohang15 = stripped_string.split(' ')[1:32]
	Geoje15 = stripped_string.split(' ')[32:65]
	Namhae15 = stripped_string.split(' ')[65:81]
	YellowSea16 = stripped_string.split(' ')[81:105]
	Jukbyeon07 = stripped_string.split(' ')[105:130]
	JinhaeBay07 = stripped_string.split(' ')[130:159]
	JinhaeBay08 = stripped_string.split(' ')[159:195]
	Boryeong07 = stripped_string.split(' ')[195:217]
	Geoje14 = stripped_string.split(' ')[217:249]

	all_genotypes = stripped_string.split(' ')[1:]
	for genotype in all_genotypes:
		a1 = genotype[0:2]
		a2 = genotype[2:]
		if a1 not in alleles and a1 != "00":
        		alleles.append(a1)
    		if a2 not in alleles and a2 != "00":
        		alleles.append(a2)
	allele1 = alleles[0]
	allele2 = alleles[1]
	
	



















