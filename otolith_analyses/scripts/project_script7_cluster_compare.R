############################# Produce tanglegram to compare two cluster dendrograms #####################
#
# MF 3/2/2018
#
##############################################################################################################



## set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/otolith_analyses")


# Load data ---------------------------------------------------------------
odata <- read.csv("data/PCod_Korea_Microchem_filtered_edit.txt", header=TRUE, sep="\t")
odata_ex <- read.csv("data/PCod_Korea_ExpData_filtered.txt", header=TRUE, sep="\t")
structure <- read.csv("data/PCod_Korea_Structure_assignment.txt", header=TRUE, sep="\t")

dim(odata)
dim(odata_ex)


# Load packages -----------------------------------------------------------
install.packages("vegan"); library(vegan)
install.packages("dplyr"); library(dplyr)
library(dendextend)
install.packages("colorspace")
library(colorspace)
install.packages("ggplot2")
library(ggplot2)



# Manipulate data frames --------------------------------------------------
## need to make sure the order of the explanatory variables are the same as the element concentrations
odata_combo <- full_join(x=odata,y=odata_ex,by="Sample") 
head(odata_combo)
odata_combo <- mutate(odata_combo, SiteYear=paste(Sampling.Site,Year, sep=""))
head(odata_combo)
odata_el <- odata_combo[,2:17]
head(odata_el)

## need to make sure only keep genetic data for samples that were filtered through analyses
gendata <- left_join(x=odata_combo, structure)
dim(gendata)
gendata <- gendata[,22:24]
colnames(gendata) <- c("West", "South", "East")
head(gendata)

# Relativize by maximum ---------------------------------------------------
odata_el.mrel <- decostand(odata_el, method="max")
head(odata_el.mrel)



# Make edge / core data frames --------------------------------------------
odata_edge.mrel <- odata_el.mrel[,9:16] # only edge measurements
head(odata_edge.mrel)
odata_core.mrel <- odata_el.mrel[,1:8] # only core measurements
head(odata_core.mrel)






# Euclidean Distance Matrix -----------------------------------------------
edge.mrel_dist <- dist(odata_edge.mrel, method = "euclidean")
core.mrel_dist <- dist(odata_core.mrel, method = "euclidean")


# Clustering  -------------------------------------
core.hclust <- hclust(d = core.mrel_dist, method = "ward.D2")
edge.hclust <- hclust(d = edge.mrel_dist, method = "ward.D2")



# Create Dendrograms ------------------------------------------------------
odata_dendlist <- dendlist(as.dendrogram(edge.hclust), as.dendrogram(core.hclust))
names(odata_dendlist) <- c("edge", "core")



# Create Tanglegram -------------------------------------------------------
## without coloring inner lines
odata_dendlist %>% dendlist(which = c(1,2)) %>% ladderize %>% 
  set("branches_k_color", k=3) %>% 
  tanglegram(faster = TRUE)

## with color on inner lines
g3 <- cutree(edge.hclust, k=3)
color_vec <- c(rep("pink",length(g3 == 1)), rep("green",length(g3 == 2)), rep("blue",length(g3 == 3)))
odata_dendlist %>% dendlist(which = c(1,2)) %>% ladderize %>% 
  set("branches_k_color", k=3) %>%
  tanglegram(faster = TRUE, color_lines=color_vec) # (common_subtrees_color_branches = TRUE)



