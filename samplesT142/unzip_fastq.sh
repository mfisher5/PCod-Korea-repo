#!/bin/bash

sample_array=`cat ../scripts/L5_sampleList.txt`

echo '--'
echo 'unzipping files...'

for file in $sample_array
do
	echo $file
	gzip -d $file.fq.gz
	echo 'file unzipped'
done