#!/bin/bash

cd ../samplesT92
echo 'finding all gzipped fastq files'
tags_file_array="$(find . -name '*.fq.gz')"
echo 'unzipping all fastq files'
for file in $tags_file_array
do
	echo $file
	gzip -d $file
	echo 'file unzipped'
done

cd ../scripts

bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO010715_06.1.fq PO010715_06.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO010715_27.1.fq PO010715_27.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO010715_28.1.fq PO010715_28.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO010715_29.1.fq PO010715_29.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO020515_05.1.fq PO020515_05.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO020515_09.1.fq PO020515_09.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO020515_10.1.fq PO020515_10.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO010715_19.1.fq PO010715_19.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO031715_20.1.fq PO031715_20.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO020515_03.1.fq PO020515_03.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO020515_08.1.fq PO020515_08.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO010715_11.1.fq PO010715_11.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO020515_16.1.fq PO020515_16.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO020515_17.1.fq PO020515_17.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO010715_17.1.fq PO010715_17.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO020515_15.1.fq PO020515_15.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO010715_10.1.fq PO010715_10.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO031715_13.1.fq PO031715_13.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO010715_08.1.fq PO010715_08.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO020515_14.1.fq PO020515_14.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO020515_06.fq PO020515_06.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO031715_23.fq PO031715_23.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO031715_03.fq PO031715_03.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO010715_04.fq PO010715_04.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO020515_01.fq PO020515_01.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO031715_04.fq PO031715_04.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO031715_24.fq PO031715_24.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/PO010715_12.fq PO010715_12.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_08.1.fq GE011215_08.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_09.1.fq GE011215_09.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_14.1.fq GE011215_14.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_15.1.fq GE011215_15.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_10.1.fq GE011215_10.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE012315_01.1.fq GE012315_01.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_07.1.fq GE011215_07.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_16.1.fq GE011215_16.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_29.1.fq GE011215_29.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE012315_03.1.fq GE012315_03.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE012315_22.1.fq GE012315_22.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE012315_04.1.fq GE012315_04.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE012315_05.1.fq GE012315_05.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE012315_06.1.fq GE012315_06.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_20.1.fq GE011215_20.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_21.1.fq GE011215_21.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_30.1.fq GE011215_30.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_01.1.fq GE011215_01.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_24.1.fq GE011215_24.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE012315_08.1.fq GE012315_08.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE012315_09.1.fq GE012315_09.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE012315_10.1.fq GE012315_10.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE012315_11.1.fq GE012315_11.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE012315_17.1.fq GE012315_17.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE012315_20.1.fq GE012315_20.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO012315_02.fq GEO012315_02.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO012315_12.fq GEO012315_12.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO012315_18.fq GEO012315_18.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO012315_21.fq GEO012315_21.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_18.fq GE011215_18.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_22.fq GE011215_22.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_19.fq GE011215_19.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GE011215_28.fq GE011215_28.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_16.1.fq NA021015_16.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_21.1.fq NA021015_21.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_02.1.fq NA021015_02.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_03.1.fq NA021015_03.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_08.1.fq NA021015_08.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_13.1.fq NA021015_13.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_10.1.fq NA021015_10.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_17.1.fq NA021015_17.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_22.1.fq NA021015_22.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_14.1.fq NA021015_14.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_06.1.fq NA021015_06.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_09.1.fq NA021015_09.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_23.fq NA021015_23.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_25.fq NA021015_25.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_26.fq NA021015_26.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/NA021015_30.fq NA021015_30.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/YS121315_08.1.fq YS121315_08.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/YS121315_10.1.fq YS121315_10.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/YS121315_14.1.fq YS121315_14.1.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/YS121315_12.fq YS121315_12.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/YS121315_15.fq YS121315_15.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/YS121315_16.fq YS121315_16.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/YS121315_12_300.fq YS121315_12_300.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/BOR07_01.fq BOR07_01.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/BOR07_03.fq BOR07_03.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/BOR07_09.fq BOR07_09.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_8.fq GEO020414_8.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_9.fq GEO020414_9.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_11.fq GEO020414_11.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_13.fq GEO020414_13.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_14.fq GEO020414_14.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_15.fq GEO020414_15.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_16.fq GEO020414_16.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_17.fq GEO020414_17.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_23.fq GEO020414_23.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_24.fq GEO020414_24.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_25.fq GEO020414_25.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_3.fq GEO020414_3.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_4.fq GEO020414_4.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_5.fq GEO020414_5.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_6.fq GEO020414_6.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_27.fq GEO020414_27.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_29.fq GEO020414_29.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_2.fq GEO020414_2.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_26.fq GEO020414_26.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_7.fq GEO020414_7.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_10.fq GEO020414_10.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_30.fq GEO020414_30.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_8_300.fq GEO020414_8_300.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_9_300.fq GEO020414_9_300.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_11_300.fq GEO020414_11_300.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_13_300.fq GEO020414_13_300.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_14_300.fq GEO020414_14_300.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_15_300.fq GEO020414_15_300.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_16_300.fq GEO020414_16_300.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_17_300.fq GEO020414_17_300.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_23_300.fq GEO020414_23_300.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_24_300.fq GEO020414_24_300.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/GEO020414_25_300.fq GEO020414_25_300.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/SO022216_01.fq SO022216_01.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/MU011816_01.fq MU011816_01.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/MU012816_05.fq MU012816_05.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/MU012816_06.fq MU012816_06.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/MU012816_07.fq MU012816_07.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/MU012816_08.fq MU012816_08.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/MU012816_09.fq MU012816_09.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/MU012816_10.fq MU012816_10.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/MU032315_01.fq MU032315_01.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/MU032315_02.fq MU032315_02.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/MU033015_02.fq MU033015_02.sam
bowtie -q -v 3 -norc --sam ../reference_genome/batch_3_ref_genome ../L1L2samplesT142/MU033015_03.fq MU033015_03.sam
