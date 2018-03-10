########################### PLOTS FOR INDIVIDUALS ######################
#
# MF 3/9/2018
#
# Exploratory plots of individual data - Ho, missing data, filtering, 
#
#
###########################################################################

setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses/exploratory_plots")

## read in data
library(readr)
mydata <- read_delim("batch_8_verif_individuals.txt", "\t", escape_double = FALSE, trim_ws = TRUE)
head(mydata)

## install packages
install.packages("ggplot2")
library(ggplot2)



## plot het v. read depth
ggplot(mydata, aes(read_depth, prop_het, col=as.factor(rem_ho))) +
  geom_point(size = 2) +
  labs(x="Read Depth", y="Observed Heterozygosity")
  

ggplot(mydata, aes(read_depth, prop_het, col=p_missing_genos)) +
  geom_point(size=2)


## plot het v. missing data

ggplot(mydata, aes(p_missing_genos, prop_het, col=as.factor(rem_ho))) +
  geom_point(size = 2) +
  labs(x="% Genotypes Missing", y="Observed Heterozygosity")
       