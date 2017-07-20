#### This script converts the FINAL filtered .csv document (corrected genotypes, MAF filtered, low coverage loci filtered, low coverage individuals filtered) into a genepop file format ####

## MF 12/13/2016
## Edited by MF 5/8/2017 for PCod Korea L1-4

## ARG1 : .csv file
## ARG2 : name of genepop file (must be .gen)
### Note -- LEAVE the "sample" header in the .csv file. Edit the correct title line AND the population indices in the script below. 
#############################################################################################

import sys
csvFile = open(sys.argv[1], "r")
genepop = open(sys.argv[2], "w")

# create a title for the genepop file
genepop.write("PCod Korea Lanes 1-4 final filtered genepop" + "\r\n")
 

# transpose the .csv file so that the loci are along the top row, and the individual names are in the first column
data_matrix = []

for line in csvFile:
    tmp_line = ''
    tmp_line += line
    data_matrix.append(tmp_line.split("\t"))

csvFile.close()
        
transposed = zip(*data_matrix)

#create loci list
locilist = transposed[0]
LociIndex = range(0, len(locilist))
for i in LociIndex: 
	if transposed[0][i] != "sample":
		genepop.write(transposed[0][i] + "\r\n")

#set range for populations. NOTE -- the end # must be the last column in that population + 1
#--- you can copy AND ADJUST the indices used in the file "Eleni_filter_by_MinorAlleleFrequency". Adjust by adding 1 to the end index in each pop

Pohang15 = transposed[1:32]
Geoje15 = transposed[32:65]
Namhae15 = transposed[65:81]
YellowSea16 = transposed[81:105]
Jukbyeon07 = transposed[105:130]
JinhaeBay07 = transposed[130:164]
JinhaeBay08 = transposed[164:194]
Boryeong07 = transposed[194:216]
Geoje14 = list(transposed[216:247])

last_line = list(transposed[247])

seq = range(0,len(last_line))
for i in seq: 
	last_line[i] = last_line[i].strip("\r\n")


	


genepop.write("Pop" + "\r\n")
for line in Pohang15: 
	linestr = "\t".join(line[1:])
	newline =  line[0] + ",\t" + linestr + "\r\n"
	genepop.write(newline)

genepop.write("Pop" + "\r\n")
for line in Geoje15: 
	newline =  line[0] + ",\t" + "\t".join(line[1:]) + "\r\n"
	genepop.write(newline)

genepop.write("Pop" + "\r\n")
for line in Namhae15: 
	newline =  line[0] + ",\t" + "\t".join(line[1:]) + "\r\n"
	genepop.write(newline)

genepop.write("Pop" + "\r\n")
for line in YellowSea16: 
	newline =  line[0] + ",\t" + "\t".join(line[1:]) + "\r\n"
	genepop.write(newline)

genepop.write("Pop" + "\r\n")
for line in Jukbyeon07: 
	newline =  line[0] + ",\t" + "\t".join(line[1:]) + "\r\n"
	genepop.write(newline)

genepop.write("Pop" + "\r\n")
for line in JinhaeBay07: 
	newline =  line[0] + ",\t" + "\t".join(line[1:]) + "\r\n"
	genepop.write(newline)
	
genepop.write("Pop" + "\r\n")
for line in JinhaeBay08: 
	newline =  line[0] + ",\t" + "\t".join(line[1:]) + "\r\n"
	genepop.write(newline)
	
genepop.write("Pop" + "\r\n")
for line in Boryeong07: 
	newline =  line[0] + ",\t" + "\t".join(line[1:]) + "\r\n"
	genepop.write(newline)
	
genepop.write("Pop" + "\r\n")
for line in Geoje14: 
	newline =  line[0] + ",\t" + "\t".join(line[1:]) + "\r\n"
	genepop.write(newline)

newline =  last_line[0] + ",\t" + "\t".join(last_line[1:])
genepop.write(newline)




genepop.close()
