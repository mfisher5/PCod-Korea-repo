############################# Produce heat map comparing otolith and genetic assignment #####################
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




# Create Dendrogram -------------------------------------------------------
# plot dendrogram, color coded and labeled
dend_edge <- as.dendrogram(edge.hclust)
dend_edge <- color_branches(dend_edge, k=2)
dend_edge
plot(dend_edge)
colors <- rainbow_hcl(7)[sort_levels_values(as.numeric(as.factor(odata_combo$SiteYear))[order.dendrogram(dend_edge)])]
labels_colors(dend_edge) <- colors


labels(dend_edge) <- paste(as.character(as.factor(odata_combo$SiteYear))[order.dendrogram(dend_edge)],
                           "(",labels(dend_edge),")", 
                           sep = "")
dend_edge <- set(dend_edge, "labels_cex", 0.5)
dend_edge <- hang.dendrogram(dend_edge,hang_height=0.1)
par(mar = c(3,3,3,7))
siteyears = unique(odata_combo$SiteYear)
plot(dend_edge, 
     main = "Clustered Edge Microchemistry by Site
     (k=2)", 
     horiz =  TRUE,  nodePar = list(cex = .007))
legend("topleft", legend = siteyears, fill = unique(colors))



## plot heatmap
library(gplots)
some_col_func <- function(n) rev(colorspace::heat_hcl(n, c = c(80, 30), l = c(30, 90), power = c(1/5, 1.5)))
gplots::heatmap.2(as.matrix(gendata), 
                  main = "Clustering from\nOtolith Edge Microchemstry\nv. Genetic Analysis",
                  srtCol = 20,
                  dendrogram = "row",
                  Rowv = dend_edge,
                  Colv = "NA", # this to make sure the columns are not ordered
                  trace="none",          
                  margins =c(5,0.1),      
                  key.xlab = "Genetic Assignment",
                  denscol = "grey",
                  density.info = "density",
                  RowSideColors = rev(labels_colors(dend_edge)), # to add nice colored strips        
                  col = some_col_func
)


