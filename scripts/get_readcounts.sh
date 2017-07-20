#### This shell script will return read counts from fastq files out of process radtags ####

echo "Where are your Fastq files (local path please, without the last /)"
read DIRECTORY

echo "Did you do paired end or single read sequencing? [paired/single]"
read SEQ_TYPE

echo "are your files zipped? [yes/no]"
read GZIP

echo "Your data is $SEQ_TYPE"
if [ $GZIP = 'yes' ]; then
	echo "Your files are zipped."
else
	echo "Your files are not zipped."
fi


cd $DIRECTORY


if [[ $GZIP == 'yes' && $SEQ_TYPE == 'paired' ]]; then 
	fastq_file_array="$(find . -name '*.1.fq.gz')"
	for file in $fastq_file_array
	do
		printf "\n $file" >> FastQ_ReadDepth.txt
		zcat $file | awk '((NR-2)%4==0){read=$1;total++;count[read]++}END{for(read in count){if(!max||count[read]>max) {max=count[read];maxRead=read};if(count[read]==1){unique++}};print total}' >> FastQ_ReadDepth.txt
		echo "$file sequences counted."
	done
fi


if [[$GZIP == "yes" && $SEQ_TYPE == "single"]]; then 
	fastq_file_array="$(find . -name '*.fq.gz')"
	for file in $fastq_file_array
	do
		zcat $file | awk '((NR-2)%4==0){read=$1;total++;count[read]++}END{for(read in count){if(!max||count[read]>max) {max=count[read];maxRead=read};if(count[read]==1){unique++}};print total}' >> FastQ_ReadDepth.txt
	done
fi



