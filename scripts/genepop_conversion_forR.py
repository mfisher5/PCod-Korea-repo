#### This script converts the FINAL filtered .csv document (corrected genotypes, MAF filtered, low coverage loci filtered, low coverage individuals filtered) into a genepop file format ####

## MF 12/13/2016

## ARG1 : .csv file
## ARG2 : name of genepop file (must be .gen)
### Note -- LEAVE the "sample" header in the .csv file. Edit the correct title line AND the population indices in the script below. 
#############################################################################################

import sys
csvFile = open(sys.argv[1], "r")
genepop = open(sys.argv[2], "w")

# create a title for the genepop file
genepop.write("PCod sequencing Lanes 1 and 2 final filtered genepop" + "\r\n")
 

# transpose the .csv file so that the loci are along the top row, and the individual names are in the first column
data_matrix = []

for line in csvFile:
    tmp_line = ''
    tmp_line += line
    data_matrix.append(tmp_line.split(","))

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
Pohang = transposed[1:29]
Geoje15 = transposed[29:62]
Namhae = transposed[62:78]
YellowSea = transposed[78:85]
Boryeong = transposed[85:88]
Geoje14 = transposed[88:120]
SocMuk = list(transposed[120])
seq = range(0,len(SocMuk))
for i in seq: 
	SocMuk[i] = SocMuk[i].strip("\r\n")


genepop.write("Pop" + "\r\n")
for line in Pohang: 
	linestr = "\t".join(line[1:])
	newline =  line[0] + ",\t" + linestr + "\r\n"
	genepop.write(newline)

genepop.write("Pop" + "\r\n")
for line in Geoje15: 
	newline =  line[0] + ",\t" + "\t".join(line[1:]) + "\r\n"
	genepop.write(newline)

genepop.write("Pop" + "\r\n")
for line in Namhae: 
	newline =  line[0] + ",\t" + "\t".join(line[1:]) + "\r\n"
	genepop.write(newline)

genepop.write("Pop" + "\r\n")
for line in YellowSea: 
	newline =  line[0] + ",\t" + "\t".join(line[1:]) + "\r\n"
	genepop.write(newline)

genepop.write("Pop" + "\r\n")
for line in Boryeong: 
	newline =  line[0] + ",\t" + "\t".join(line[1:]) + "\r\n"
	genepop.write(newline)

genepop.write("Pop" + "\r\n")
for line in Geoje14: 
	newline =  line[0] + ",\t" + "\t".join(line[1:]) + "\r\n"
	genepop.write(newline)

genepop.write("Pop" + "\r\n")
newline =  SocMuk[0] + ",\t" + "\t".join(SocMuk[1:])
genepop.write(newline)




genepop.close()
