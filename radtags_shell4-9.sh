#!/bin/bash

process_radtags -f /media/mfisher5/New\ Volume/Mary/Raw\ Data/768_768_S99_L002_R1_001.fastq.gz -i gzfastq -y fastq -o samplesT142 -b scripts/barcodesL2.txt -e sbfI -E phred33 -r -c -q -t 142 2>> process_radtags_output_L2.txt

process_radtags -f /media/mfisher5/New\ Volume/Mary/Raw\ Data/994_S1_L001_R1_001.fastq.gz -i gzfastq -y fastq -o samplesT142 -b scripts/barcodes_L3.txt -e sbfI -E phred33 -r -c -q -t 142 2>> process_radtags_output_L3.txt


process_radtags -p /media/mfisher5/New\ Volume/Mary/Raw\ Data/Lane4 -P -i gzfastq -y fastq -o samplesT142 -b scripts/barcodes_L4.txt -e sbfI -E phred33 -r -c -q -t 142 2>> process_radtags_output_L4.txt
