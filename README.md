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

[**samplesT142**](https://github.com/mfisher5/PCod-Korea-repo/tree/master/samplesT142) : demultiplexed, quality filtered, and trimmed (from 151bp with barcode to 142bp without barcode) fastq files. Contains all samples from Lanes 1 and 4 (paired end) and Lanes 2 and 3 (single read).
<br>

[**scripts**](https://github.com/mfisher5/PCod-Korea-repo/tree/master/scripts) : various python / BASH scripts used in the stacks pipeline and filtering, as well as barcode files and population maps. 
<br>

**Not Shown on Github:** folders with stacks output files from `ustacks` to `populations`, for runs without and with a *de novo* reference database of loci. 

<br>
<br>

### Recent Progress: 

Currently working in [this Jupyter notebook](https://github.com/mfisher5/PCod-Korea-repo/blob/master/notebooks/Stacks%20Batch%207%20-%20nb%201.ipynb)
<br>

**Code Running**

I recently received the sequencing data for the last lane of samples (n = 70) from the Oregon CORE facility. I am currently running `process_radtags` and `ustacks` on this lane. I will then begin batch 7 of stacks, which will include all of the samples from lanes 1 through 5.
<br>