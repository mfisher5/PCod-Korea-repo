### This is part two of the script that will convert a 2x2 matrix file into a genepop file. It is automatically generated with part 1 #####


infile = open('../../stacks_b7_wgenome/batch_7.filteredLoci20_filteredMAF_filteredIndivids_filteredHWE.txt', 'r')
genepop = open('../../stacks_b7_wgenome/batch_7_filteredLoci20_filteredMAF_filteredIndivids_filteredHWE_genepop.txt', 'w')
genepop.write('PCod Korea Genepop, Lanes 1 -5 (all samples) Final Filtered\r\n')
print 'transposing genotypes matrix...'
data_matrix = []
for line in infile:
	tmp_line = ''
	tmp_line += line
	data_matrix.append(tmp_line.split('\t'))
infile.close()

transposed = zip(*data_matrix)

print 'writing loci into genepop file...'
locilist = transposed[0]
LociIndex = range(0, len(locilist))
for i in LociIndex:
	if transposed[0][i] != 'sample':
		genepop.write(transposed[0][i] + '\r\n')

Pohang15 = transposed[1:35]
Geoje15 = transposed[35:72]
Namhae15 = transposed[72:91]
YellowSea16 = transposed[91:120]
Jukbyeon07 = transposed[120:155]
JinhaeBay07 = transposed[155:199]
JinhaeBay08 = transposed[199:243]
Boryeong07 = transposed[243:266]
Geoje14 = transposed[266:299]
last_line = list(transposed[299])
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