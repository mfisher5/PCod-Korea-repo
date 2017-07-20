###### Generate Shell Script to Align all FastQ Data Files to BOWTIE ref genome ######

## MF 3/9/2017
## Edited 3/29/2017 for Korean Cod Data



## At Command Line: python cstacks_populations_genShell_3-8 ARG1 ARG2
##---- ARG1 = complete sample list file
##---- ARG2 = relative path to bowtie ref database, including file name without filetype suffix
##---- ARG3 = relative path to stacks fastq files, output from process_radtags
##---- ARG4 = batch #

## Change path to fastq files on line 31

############################################################################


import sys
sampfilename = sys.argv[1]
path = sys.argv[2]
fastq_path = sys.argv[3]
batch = sys.argv[4]

samples = open(sampfilename, "r")
shell = open("RefGenome_BOWTIEalign_batch" + batch + ".sh", "w")

shell.write("#!/bin/bash\n\n")


shell.write("cd ../L1L2samplesT142\necho 'finding all gzipped fastq files'\ntags_file_array=" + '"' +"$(find . -name '*.fq.gz')"+ '"'+"\n")
shell.write("echo 'unzipping all fastq files'\nfor file in $tags_file_array\ndo\n\techo $file\n\tgzip -d $file\n\techo 'file unzipped'\ndone\n\n")
shell.write("cd ../scripts\n\n")


for line in samples: 
	sample = line.strip().split()[0]
	newstr = "bowtie -q -v 3 -norc --sam " + path + " " + fastq_path + "/" + sample + ".fq " + sample + ".sam"
	shell.write(newstr + "\n")

samples.close()
shell.close()
