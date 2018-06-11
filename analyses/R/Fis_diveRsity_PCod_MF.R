# Purpose: getting Fis per population, Fit per locus
#
#From: Mary 10/27/2017
#
#
#
# ---------------------------------------------------------------------------------

# Import these libraries
install.packages("diveRsity")
install.packages("adegenet")
library("diveRsity")
library("adegenet")
library(dplyr)


# Set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses")


# diveRsity ---------------------------------------------------------------
# Calculate basic descriptive population parameters from a genepop genotype file: Fis per population
mydata_stats <- basicStats(infile = "../stacks_b8_verif/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredCR.gen")
str(mydata_stats)




# Heterozygosity ---------------------------------------------------------
mydata_het <- mydata_stats$obs_het

pops <- colnames(mydata_het)[2:length(colnames(mydata_het))]

colMeans(mydata_het[,2:length(colnames(mydata_het))])


### If you run option 5 >> suboption 2 in genepop (.DIV output file), the `1-Qintra` estimate across all loci should equal colMeans output ###

# Test for Statistical significance between groups
## is data normal?
hist(mydata_het$YS_121316_01) #nope!
hist(mydata_het$BOR07_02.1) #also no

## Wilcoxon Rank Sum test, to determine if two data sets come from the same population (have similar distributions)
library(reshape2)
mydata_het_melted <- melt(mydata_het)
west_het_melted <- filter(mydata_het_melted, variable %in% c("YS_121316_01","BOR07_02.1"))
unique(west_het_melted$variable)
wilcox.test(value ~ variable, data = west_het_melted)




# Fis ---------------------------------------------------------------------

mydata_fis <- mydata_stats$fis
# Test for Statistical significance between groups
## is data normal?
hist(mydata_fis$YS_121316_01) #nope!
hist(mydata_fis$BOR07_02.1) #also no

## Wilcoxon Rank Sum test, to determine if two data sets come from the same population (have similar distributions)
library(reshape2)
mydata_fis_melted <- melt(mydata_fis)
west_fis_melted <- filter(mydata_fis_melted, variable %in% c("YS_121316_01","BOR07_02.1"))
unique(west_fis_melted$variable)
wilcox.test(value ~ variable, data = west_fis_melted)



# Adegenet ----------------------------------------------------------------

mydata <-read.genepop("../stacks_b8_verif/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredCR.gen")
mydata_summary <- summary(mydata)
str(mydata_summary)





