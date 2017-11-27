# MF 11/27/2017
# Modified for Pacific cod from Natalie Lowell's script 'filter_MAF_acrosspops.py'
#
# PURPOSE: Calculate MAF across all individuals from a filtered genepop file. 
#
# INPUTS: managed by argparse below, include:
# - genepop input file
# - name for output text file with MAF for each locus
#
#
#
# ---------------- original script info ------------- #
# 20170322 Natalie Lowell                             #
#                                                     #
# PURPOSE: This script filters out loci where any     #
#    haplotype occurs less than a threshold frequency,#
#    and only keeps loci that occur in at least N     #
#    individuals.                                     #
# --------------------------------------------------- #
# 
# -----------------------------------------------------------------------------

import sys
import argparse
import numpy as np
import os

# manage args with argparse
parser = argparse.ArgumentParser(description="Takes a genepop file and calculates MAF for each locus across all samples. This script will produce a temp file, but it will be deleted when script is done running.")
parser.add_argument("-i", "--genfile", help="Input file - should be in genepop format. Script will automatically detect if loci are delimited by 'new line' or ','", type=str, required = True)
parser.add_argument("-o", "--output", help="Output file with MAF frequencies, tab-delimited", type=str, required = True)
args = parser.parse_args()

# open input genepop file
genepop = open(args.genfile, "r")
# open files for storing output
output = open(args.output, "w")

#write header lines in output file
header = genepop.readline()
output.write(header)
output.write("locus\tMAF_allsamples\n")

#load in loci names
first_locus_line = genepop.readline().strip()
if "," in first_locus_line:
    sep_type = "comma"
    loci_list = first_locus_line.split(",")
    genepop.readline() #skip over the first "pop"

else:
    sep_type = "newline"
    loci_list = [first_locus_line]
    line = genepop.readline()
    while "pop" not in line and "Pop" not in line:
        loci_list.append(line.strip())
        line = genepop.readline()
print "You have ", len(loci_list), " loci."


#read only the genepop lines that have genotypes (excludes header, loci, and "pop" headings)
data_mat = ""
for line in genepop:
    if "pop" not in line and "Pop" not in line:
        data_mat += line
tempfile = open("calc_maf_fromGENEPOP_matrix_tempfile.txt", "w")
tempfile.write(data_mat)
tempfile.close()


#read genepop lines of genepop file by column (1 column = 1 locus), calculate MAF, and then write out that locus' MAF to text file
print "calculating MAF per locus..."
n_loci = len(loci_list)
for locus_index in range(0, n_loci):
    col_index = locus_index + 1
    genotypes = np.loadtxt(fname = "calc_maf_fromGENEPOP_matrix_tempfile.txt", usecols = [col_index], dtype = "str")
    hom_01 = len([i for i in genotypes if i == "0101"])
    hom_02 = len([i for i in genotypes if i == "0202"])
    het = len([i for i in genotypes if i == "0102"])
    total = 2*(hom_01 + hom_02 + het)
    allele1 = float((2*hom_01) + het) / float(total)
    allele2 = float((2*hom_02) + het) / float(total)
    maf = min(allele1, allele2)
    output.write(loci_list[locus_index] + "\t" + str(maf) + "\n")
    if maf > 0.50:
        print "fix your code! The MAF > 0.50."
        print allele1
        print allele2
print "Done."        
output.close()
os.remove("calc_maf_fromGENEPOP_matrix_tempfile.txt")
print "Temporary file removed."