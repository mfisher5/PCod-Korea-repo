
# script for Mary that will estimate average read depth per population per locus
# and compare it to Fis values (from a file Mary already has).
#
#
# population names in '-s' file and '-f' files must match
#

import argparse, sys

parser = argparse.ArgumentParser()
parser.add_argument("-s", "--samples", help="file containing samples to parse. each line contains 'sample pop'.")
parser.add_argument("-d", "--directory", help="directory containing 'matches' files.")
parser.add_argument("-o", "--output", help="output file.")
parser.add_argument("-f", "--fis_file", help="file containing Fis information.")

args = parser.parse_args()

sample_list_file = open(args.samples, 'r') # some file that has a list of the 'sample population'
matches_path = args.directory # directory of matches files






############################
# Read in matches files
dict_read_depth = {} # {pop: {locus:[depth, # ind]}} - a nested dictionary containing counts

for line in sample_list_file:

    tmp_sample = line.split()[0]
    tmp_pop = line.split()[1]

    sys.stdout.write("\rParsing sample: " + tmp_sample)
    sys.stdout.flush()

    tmp_matches_file = open(matches_path + '/' + tmp_sample + '.matches.tsv', 'r')

    if tmp_pop not in dict_read_depth:
        dict_read_depth[tmp_pop] = {}

    for matches_line in tmp_matches_file:
		if "sstacks" not in matches_line:
			tmp_locus = matches_line.split()[2]
			tmp_count = int(matches_line.split()[6])

			if tmp_locus in dict_read_depth[tmp_pop].keys():
				dict_read_depth[tmp_pop][tmp_locus][0] += tmp_count # count of the depth
				dict_read_depth[tmp_pop][tmp_locus][1] += 1 # count of # ind

			else:
				dict_read_depth[tmp_pop][tmp_locus] = [tmp_count, 1] # initialize count data


sample_list_file.close()


print '\n'




################################
# Process file with Fis values
fis_values = {} # {pop: {locus: Fis}} # a nested dictionary containing Fis values
fis_file = open(args.fis_file, 'r')
header = True

for line in fis_file:
    if header:
        header = False
    else:
        tmp_pop = line.split()[0]
        tmp_locus = line.split()[1]
        tmp_fis = line.split()[4] # this is Weir and Cockerham Fis

        if tmp_pop in fis_values.keys():
            fis_values[tmp_pop][tmp_locus] = tmp_fis
        else:
            fis_values[tmp_pop] = {}                
            fis_values[tmp_pop][tmp_locus] = tmp_fis

fis_file.close()


################################
# Process counts at each locus
output_file = open(args.output, 'w')
output_file.write('pop locus depth num_samples avg_depth fis\n')

for pop in dict_read_depth.keys(): # keys are population names
    for locus in dict_read_depth[pop].keys(): # keys here are loci
        if locus in fis_values[pop].keys(): 
            tmp_depth = dict_read_depth[pop][locus][0]
            tmp_num_samples = dict_read_depth[pop][locus][1]
            tmp_fis = fis_values[pop][locus]
            tmp_output = pop + ' ' + locus + ' ' + str(tmp_depth) + ' ' + str(tmp_num_samples) + ' ' + str(float(tmp_depth)/tmp_num_samples) + ' ' + tmp_fis + '\n'
            output_file.write(tmp_output)

output_file.close()




'''

F2_progeny_1174 pop1
F2_progeny_1176 pop1
F2_progeny_1177 pop2
F2_progeny_1180 pop2

'''


