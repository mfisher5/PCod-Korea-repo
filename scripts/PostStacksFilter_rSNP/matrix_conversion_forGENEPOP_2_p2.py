### This is part two of the script that will convert a 2x2 matrix file into a genepop file. It is automatically generated with part 1 #####


infile = open('../../stacks_b7_wgenome/batch_7.filteredLoci60_filteredMAF_Loci2_filteredIndivids', 'r')
genepop = open('../../stacks_b7_wgenome/batch_7_filteredLoci20_filteredMAF_filteredIndivids_genepop.txt', 'w')
genepop.write('PCod Korea batch 7, filtered for missing data in loci & individuals, MAF\r\n')
print 'transposing genotypes matrix...'
data_matrix = []
for line in infile:
	tmp_line = ''
	tmp_line += line
	data_matrix.append(tmp_line.strip().split(' '))
infile.close()

print 'writing loci into genepop file...'
locilist = data_matrix[0]
LociIndex = range(0, len(locilist))
for i in LociIndex:
	if data_matrix[0][i] != 'sample':
		genepop.write(data_matrix[0][i] + '\r\n')

Pohang15 = data_matrix[1:35]
Geoje15 = data_matrix[35:72]
Namhae15 = data_matrix[72:91]
YellowSea16 = data_matrix[91:120]
Jukbyeon07 = data_matrix[120:155]
JinhaeBay07 = data_matrix[155:199]
JinhaeBay08 = data_matrix[199:243]
Boryeong07 = data_matrix[243:266]
Geoje14 = data_matrix[266:299]
last_line = list(data_matrix[299])
seq = range(0, len(last_line))
for i in seq:
	last_line[i] = last_line[i].strip('\r\n')


print 'writing genotypes into genepop file by population...'
genepop.write('Pop' + '\r\n')
for line in Pohang15:
	linestr = '\t'.join(line[1:])
	newline = line[0] + ',\t' + linestr + '\r\n'
	genepop.write(newline)

genepop.write('Pop' + '\r\n')
for line in Geoje15:
	linestr = '\t'.join(line[1:])
	newline = line[0] + ',\t' + linestr + '\r\n'
	genepop.write(newline)

genepop.write('Pop' + '\r\n')
for line in Namhae15:
	linestr = '\t'.join(line[1:])
	newline = line[0] + ',\t' + linestr + '\r\n'
	genepop.write(newline)

genepop.write('Pop' + '\r\n')
for line in YellowSea16:
	linestr = '\t'.join(line[1:])
	newline = line[0] + ',\t' + linestr + '\r\n'
	genepop.write(newline)

genepop.write('Pop' + '\r\n')
for line in Jukbyeon07:
	linestr = '\t'.join(line[1:])
	newline = line[0] + ',\t' + linestr + '\r\n'
	genepop.write(newline)

genepop.write('Pop' + '\r\n')
for line in JinhaeBay07:
	linestr = '\t'.join(line[1:])
	newline = line[0] + ',\t' + linestr + '\r\n'
	genepop.write(newline)

genepop.write('Pop' + '\r\n')
for line in JinhaeBay08:
	linestr = '\t'.join(line[1:])
	newline = line[0] + ',\t' + linestr + '\r\n'
	genepop.write(newline)

genepop.write('Pop' + '\r\n')
for line in Boryeong07:
	linestr = '\t'.join(line[1:])
	newline = line[0] + ',\t' + linestr + '\r\n'
	genepop.write(newline)

genepop.write('Pop' + '\r\n')
for line in Geoje14:
	linestr = '\t'.join(line[1:])
	newline = line[0] + ',\t' + linestr + '\r\n'
	genepop.write(newline)

linestr = '	'.join(last_line[1:])
newline = last_line[0] + ',\t' + linestr + '\r\n'
genepop.write(newline)

genepop.close()

print 'done.'