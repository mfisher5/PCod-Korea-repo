######## RUN NMDS ON RELATIVIZED OTOLITH DATA ############
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
install.packages("devtools")
devtools::install_github("gavinsimpson/ggvegan")
library(ggvegan)
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


# Relativize by maximum ---------------------------------------------------
odata_edge.mrel <- decostand(odata_edge, method="max")
head(odata_edge.mrel)
par(mfrow=c(2,4))
boxplot(odata_edge.mrel$B11.e, main = "B11.e")
boxplot(odata_edge.mrel$Ba138.e, main = "Ba138.e")
boxplot(odata_edge.mrel$Li7.e, main = "Li7.e")
boxplot(odata_edge.mrel$Mg24.e, main = "Mg24.e")
boxplot(odata_edge.mrel$Mn55.e, main = "Mn55.e")
boxplot(odata_edge.mrel$Pb208.e, main = "Pb208.e")
boxplot(odata_edge.mrel$Sr88.e, main = "Sr88.e")
boxplot(odata_edge.mrel$Zn66.e, main = "Zn66.e")
write.csv(odata_edge.mrel, file = "data/PCod_Korea_Microchem_edge_filtered_relativized.csv", row.names=FALSE)




# Find optimal value of K for NMDS --------------------------------------------------------------------
## how many unique site / year combos?
unique(odata_combo$SiteYear)
ks <- c(1,2,3,4,5,6,7)

## run nmds for k = 1 through 7 and save stress values
stresses <- c()
for(k in ks){
  odata_edge.nmds <- metaMDS(comm = odata_edge.mrel, autotransform = FALSE,
                                  distance = "euc", engine = "monoMDS", k = k, weakties = TRUE,
                                  model = "global", maxit = 400, try = 40, trymax = 200,
                                  wascores = TRUE)
  stresses[k] <- odata_edge.nmds$stress
}

## plot k v. stress
plot(ks,stresses, xlab="K", ylab="stress", main="Value of K v. Stress of NMDS")


# NMDS with K = 7 --------------------------------------------------------- WARNING MESSAGE
odata_edge.nmds7 <- metaMDS(comm = odata_edge.mrel, autotransform = FALSE,
                                distance = "euc", engine = "monoMDS", k = 7, weakties = TRUE,
                                model = "global", maxit = 400, try = 40, trymax = 200,
                                wascores = TRUE)

odata_edge.nmds7
#Warning message:
#  In metaMDS(comm = odata_edge.mrel, autotransform = FALSE, distance = "euc",  :
#               'comm' has negative data: 'autotransform', 'noshare' and 'wascores' set to FALSE


# Plot NMDS color-coded --------------------------------------------------- ERROR MESSAGE

## plot result of ordinations for sites only
edge.nmds.gg <- fortify(odata_edge.nmds7)
# Error in rep("sites", nrow(df)) : invalid 'times' argument
edge.nmds.sites <- scores(odata_edge.nmds7)
edge.nmds.gg

