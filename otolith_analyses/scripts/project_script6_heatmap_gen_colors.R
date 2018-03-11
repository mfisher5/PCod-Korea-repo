############################# Produce heat map comparing otolith and genetic assignment #####################
#
# MF 3/2/2018
#
##############################################################################################################

## set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/otolith_analyses")

# Load packages -----------------------------------------------------------
install.packages("vegan")
install.packages("dplyr")
install.packages("colorspace")
install.packages("ggplot2")
library(vegan)
library(ggplot2)
library(dendextend)
library(colorspace)
library(dplyr)


# Load genetic data -------------------------------------------------------
structure <- read.csv("data/PCod_Korea_Structure_assignment.txt", header=TRUE, sep="\t")


# Manipulate data frames --------------------------------------------------
## need to make sure only keep genetic data for samples that were filtered through analyses
gendata <- left_join(x=odata_combo, y=structure)
head(gendata)
gendata <- gendata[,(ncol(gendata)-2):(ncol(gendata)-1)]
colnames(gendata) <- c("West", "South")
head(gendata)


# Clustering  -------------------------------------
core.hclust <- hclust(d = core.mrel_dist, method = "ward.D2")
edge.hclust <- hclust(d = edge.mrel_dist, method = "ward.D2")



# Create Dendrogram -------------------------------------------------------
# prepare colors for leaves
labs <- as.character(odata_combo$SiteYear)[order.dendrogram(dend_edge)]
colors <- c()
for(i in labs){
  if(i == "Pohang_2015"){
    colors <-c(colors, "#b3de69")
  } else if(i == "Geoje_2015"){
    colors <-c(colors, "gold2")
  } else if(i == "Namhae_2015"){
    colors <-c(colors, "#bebada")
  } else if(i == "YSBlock_2016"){
    colors <-c(colors, "#fb8072")
  } else if(i == "JinhaeBay_2007"){
    colors <-c(colors, "#8dd3c7")
  } else if(i == "JinhaeBay_2008"){
    colors <-c(colors, "#80b1d3")
  } else if(i == "Geoje_2014"){
    colors <-c(colors, "darkorange")
  }
}


# plot dendrogram, color coded and labeled
dend_edge <- as.dendrogram(edge.hclust)
plot(dend_edge)

labels_colors(dend_edge) <- colors

labels(dend_edge) <- labs
dend_edge <- set(dend_edge, "labels_cex", 0.5)
dend_edge <- hang.dendrogram(dend_edge,hang_height=0.1)
par(mar = c(3,3,3,7))
siteyears = unique(odata_combo$SiteYear)
plot(dend_edge, 
     main = "Clustered Edge Microchemistry by Site", 
     horiz =  TRUE,  nodePar = list(cex = .007))
legend("topleft", legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "JinhaeBay '07e", "JinhaeBay '07l", "Pohang '15"), fill = c("#fb8072", "#bebada", "darkorange", "gold2", "#8dd3c7", "#80b1d3", "#b3de69"))


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
                  RowSideColors = colors, # to add nice colored strips  
                  col = some_col_func
)


