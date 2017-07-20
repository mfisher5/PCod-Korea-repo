barcodes = open("barcodesL1.txt", "r")
newshell = open("mvL1samples.sh", "w")

newshell.write("#!/bin/bash\n\n")

for line in barcodes:
	newshell.write("mv " + line.strip().split()[1] + ".1.fq.gz Lane1/" + line.strip().split()[1] + ".1.fq.gz\n")
	newshell.write("mv " + line.strip().split()[1] + ".2.fq.gz Lane1/" + line.strip().split()[1] + ".2.fq.gz\n")

newshell.close()
barcodes.close()
