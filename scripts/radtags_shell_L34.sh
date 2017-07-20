#!/bin/bash

process_radtags -p /media/mfisher5/New\ Volume/Mary/Raw\ Data/Lane4 -P -i gzfastq -y fastq -o samplesT142 -b scripts/barcodes_L4.txt -e sbfI -E phred33 -r -c -q -t 142 2>> process_radtags_output_L4.txt
