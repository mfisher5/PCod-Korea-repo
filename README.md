# Pacific cod - South Korea Project

*initialized Feb. 2017*


<br>

The Korean peninsula is the southern edge of the Pacific cod's (*Gadus macrocephalus*) range in the western Pacific Ocean. Pacific cod used to be a productive domestic fishery for South Korea, but there have been recent declines and high variability in catch between fishing seasons. This has led to stock enhancement programs which release hatchery-raised juveniles and larvae. 

A better understanding of the genetic population structure of Pacific cod around the Korean peninsula can address two critical research needs of Korean fisheries management: (1) the correct way to subset the domestic fishery into separate stocks for assessment and policy, and (2) the creation of a quantitative genetic baseline (such as divergence between spawning aggregates, per aggregate heterozygosity, etc.) to allow for future monitoring of hatchery effects on the wild populations.
<br>
<br>
<br>
### Project Goal: Clarify population structure of Pacific cod spawning aggregates in South Korean waters 

Samples were taken across three spawning seasons (2007-2008, 2014-2015, 2015-2016 at various sampling sites around the Korean peninsula. Two of these sites have a temporal replicate. As of 4/24/2017, there were 276 samples from 2 sites on the western coast, 3 sites on the southern coast, one site on the southeastern coast, and one site on the eastern coast. 


<br>

<br>

### Repository Structure
<br>

[**nb_pictures**](https://github.com/mfisher5/PCod-Korea-repo/tree/master/nb_pictures) : pictures used in Jupyter notebooks. 
<br>

[**notebooks**](https://github.com/mfisher5/PCod-Korea-repo/tree/master/nb_pictures) : Jupyter notebooks containing information on raw data, stacks pipeline, filtering steps, and popgen analyses. See README within folder for description of notebooks. 
<br>

[**raw_data**](https://github.com/mfisher5/PCod-Korea-repo/tree/master/raw_data) : FastQC files with summary information for raw data files. 
<br>

[**reference_genome**](https://github.com/mfisher5/PCod-Korea-repo/tree/master/reference_genome) : A reference genome created from Lanes 1 and 2 samples, using bowtie. Mostly used as an exercise to learn how to generate a reference genome.
<br>

[**samplesT142**](https://github.com/mfisher5/PCod-Korea-repo/tree/master/samplesT142) : demultiplexed, quality filtered, and trimmed (from 151bp with barcode to 142bp without barcode) fastq files. Contains all samples from Lanes 1 and 4 (paired end) and Lanes 2 and 3 (single read).
<br>

[**scripts**](https://github.com/mfisher5/PCod-Korea-repo/tree/master/scripts) : various python / BASH scripts used in the stacks pipeline and filtering, as well as barcode files and population maps. 
<br>

[**stacks_wgenome**](https://github.com/mfisher5/PCod-Korea-repo/tree/master/stacks_wgenome) : output files from second run through of stacks with a reference database of loci, using `pstacks` instead of `ustacks`.
<br>
<br>

### Recent Progress: 

Currently working in [this Jupyter notebook](https://github.com/mfisher5/PCod-Korea-repo/blob/master/notebooks/Stacks%20batch%204%20-%20nb2.ipynb)
<br>

**Code Running**

I finished running cstacks through populations, and [created a reference genome](https://github.com/mfisher5/PCod-Korea-repo/blob/master/notebooks/Stacks%20batch%204%20-%20nb2.ipynb) using the cstacks catalog. I am currently aligning all of the individuals to the reference genome. As of 1:25PM on 5/3, 121 samples out of 264 samples had aligned.
<br>

**New Analyses Completed**

*5/3/2017*

Chose samples for cstacks: The samples with the highest number of tags are not necessarily those with the greatest number of reads. I will prioritize the number of tags per individual, but will also check the number of reads in those individual to make sure that it isn't too low (cutoff set at 3 million reads). If an individual is in the top ten lists for tags but has less than 3 million reads, I will replace that individual with the sample that has the 11th most tags, 12th most tags, etc.


Identified individuals that will need to be re-sequenced. There are 34 samples that have more than 20% of their genotypes missing in the genepop file produced by the first run-through of stacks. I also identified where these individuals fall on the read v. tags graph, which can be found [here](https://github.com/mfisher5/PCod-Korea-repo/blob/master/notebooks/Stacks%20batch%204%20-%20pipeline%20meristics.ipynb). One thing to note in the reads v. tags graph are the samples (from Yellow Sea and Boryeong)that have a normal number of reads and a ridiculously high number of tags (>60K tags). Theories on this include contamination from east coast samples, or degraded DNA quality. More info on that in [this notebook](https://github.com/mfisher5/PCod-Korea-repo/blob/master/notebooks/Stacks%20batch%204%20-%201.ipynb).



<br>

*4/27/2017*

I was able to look at the distribution of the number of tags per individual, broken down by population [this Jupyter notebook](https://github.com/mfisher5/PCod-Korea-repo/blob/master/notebooks/Stacks%20batch%204%20-%20pipeline%20meristics.ipynb). I used this distribution to highlight samples that may need to be re-sequenced (3 samples with less than 20K tags). All of these samples were in the Jinhae Bay population, which generally had low quantities of DNA.

With the read counts that I had (117 out of 276, or 4 populations), I compared the 10 samples with the greatest read depth and the most tags to see if they matched up. There was around a 50-60% match rate, so not as close as I thought (spreadsheet [here](https://github.com/mfisher5/PCod-Korea-repo/blob/master/pipeline_analyses/counts_readsVtags.xlsx)). For `cstacks`, I will prioritize the samples with the most tags, as long as they have average to above average read depth.


I also created a scatterplot of the number of tags against the number of reads. This was mostly driven by the presence of some Yellow Sea samples with more than 80K tags (look like outliers in [this scatterplot](https://github.com/mfisher5/PCod-Korea-repo/blob/master/nb_pictures/Batch4_PipelineMeristics_ustacks_tagCounts.png).  The Yellow Sea samples that had ridiculously high tag counts had relatively normal read counts. To explore this further, I'm planning on aligning fasta files from these individuals to a normal Yellow Sea individual and a normal east coast individual, looking for potential contamination. See my notes on this toward the end of [this notebook](https://github.com/mfisher5/PCod-Korea-repo/blob/master/notebooks/Stacks%20batch%204%20-%201.ipynb).
