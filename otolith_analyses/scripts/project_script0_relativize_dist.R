######## FIRST SCRIPT FOR PROJECT: RELATIVIZE DATA, MANIPULATE DATA FRAMES ############
#
# MF 2/25/2018
# for SEFS 502 Final Project
# !IMPORTANT: run this script before any others. objects used in this script are used throughout remaining scripts. 
# 
#######################################################################################



## set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/otolith_analyses")


# Load packages -----------------------------------------------------------
install.packages("vegan"); library(vegan)
install.packages("dplyr"); library(dplyr)


# Read in data ------------------------------------------------------------
## response matrix
library(readr)
odata <- read_delim("data/PCod_Korea_Microchem_filtered.txt","\t", escape_double = FALSE, trim_ws = TRUE)
dim(odata)

## explanatory data frame
odata_ex <- read_delim("data/PCod_Korea_ExpData_filtered.txt","\t", escape_double = FALSE, trim_ws = TRUE)
dim(odata_ex)



# Manipulate data frames --------------------------------------------------
## need to make sure the order of the explanatory variables are the same as the element concentrations
odata_combo <- full_join(x=odata,y=odata_ex,by="Sample") 
odata_el <- odata_combo[,2:17]
View(odata_el)

## add extra column that combines "Site" and "Year" variables
odata_combo <- mutate(odata_combo, SiteYear = paste(Sampling.Site, Year, sep="_"))
View(odata_combo)



# Relativize by maximum ---------------------------------------------------

## determine effect of relativization
CV <- function(x){100*sd(x) / mean(x)}
CV(colSums(odata_el)) #CV = 264.4698

## relative by column maxima
odata_el.mrel <- decostand(odata_el, method="max")
## make sure relativization worked
head(odata_el.mrel)
par(mfrow=c(2,4))
boxplot(odata_el.mrel$B11.e, main = "B11.e")
boxplot(odata_el.mrel$Ba138.e, main = "Ba138.e")
boxplot(odata_el.mrel$Li7.e, main = "Li7.e")
boxplot(odata_el.mrel$Mg24.e, main = "Mg24.e")
boxplot(odata_el.mrel$Mn55.e, main = "Mn55.e")
boxplot(odata_el.mrel$Pb208.e, main = "Pb208.e")
boxplot(odata_el.mrel$Sr88.e, main = "Sr88.e")
boxplot(odata_el.mrel$Zn66.e, main = "Zn66.e")
write.csv(odata_el.mrel, file = "data/PCod_Korea_Microchem_edge_filtered_relativized.csv", row.names=FALSE)
par(mfrow=c(1,1))



# Make edge / core data frames --------------------------------------------
odata_edge.mrel <- odata_el.mrel[,9:16] # only edge measurements
head(odata_edge.mrel)
odata_core.mrel <- odata_el.mrel[,1:8] # only core measurements
head(odata_core.mrel)




# Euclidean Distance Matrix -----------------------------------------------
edge.mrel_dist <- dist(odata_edge.mrel, method = "euclidean")
core.mrel_dist <- dist(odata_core.mrel, method = "euclidean")



