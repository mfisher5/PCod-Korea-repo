#!/bin/bash
### This shell script will create the fasta file for BOWTIE, and then run BOWTIE for you ###
## M.Fisher 2/11/2017


echo 'Before running running this script, please be sure that you have the following:'
echo ''
echo '1. BLAST installed to run from any folder'
echo ''
echo '2. A single folder containing (1) stacks populations output, and (2) bowtie'
echo ''
echo '3. These additional python scripts: (1) genBOWTIEfasta_fromGENEPOP.py, (2) parseBowtie_DD.py, (3) checkBlastResults_DD.py'
echo ''
echo 'Are you ready for the script to run?'
read ANSWER
if [ $ANSWER == 'no' ]; then
	exit 1
fi
echo 'Is your catalog.tags.tsv file zipped? [yes / no]'
read ZIPPED
if [ $ZIPPED == 'yes' ]; then
	gzip -d /mnt/hgfs/Pacific\ cod/DataAnalysis/L1L2stacks_m10/batch_1.catalog.tags.tsv.gz
fi

#generate the fasta file for bowtie
python /mnt/hgfs/Pacific\ cod/DataAnalysis/scripts/genBOWTIEfasta_fromGENEPOP.py /mnt/hgfs/Pacific\ cod/DataAnalysis/L1L2stacks_m10/batch_1.genepop /mnt/hgfs/Pacific\ cod/DataAnalysis/L1L2stacks_m10/batch_1.catalog.tags.tsv
echo '---'
echo 'We will now filter with BOWTIE.'
echo ''
mv seqsforBOWTIE.fa /mnt/hgfs/Pacific\ cod/DataAnalysis/L1L2stacks_m10/seqsforBOWTIE.fa

# build a bowtie catalog
cd /mnt/hgfs/Pacific\ cod/DataAnalysis/L1L2stacks_m10

bowtie-build seqsforBOWTIE.fa batch_1

bowtie -f -v 3 --sam --sam-nohead batch_1 seqsforBOWTIE.fa batch_1_BOWTIEout.sam


# parse out only good loci using Dan's script
echo 'parsing out only good loci from BOWTIE filtering...'
cd /mnt/hgfs/Pacific\ cod/DataAnalysis/scripts/shell

python /mnt/hgfs/Pacific\ cod/DataAnalysis/scripts/parseBowtie_DD.py /mnt/hgfs/Pacific\ cod/DataAnalysis/L1L2stacks_m10/batch_1_BOWTIEout.sam /mnt/hgfs/Pacific\ cod/DataAnalysis/L1L2stacks_m10/batch_1_BOWTIEout_filtered.fa

# BLAST filtering
echo 'creating BLAST database...'
cd /mnt/hgfs/Pacific\ cod/DataAnalysis/L1L2stacks_m10
makeblastdb -in batch_1_BOWTIEout_filtered.fa -parse_seqids -dbtype nucl -out batch_1_BOWTIEfilteredDB

echo 'querying database...'

blastn -query batch_1_BOWTIEout_filtered.fa -db batch_1_BOWTIEfilteredDB -out batch_1_BOWTIEout_BLASTout


# filter out blast results
echo 'parsing out only good loci from BLAST filtering...'
cd /mnt/hgfs/Pacific\ cod/DataAnalysis/scripts/shell

python /mnt/hgfs/Pacific\ cod/DataAnalysis/scripts/checkBlastResults_DD.py /mnt/hgfs/Pacific\ cod/DataAnalysis/L1L2stacks_m10/batch_1_BOWTIEout_BLASTout /mnt/hgfs/Pacific\ cod/DataAnalysis/L1L2stacks_m10/batch_1_BOWTIEout_filtered.fa /mnt/hgfs/Pacific\ cod/DataAnalysis/L1L2stacks_m10/batch_1_BOWTIEout_BLASTout_filtered.fa /mnt/hgfs/Pacific\ cod/DataAnalysis/L1L2stacks_m10/batch_1_BOWTIEout_BLASTout_bad.fa

echo ''
echo 'Number of loci in reference file:'
grep -c '^>' batch_1_BOWTIEout_BLASTout_filtered.fa
echo ''


# create final SAM file
echo 'Creating final SAM file of the reference database of loci...'
cd /mnt/hgfs/Pacific\ cod/DataAnalysis/L1L2stacks_m10

bowtie-build batch_1_BOwTIEout_BLASTout_filtered.fa batch_1_ref_genome

echo 'Reference genome created.'