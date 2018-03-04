########## PLOT DENDROGRAM FROM CLUSTER ANALYSIS############
#
#MF
# https://cran.r-project.org/web/packages/dendextend/vignettes/Cluster_Analysis.html
################################################################


# Load Packages -----------------------------------------------------------
library(dendextend)
install.packages("colorspace")
library(colorspace)
install.packages("ggplot2")
library(ggplot2)
install.packages("dplyr")
library(dplyr)




# plot dendrogram, color coded and labeled --------------------------------
## CORE
dend_core <- as.dendrogram(core.hclust)
dend_core <- color_branches(dend_core, k=2) # K will color branches by # groups
dend_core
colors <- rainbow_hcl(5)[sort_levels_values(as.numeric(as.factor(odata_combo$Sampling.Site))[order.dendrogram(dend_core)])]
labels_colors(dend_core) <- colors


labels(dend_core) <- paste(as.character(as.factor(odata_combo$Sampling.Site))[order.dendrogram(dend_core)], "(",labels(dend_core),")", sep = "")
dend_core <- set(dend_core, "labels_cex", 0.5)
dend_core <- hang.dendrogram(dend_core,hang_height=0.1)
par(mar = c(3,3,3,7))
plot(dend_core, 
     main = "Clustered Core Microchemistry by Site
     (k=2)", 
     horiz =  TRUE,  nodePar = list(cex = .007))
leg_colors <- c("#C29DDE", "#BDAB66", "#65BC8C", "#55B8D0", "#E495A5")
legend("topleft", legend = unique(odata_combo$Sampling.Site), fill = leg_colors)

# to turn it into a circle
install.packages("circlize")
library(circlize)
circlize_dendrogram(dend_core)



## EDGE
dend_edge <- as.dendrogram(edge.hclust)
dend_edge <- color_branches(dend_edge, k=2) # K will color branches by # groups
dend_edge
colors <- rainbow_hcl(5)[sort_levels_values(as.numeric(as.factor(odata_combo$Sampling.Site))[order.dendrogram(dend_edge)])]
labels_colors(dend_edge) <- colors


labels(dend_edge) <- paste(as.character(as.factor(odata_combo$Sampling.Site))[order.dendrogram(dend_edge)], "(",labels(dend_edge),")", sep = "")
dend_edge <- set(dend_edge, "labels_cex", 0.5)
dend_edge <- hang.dendrogram(dend_edge,hang_height=0.1)
par(mar = c(3,3,3,7))
plot(dend_edge, 
     main = "Clustered Edge Microchemistry by Site
     (k=2)", 
     horiz =  TRUE,  nodePar = list(cex = .007))
leg_colors <- c("#C29DDE", "#BDAB66", "#65BC8C", "#55B8D0", "#E495A5")
legend("topleft", legend = unique(odata_combo$Sampling.Site), fill = leg_colors)
