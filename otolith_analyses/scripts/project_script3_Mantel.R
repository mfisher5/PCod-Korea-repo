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

## make data frame of only edge concentrations
odata_edge <- odata[,10:17]
head(odata_edge)

## make data frame of only core concentrations
odata_core <- odata[2:10]
head(odata_core)


# Relativize by maximum ---------------------------------------------------
odata_edge.mrel <- decostand(odata_edge, method="max")
head(odata_edge.mrel)

odata_core.mrel <- decostand(odata_core,method="max")
head(odata_core.mrel)


# Mantel Test: edge v. core -----------------------------------------------
## create dissimilarity matrices from data
edge.mrel_dist <- dist(odata_edge.mrel, method = "euclidean")
core.mrel_dist <- dist(odata_core.mrel, method = "euclidean")



## run Mantel test
odata_mantel <- mantel(xdis = edge.mrel_dist, ydis = core.mrel_dist,
                       method = "pearson", permutations = 99999)
odata_mantel

#Mantel r = 0.5028
#signficance = 1e-5; Tells us that 1 / 100,000 permutations had an r statistic greater than 0.5028

str(odata_mantel)













