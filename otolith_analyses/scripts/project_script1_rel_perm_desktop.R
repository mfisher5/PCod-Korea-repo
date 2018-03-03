######## RUN PERMANOVA ON RELATIVIZED OTOLITH DATA ############
#
# MF 2/25/2018
# for SEFS 502 Final Project
# 
#############################################################

## set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/otolith_analyses")


# Load data ---------------------------------------------------------------
odata <- read.csv("data/PCod_Korea_Microchem_filtered_edit.txt", header=TRUE, sep="\t")
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
odata_el <- odata_combo[,2:17]
head(odata_el)



# Relativize by maximum ---------------------------------------------------

## determine effect of relativization
CV <- function(x){100*sd(x) / mean(x)}
CV(colSums(odata_el)) #CV = 264.4698

## relative by column maxima
odata_el.mrel <- decostand(odata_el, method="max")
## make sure relativization worked
head(odata_el.mrel)

## make data frame of only edge concentrations
odata_edge <- odata_el.mrel[,9:16]
head(odata_edge)
odata_core <- odata_el.mrel[,1:8]
head(odata_core)



# Run PERMANOVAs on Edge data -----------------------------------------------------------

## PERMANOVA: site & year effect on full microchemical fingerprint
odata_combo <- mutate(odata_combo, SiteYear=paste(Sampling.Site,Year,sep="_")) # add column with site & year
site_year <- odata_combo$SiteYear # create vector of new column

odata_siteyear.res <- adonis2(odata_edge ~ site_year,
                              permutations = 99999, method = "euc")
odata_siteyear.res #1e-05 ***




# Run ANOVAs for each element ---------------------------------------------
edge_bysite <- cbind(odata_edge, SiteYear = odata_combo$SiteYear)
head(edge_bysite)

## B11

## Ba
Ba.ln <- log(edge_bysite$Ba138.e)
anova <- aov(Ba.ln ~ SiteYear, data = edge_bysite)
summary(anova)

## Li

## Mg24
Mg.ln <- log(edge_bysite$Mg24.e)
anova <- aov(Mg.ln ~ SiteYear, data = edge_bysite)
summary(anova)

## Mn55

## Pb208

## Sr88
anova <- aov(Sr88.e ~ SiteYear, data = edge_bysite)
summary(anova)

## Zn66
Zn.ln <- log(edge_bysite$Zn66.e)
anova <- aov(Zn.ln ~ SiteYear, data = edge_bysite)
summary(anova)











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



