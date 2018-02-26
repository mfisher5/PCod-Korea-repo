######## RUN PERMANOVA ON RELATIVIZED OTOLITH DATA ############
#
# MF 2/25/2018
# for SEFS 502 Final Project
# 
#############################################################

## set working directory
setwd("C:/Users/mcfish/SEFS_502")


# Load data ---------------------------------------------------------------
odata <- read.csv("data/PCod_Korea_Microchem_filtered.txt", header=TRUE, sep="\t")
odata_ex <- read.csv("data/PCod_Korea_ExpData_filtered.txt", header=TRUE, sep="\t")

dim(odata)
dim(odata_ex)


# Load packages -----------------------------------------------------------
install.packages("vegan"); library(vegan)
install.packages("dplyr"); library(dplyr)



# Manipulate data frames --------------------------------------------------
## need to make sure the order of the explanatory variables are the same as the element concentrations
odata_combo <- full_join(x=odata,y=odata_ex,by="Sample") 
head(odata_combo)

## make data frame of only edge concentrations
odata_edge <- odata[,10:17]
head(odata_edge)



# Relativize by maximum ---------------------------------------------------

## determine effect of relativization
CV <- function(x){100*sd(x) / mean(x)}
CV(colSums(odata_edge)) #CV = 274.4344

## relative by column maxima
odata_edge.mrel <- decostand(odata_edge, method="max")
## make sure relativization worked
head(odata_edge.mrel)



# Run PERMANOVAs on Edge data -----------------------------------------------------------

## PERMANOVA: site & year effect on full microchemical fingerprint
odata_combo <- mutate(odata_combo, SiteYear=paste(Sampling.Site,Year,sep="_")) # add column with site & year
site_year <- odata_combo$SiteYear # create vector of new column

odata_siteyear.res <- adonis2(odata_edge.mrel ~ site_year,
                              permutations = 99999, method = "euc")
odata_siteyear.res #1e-05 ***





###########################################################################################
## PERMANOVA: sampling site effect on full microchemical fingerprint
sites <- odata_combo$Sampling.Site # create vector of sampling sites
odata_sites.res <- adonis2(odata_edge.mrel ~ sites,
                       permutations = 99999, method = "euc")
odata_sites.res


## PERMANOVA: year effect on full microchemical fingerprint
years <- odata_combo$Year # create vector of year
odata_years.res <- adonis2(odata_edge.mrel ~ years,
                     permutations = 99999, method = "euc")
odata_years.res



