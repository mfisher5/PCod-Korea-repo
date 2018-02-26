############ Running PERMANOVA on Otolith Data ##########
#
# MF 2/16/2018
# Korean PCod Project - Otolith Microchemistry dataset
#
#########################################################################


# Load packages -----------------------------------------------------------
library(vegan)

# Read in data ------------------------------------------------------------
## load data
setwd("/mnt/hgfs/PCod-Korea-repo/otolith_analyses")
PCod_Korea_Microchem_filtered <- read_delim("PCod_Korea_Microchem_filtered_bypop.txt","\t", escape_double = FALSE, trim_ws = TRUE)
odata <- PCod_Korea_Microchem_filtered
dim(odata)
View(odata)

## create new dataframe without sample IDs (just measurements)
odata_el <- odata[,2:17]
colnames(odata_el)

## new object of just sites / years
SamplingSite <- odata$SiteYear



# Review: PERMANOVA with 7 sample units -------------------------------------------------------
## -- The number of permutations possible is related to the number of sample units. 
nperm <- factorial(7); nperm
## -- The minimum p value possible is dictated by the number of permutations
min_pval <- 1/factorial(7); min_pval  



# PERMANOVA ---------------------------------------------------
## do elements vary significantly between sampling sites?
Bcore <- adonis2(odata_el ~ SamplingSite,
                 permutations = 999, method = "euclidean")
Bcore




# Pairwise Contrasts ------------------------------------------------------
## which sampling sites differ significantly from each other?

