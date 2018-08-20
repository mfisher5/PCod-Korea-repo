### Find distance between aligned sequences ###

## MF 8/20/2018


#################################################################################

import argparse 

parser = argparse.ArgumentParser(description="filter loci for missing data")

parser.add_argument("-i", "--input", help="sam alignment file")
parser.add_argument("-o", "--output", help="file with pairwise distances between loci on same scaffold")

args = parser.parse_args()

#################################

## Read in files
infile = open(


