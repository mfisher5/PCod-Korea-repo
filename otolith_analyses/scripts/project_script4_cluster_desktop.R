######## RUN CLUSTER ANALYSIS ON RELATIVIZED OTOLITH DATA ############
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


# Manipulate data frames --------------------------------------------------
## need to make sure the order of the explanatory variables are the same as the element concentrations
odata_combo <- full_join(x=odata,y=odata_ex,by="Sample") 
odata_combo <- mutate(odata_combo, SiteYear=paste(Sampling.Site,Year,sep="_")) # add column with site & year
head(odata_combo)

## make data frame of only edge concentrations
odata_edge <- odata_combo[,10:17]
head(odata_edge)

## make data frame of only core concentrations
odata_core <- odata_combo[,2:9]
head(odata_core)




# Relativize edge and core data by maximum, calculate distance matrix ----------------------------------
odata_edge.mrel <- decostand(odata_edge, method="max")
odata_core.mrel <- decostand(odata_core, method="max")

## convert data to distance matrix using bray-curtis (default)
edge.mrel_dist <- dist(odata_edge.mrel, method = "euclidean")
core.mrel_dist <- dist(odata_core.mrel, method = "euclidean")





# Ward Clustering ---------------------------------------------------------

## conduct cluster analysis using Ward method
edge.hclust <- hclust(d = edge.mrel_dist, method = "ward.D2")
core.hclust <- hclust(d = core.mrel_dist, method = "ward.D2")

## plot dendrogram
plot(edge.hclust, hang = -1, main = "Edge Microchemistry\nCluster Dendrogram",
     ylab = "Dissimilarity", xlab = "Coded by Site",
     sub = "Euclidean dissimilarity; ward.D2 linkage",
     labels = odata_combo$SiteYear)
plot(core.hclust, hang = -1, main = "Core Microchemistry\nCluster Dendrogram",
     ylab = "Dissimilarity", xlab = "Coded by Site",
     sub = "Euclidean dissimilarity; ward.D2 linkage",
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




# Create Function to Run Clustering ---------------------------------------------------------------------------------------

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

## ward.d2
OtoCluster(edist = edge.mrel_dist, cdist = core.mrel_dist, method = "ward.D2")
edge.hclust <- hclust(d = edge.mrel_dist, method = "ward.D2")
core.hclust <- hclust(d = core.mrel_dist, method = "ward.D2")
rect.hclust(edge.hclust, k=7)
rect.hclust(core.hclust, k=7)
##-- gap statistic
install.packages("NbClust")
require(NbClust)
NbClust(data = odata_edge, diss = edge.mrel_dist, distance=NULL, method="ward.D2", index="gap")
## ERROR: cannot allocate vector of size 144092.9


##--pvclust package



## UPGMA (average)
OtoCluster(edist = edge.mrel_dist, cdist = core.mrel_dist, method = "average")
edge.hclust <- hclust(d = edge.mrel_dist, method = "average")
core.hclust <- hclust(d = core.mrel_dist, method = "average")
rect.hclust(edge.hclust, k=7)
rect.hclust(core.hclust, k=7)


## Complete Linkage
OtoCluster(edist = edge.mrel_dist, cdist = core.mrel_dist, method = "complete")
edge.hclust <- hclust(d = edge.mrel_dist, method = "complete")
core.hclust <- hclust(d = core.mrel_dist, method = "complete")
rect.hclust(edge.hclust, k=7)
rect.hclust(core.hclust, k=7)
