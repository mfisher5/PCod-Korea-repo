######## RUN CLUSTER ANALYSIS ON RELATIVIZED OTOLITH DATA ############
#
# MF 2/25/2018
# for SEFS 502 Final Project
# 
#######################################################################
## set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/otolith_analyses")


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
edge.hclust <- hclust(d = edge.mrel_dist, method = "ward.D2")
core.hclust <- hclust(d = core.mrel_dist, method = "ward.D2")
rect.hclust(edge.hclust, k=7)
rect.hclust(core.hclust, k=7)
##-- gap statistic
NbClust(data = odata_edge.mrel, diss = edge.mrel_dist, 
        distance=NULL, method="ward.D2", index="gap")
NbClust(data=odata_core.mrel, diss=core.mrel_dist, 
        distance=NULL, method="ward.D2", index="gap")



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





# Hierarchical Clustering with Ward Method --------------------------------

edge.hclust <- hclust(d = edge.mrel_dist, method = "ward.D2") 
core.hclust <- hclust(d = core.mrel_dist, method = "ward.D2")

## gap statistic
NbClust(data = odata_edge.mrel, diss = edge.mrel_dist, distance=NULL, 
        method="ward.D2", index="gap")
NbClust(data=odata_core.mrel, diss=core.mrel_dist, distance=NULL, 
        method="ward.D2", index="gap")
plot(core.hclust, hang = -1, main = "Core Microchemistry\nCluster Dendrogram",
     ylab = "Dissimilarity", xlab = "Coded by Site",
     sub = paste("Euclidean dissimilarity;", method="ward.D2", sep=" "),
     labels = odata_combo$SiteYear)
rect.hclust(core.hclust, k=2)

## save groupings 
dend_edge <- as.dendrogram(edge.hclust)
dend_core <- as.dendrogram(core.hclust)
edge2 <- cutree(dend_edge, k=2)
edge3 <- cutree(dend_edge, k=3)
core3 <- cutree(dend_core, k=3)
core2 <- cutree(dend_core, k=2)


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







# Plot Dendrograms  --------------------------------------------------------
par(mfrow=c(1,2))
par(mar = c(3,2,3,4))

# EDGE #
dend_edge <- as.dendrogram(edge.hclust)

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
labels_colors(dend_edge) <- colors
labels(dend_edge) <- labs
dend_edge <- set(dend_edge, "labels_cex", 0.5)
dend_edge <- hang.dendrogram(dend_edge,hang_height=0.1)
plot(dend_edge, 
     main = "Edge Microchemistry", 
     horiz =  TRUE,  nodePar = list(cex = .007))
legend("topleft", legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "JinhaeBay '07e", "JinhaeBay '07l", "Pohang '15"), fill = c("#fb8072", "#bebada", "darkorange", "gold2", "#8dd3c7", "#80b1d3", "#b3de69"), cex = 0.75)



# CORE #
dend_core <- as.dendrogram(core.hclust)

# prepare colors for leaves
labs <- as.character(odata_combo$SiteYear)[order.dendrogram(dend_core)]
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
labels_colors(dend_core) <- colors
labels(dend_core) <- labs
dend_core <- set(dend_core, "labels_cex", 0.5)
dend_core <- hang.dendrogram(dend_core,hang_height=0.1)
plot(dend_core, 
     main = "Core Microchemistry", 
     horiz =  TRUE,  nodePar = list(cex = .007))



par(mfrow=c(1,1))








# NMDS With HClust --------------------------------------------------------
## k = 3, for best visualization
odata_edge.nmds3 <- metaMDS(comm = edge.mrel_dist, autotransform = FALSE,
                            distance = "euc", engine = "monoMDS", k = 3, weakties = TRUE,
                            model = "global", maxit = 400, try = 40, trymax = 200,
                            wascores = TRUE)
## plot
plot(odata_edge.nmds3, xaxt = "n", yaxt = "n", xlab = "", ylab = "", main = "NMDS of Edge with Ward D2 Clustering of Edge\nK=2")

## add ordihull for core, k = 2
ordihull(odata_edge.nmds3, groups = core2, col=c("gold2","#8dd3c7"), draw = "polygon", alpha = 80)

## add ordihull for core, k = 3
ordihull(odata_edge.nmds3, core3, col=c("#b3de69","gold2","#8dd3c7"), draw = "polygon", alpha = 80)


## add ordihull for edge, k = 2
ordihull(odata_edge.nmds3, groups = edge2, col=c("gold2","#8dd3c7"), draw = "polygon", alpha = 80)

## add ordihull for edge, k = 3
ordihull(odata_edge.nmds3, groups = edge3, col=c("#b3de69","gold2","#8dd3c7"), draw = "polygon", alpha = 80)


## point colors
points(odata_edge.nmds3$points[odata_combo$SiteYear == "Pohang_2015",], 
       pch = 19, col = "#b3de69", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "Geoje_2015",], 
       pch = 19, col = "gold2", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "Namhae_2015",], 
       pch = 19, col = "#bebada", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "YSBlock_2016",], 
       pch = 19, col = "#fb8072", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "JinhaeBay_2007",], 
       pch = 19, col = "#8dd3c7", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "JinhaeBay_2008",], 
       pch = 19, col = "#80b1d3", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "Geoje_2014",], 
       pch = 19, col = "darkorange", cex = 1.2)
## add legend
legend(x="topright", pch = 19, cex = 1, pt.cex = 1.2,
       col = c("#fb8072", "#bebada", "darkorange", "gold2", "#8dd3c7", "#80b1d3", "#b3de69"), 
       legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "JinhaeBay '07e", "JinhaeBay '07l", "Pohang '15"), title = "Sampling Site")
