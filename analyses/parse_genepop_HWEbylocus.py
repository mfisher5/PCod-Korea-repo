#### This script will take the output file from genepop's HWE by locus exact test (option 1 >>> 3) and create two files with 2x2 arrays to parse out the HWE p-value and the HWE Fis value per locus per population      ####

## at command line: python parse_genepop_HWEbylocus.py ARG1 ##
##---ARG



import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-p", "--P", help="path & name of .P file output from genepop")
parser.add_argument("-op", "--OUTPUTpval", help="path & name of the output file for the parsed HWE pvalues")
parser.add_argument("-of", "--OUTPUTfis", help="path & name of the output file for the parsed Fis values")
args = parser.parse_args()


### Create a list of populations
infile = open(args.P, "r")

loci = []
pops = []


for line in infile:
    if line.startswith("Locus"):
        locus = line.strip().split()[1]
        newlocus = locus.replace('"','')
        loci.append(newlocus)
infile.close()

### Create a list of loci
infile = open(args.P, "r")

for line in infile:
    if line.startswith(" Pop :"):
        newpop = line.strip().split()[2]
        pops.append(newpop)
infile.close()



### Create two dictionaries: one for all of the pvalues (locus is key, value is a list of pvalues) and one for all of the fis values (locus is key, value is a list of fis values). There are NAs in this list if "No Information" is written for a locus in any population. 

print "generating dictionaries of pvalues and fis values..."

infile = open(args.P, "r")


npops = 0

pvals_dict = {}
fis_dict = {}
whats_in_dict = []
for line in infile:
    linelist = line.strip().split()
    if len(linelist) > 1:
        first = linelist[0]
        if first in loci and first not in whats_in_dict: 
            linelist = line.strip().split()
            if len(linelist) > 4:
                new_pval = linelist[1]
                pvals_dict[first] = [new_pval]
                new_fis = linelist[3]
                fis_dict[first] = [new_fis]
            else:
                new_pval = "NA"
                new_fis = "NA"
                pvals_dict[first] = [new_pval]
                fis_dict[first] = [new_fis]
        if first in loci and first in whats_in_dict: 
            linelist = line.strip().split()
            if len(linelist) > 4:
                new_pval = linelist[1]
                new_fis = linelist[3]
                old_pvals = pvals_dict[first]
                old_pvals.append(new_pval)
                pvals_dict[first] = old_pvals
                old_fis = fis_dict[first]
                old_fis.append(new_fis)
                fis_dict[first] = old_fis
            else: 
                new_pval = "NA"
                new_fis = "NA"
                old_pvals = pvals_dict[first]
                old_pvals.append(new_pval)
                pvals_dict[first] = old_pvals
                old_fis = fis_dict[first]
                old_fis.append(new_fis)
                fis_dict[first] = old_fis
        whats_in_dict = pvals_dict.keys()
infile.close()



print "writing output to files..."
### write the pvalues to an output file, in a 2x2 array
outfile = open(args.OUTPUTpval, "w")

outfile.write("# parsed GENEPOP output, HWE p-values by locus by population. #\n")


for i in range(0,len(pops)): 
    pop = pops[i]
    newpop = pop.split("_")[0]
    pops[i] = newpop

pop_string = "\t".join(pops)

outfile.write("locus\t" + pop_string + "\t" + "Percent.Sig")


loci_list = pvals_dict.keys()
for locus in loci_list:
        pvalues = pvals_dict[locus]
        n_sig = 0
        count = 0
        for p in pvalues:
            count += 1
            if "NA" not in p:
                pval = float(p)
                if float(p) < float(0.05):
                    n_sig += 1
        percent_sig = float(n_sig)/float(count)
        pvalues_str = "\t".join(pvalues)
        outfile.write("\n"+locus + "\t" + pvalues_str + "\t"+ str(percent_sig))

outfile.close()



### write the fis values to an output file, in a 2x2 array
outfile2 = open(args.OUTPUTfis, "w")

outfile2.write("# parsed GENEPOP output, Fis values by locus by population. #\n")


for i in range(0,len(pops)): 
    pop = pops[i]
    newpop = pop.split("_")[0]
    pops[i] = newpop

pop_string = "\t".join(pops)

outfile2.write("locus\t" + pop_string)


loci_list = fis_dict.keys()
for locus in loci_list:
        fis_values = fis_dict[locus]
        fis_str = "\t".join(fis_values)
        outfile2.write("\n"+locus + "\t" + fis_str)

outfile2.close()

print "done."

