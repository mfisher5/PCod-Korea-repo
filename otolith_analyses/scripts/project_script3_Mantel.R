######## RUN MANTEL TESTS ON RELATIVIZED OTOLITH DATA ############
#
# MF 2/25/2018
# for SEFS 502 Final Project
# 
#############################################################

## set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/otolith_analyses")


# Load data ---------------------------------------------------------------
odata <- read.csv("data/PCod_Korea_Microchem_filtered.txt", header=TRUE, sep="\t")
odata_ex <- read.csv("data/PCod_Korea_ExpData_filtered.txt", header=TRUE, sep="\t")

dim(odata)
dim(odata_ex)


# Load packages -----------------------------------------------------------
install.packages("vegan")
library(vegan)
install.packages("ggplot2")
library(ggplot2)
install.packages("dplyr")
library(dplyr)




# Manipulate data frames --------------------------------------------------
## need to make sure the order of the explanatory variables are the same as the element concentrations
odata_combo <- full_join(x=odata,y=odata_ex,by="Sample") 
odata_combo <- mutate(odata_combo, SiteYear=paste(Sampling.Site,Year,sep="_")) # add column with site & year
head(odata_combo)
odata_el <- odata_combo[,2:17]
head(odata_el)


# Relativize by maximum ---------------------------------------------------
odata_el.mrel <- decostand(odata_el, method="max")
head(odata_el.mrel)




# Make edge / core data frames --------------------------------------------
odata_edge.mrel <- odata_el.mrel[,9:16]
head(odata_edge)
odata_core.mrel <- odata_el.mrel[,1:8]
head(odata_core)




# Mantel Test: edge v. core -----------------------------------------------
## create dissimilarity matrices from data
edge.mrel_dist <- dist(odata_edge.mrel, method = "euclidean")
core.mrel_dist <- dist(odata_core.mrel, method = "euclidean")



## run Mantel test
odata_mantel <- mantel(xdis = edge.mrel_dist, ydis = core.mrel_dist,
                       method = "pearson", permutations = 99999)
odata_mantel

#Mantel r = 0.3372 
#signficance = 1e-5; Tells us that 1 / 100,000 permutations had an r statistic greater than 0.3372
#Upper quantiles of permutations (null model):
#  90%    95%  97.5%    99% 
#  0.0629 0.0830 0.1007 0.1217 

str(odata_mantel)













