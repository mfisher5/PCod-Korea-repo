######## RUN CLUSTER ANALYSIS ON RELATIVIZED OTOLITH DATA ############
#
# MF 2/25/2018
# for SEFS 502 Final Project
# 
#############################################################


## set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/otolith_analyses")

## install packages
install.packages("dplyr")
library(dplyr)


# Load data ---------------------------------------------------------------
odata <- read.csv("data/PCod_Korea_Microchem_filtered.txt", header=TRUE, sep="\t")
odata_ex <- read.csv("data/PCod_Korea_ExpData_filtered.txt", header=TRUE, sep="\t")

dim(odata)
dim(odata_ex)


# Manipulate data frames --------------------------------------------------
## need to make sure the order of the explanatory variables are the same as the element concentrations
odata_combo <- full_join(x=odata,y=odata_ex,by="Sample") 
odata_combo <- mutate(odata_combo, SiteYear=paste(Sampling.Site,Year,sep="_")) # add column with site & year as a single variable
head(odata_combo)
odata_el <- odata_combo[,2:17] # extract only response variable measurements
head(odata_el)


# Relativize by maximum ---------------------------------------------------
odata_el.mrel <- decostand(odata_el, method="max")
head(odata_el.mrel)




# Make edge / core data frames --------------------------------------------
odata_edge.mrel <- odata_el.mrel[,9:16] # only edge measurements
head(odata_edge)
odata_core.mrel <- odata_el.mrel[,1:8] # only core measurements
head(odata_core)




# Euclidean Distance Matrix -----------------------------------------------
edge.mrel_dist <- dist(odata_edge.mrel, method = "euclidean")
core.mrel_dist <- dist(odata_core.mrel, method = "euclidean")






# Create Function to Run Clustering ---------------------------------------

OtoCluster <- function(edist = edge.mrel_dist, cdist = core.mrel_dist, method = "ward.D2"){
  ## conduct cluster analysis
  edge.hclust <- hclust(d = edist, method = method)
  core.hclust <- hclust(d = cdist, method = method)
  
  ## plot dendrogram
  plot(edge.hclust, hang = -1, main = "Edge Microchemistry\nCluster Dendrogram",
       ylab = "Dissimilarity", xlab = "Coded by Site",
       sub = paste("Euclidean dissimilarity;", method, sep=" "),
       labels = odata_combo$SiteYear)
  plot(core.hclust, hang = -1, main = "Core Microchemistry\nCluster Dendrogram",
       ylab = "Dissimilarity", xlab = "Coded by Site",
       sub = paste("Euclidean dissimilarity;", method, sep=" "),
       labels = odata_combo$SiteYear)
  
  ## how many groups?
  edge_heights <- cbind(edge.hclust$height, edge.hclust$merge)
  colnames(edge_heights) <- c("Height", "JoinThis", "WithThis")
  plot(x=16:1, y=edge_heights[(nrow(edge_heights) - 15):nrow(edge_heights),1],
       xlab="Number of groups", ylab="Height", type="b", main="Edge")
  
  core_heights <- cbind(core.hclust$height, core.hclust$merge)
  colnames(core_heights) <- c("Height", "JoinThis", "WithThis")
  plot(x=16:1, y=core_heights[(nrow(core_heights) - 15):nrow(core_heights),1],
       xlab="Number of groups", ylab="Height", type="b", main="Core")
  
}



# Test Clustering Methods -------------------------------------------------
install.packages("NbClust")
require(NbClust)
install.packages("pvclust")
library(pvclust)

## ward.d2
OtoCluster(edist = edge.mrel_dist, cdist = core.mrel_dist, method = "ward.D2")
edge.hclust <- hclust(d = edge.mrel_dist, method = "ward.D2") # create object outside function
core.hclust <- hclust(d = core.mrel_dist, method = "ward.D2") # create object outside function
##-- gap statistic
NbClust(data = odata_edge.mrel, diss = edge.mrel_dist, distance=NULL, method="ward.D2", index="gap")
NbClust(data=odata_core.mrel, diss=core.mrel_dist, distance=NULL, method="ward.D2", index="gap")
plot(core.hclust, hang = -1, main = "Core Microchemistry\nCluster Dendrogram",
     ylab = "Dissimilarity", xlab = "Coded by Site",
     sub = paste("Euclidean dissimilarity;", method="ward.D2", sep=" "),
     labels = odata_combo$SiteYear)
rect.hclust(core.hclust, k=2)
##--pvclust package: https://cran.r-project.org/web/packages/pvclust/pvclust.pdf
edge_mrel_transposed <- t(odata_edge.mrel) #transpose data frame so clustering samples, not elements
dim(edge_mrel_transposed)
colnames(edge_mrel_transposed) <- odata_combo$Sample # add sample names to transposed data frame
edge.wd2 <- pvclust(edge_mrel_transposed, method.hclust="ward.D2", r=seq(0.5,1,by=0.1),
        method.dist="euclidean", nboot = 100)
plot(edge.wd2) # plot dendrogram
pvrect(edge.wd2, alpha = 0.95, pv="au") #split dendrogram by significant groups, alpha = 0.05
core_mrel_transposed <- t(odata_core.mrel)
dim(core_mrel_transposed)
colnames(core_mrel_transposed) <- odata_combo$Sample
core.wd2 <- pvclust(core_mrel_transposed, method.hclust="ward.D2", r=seq(0.5,1,by=0.1), method.dist="euclidean", nboot = 100)
plot(core.wd2)
pvrect(core.wd2, alpha = 0.95, pv="au")


## UPGMA (average)
OtoCluster(edist = edge.mrel_dist, cdist = core.mrel_dist, method = "average")
edge.hclust <- hclust(d = edge.mrel_dist, method = "average")
core.hclust <- hclust(d = core.mrel_dist, method = "average")
rect.hclust(edge.hclust, k=7)
rect.hclust(core.hclust, k=7)
##-- gap statistic
NbClust(data = odata_edge.mrel, diss = edge.mrel_dist, 
        distance=NULL, method="average", index="gap")
NbClust(data=odata_core.mrel, diss=core.mrel_dist, 
        distance=NULL, method="average", index="gap")



## Complete Linkage
OtoCluster(edist = edge.mrel_dist, cdist = core.mrel_dist, method = "complete")
edge.hclust <- hclust(d = edge.mrel_dist, method = "complete")
core.hclust <- hclust(d = core.mrel_dist, method = "complete")
rect.hclust(edge.hclust, k=7)
plot(core.hclust)
rect.hclust(core.hclust, k=7)
##-- gap statistic
NbClust(data = odata_edge.mrel, diss = edge.mrel_dist, 
        distance=NULL, method="complete", index="gap")
NbClust(data=odata_core.mrel, diss=core.mrel_dist, 
        distance=NULL, method="complete", index="gap")
