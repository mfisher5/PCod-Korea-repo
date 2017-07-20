################################################################################
#
# parseGenepopINF.py - this is a script used to parse output files created
# by genepop
#
# 2017-March-21
# Daniel Drinan (ddrinan@uw.edu)
#
# population - HWE, He (INF), Ho (INF), Fis_wc (INF), Fis_RH (INF)
################################################################################

import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--INF", help=".INF file output from genepop (mutually exclusive to '-f')")
parser.add_argument("-f", "--FST", help=".FST file output from genepop (mutually exclusive to '-i')")
parser.add_argument("-s", "--SNP", help="SNP position is in the locus name", action='store_true')
parser.add_argument("-o", "--OUTPUT", help="name of output file")
args = parser.parse_args()


output_file = open(args.OUTPUT, 'w')


if args.INF: # this means it is an INF output file
    output_file.write('pop locus He Ho Fis_wc Fis_rh Fst position\n')

    input_file = open(args.INF, 'r')
    line = input_file.readline()

    while line:
        if line.startswith(' Pop: '):
            tmp_pop = line.split()[1]
            tmp_locus = line.split()[3]
            tmp_snp_position = 'NA'

            if args.SNP:
                tmp_snp_position = tmp_locus.split('_')[1]

            while 'homozygotes' not in line:
                line = input_file.readline()
            line = input_file.readline()

            tmp_obs_hom = float(line.split()[5]) # observed homozygotes
            line = input_file.readline()
            tmp_exp_het = float(line.split()[4]) # expected heterozygotes
            line = input_file.readline()
            tmp_obs_het = float(line.split()[4]) # observed heterozygotes

            while 'Tot' not in line:
                line = input_file.readline()

            tmp_fis_wc = line.split()[2]
            tmp_fis_rh = line.split()[3]

            tmp_output = tmp_pop + ' ' + tmp_locus + ' ' + \
                  str(tmp_exp_het/(tmp_obs_het+tmp_obs_hom)) + ' ' + \
                  str(tmp_obs_het/(tmp_obs_het+tmp_obs_hom)) + ' ' + \
                  str(tmp_fis_wc) + ' ' + str(tmp_fis_rh) + tmp_snp_position + '\n'

            output_file.write(tmp_output)

        line = input_file.readline()

else: # this means it is an FST output file
    input_file = open(args.FST, 'r')
    line = input_file.readline()
    output_file.write('locus fis fst fit snp_position\n')
    tmp_locus = ''
    tmp_fst = ''
    tmp_fis = ''
    tmp_fit = ''
    tmp_snp_position = 'NA'

    while line:

        if '  Locus: ' in line:
            tmp_locus = line.split()[1]
            if args.SNP:
                tmp_snp_position = tmp_locus.split('_')[1]

        elif 'Fis^=' in line:
            tmp_fis = line.split()[1]
        elif 'Fst^=' in line:
            tmp_fst = line.split()[1]
        elif 'Fit^=' in line:
            tmp_fit = line.split()[1]

            tmp_output = tmp_locus + ' ' + tmp_fis + ' ' + tmp_fst + ' ' + tmp_fit + ' ' + tmp_snp_position + '\n'
            output_file.write(tmp_output)
            tmp_locus = ''
            tmp_fst = ''
            tmp_fis = ''
            tmp_fit = ''
            tmp_snp_position = 'NA'

        line = input_file.readline()

input_file.close()
output_file.close()


