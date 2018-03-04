########## PLOT DENDROGRAM / CLUSTER ############

#https://cran.r-project.org/web/packages/dendextend/vignettes/Cluster_Analysis.html


library(dendextend)
install.packages("colorspace")
library(colorspace)
install.packages("ggplot2")
library(ggplot2)
install.packages("dplyr")
library(dplyr)



# plot dendrogram, color coded and labeled
dend_edge <- as.dendrogram(edge.hclust)
dend_edge <- color_branches(dend_edge, k=2)
dend_edge
plot(dend_edge)
colors <- rainbow_hcl(5)[sort_levels_values(as.numeric(as.factor(odata_combo$Sampling.Site))[order.dendrogram(dend_edge)])]
labels_colors(dend_edge) <- colors


labels(dend_edge) <- paste(as.character(as.factor(odata_combo$Sampling.Site))[order.dendrogram(dend_edge)],
                      "(",labels(dend_edge),")", 
                      sep = "")
dend_edge <- set(dend_edge, "labels_cex", 0.5)
dend_edge <- hang.dendrogram(dend_edge,hang_height=0.1)
par(mar = c(3,3,3,7))
plot(dend_edge, 
     main = "Clustered Edge Microchemistry by Site
     (k=2)", 
     horiz =  TRUE,  nodePar = list(cex = .007))
legend("topleft", legend = unique(odata_combo$Sampling.Site), fill = rainbow_hcl(5))

# to turn it into a circle
install.packages("circlize")
library(circlize)
circlize_dendrogram(dend_edge)



# plot dendrogram, color coded and labeled
dend_core <- as.dendrogram(core.hclust)
dend_core <- color_branches(dend_core, k=3)
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


rainbow_hcl(5)












# comparing dendrograms
odata_dendlist <- dendlist(as.dendrogram(edge.hclust), as.dendrogram(core.hclust))
names(odata_dendlist) <- c("edge", "core")

odata_dendlist %>% dendlist(which = c(1,2)) %>% ladderize %>% 
  set("branches_k_color", k=3) %>% 
  # untangle(method = "step1side", k_seq = 3:20) %>%
  # set("clear_branches") %>% #otherwise the single lines are not black, since they retain the previous color from the branches_k_color.
  tanglegram(faster = TRUE) # (common_subtrees_color_branches = TRUE)

## color middle lines by edge tree 
g3 <- cutree(edge.hclust, k=3)
color_vec <- c(rep("pink",length(g3 == 1)), rep("green",length(g3 == 2)), rep("blue",length(g3 == 3)))
odata_dendlist %>% dendlist(which = c(1,2)) %>% ladderize %>% 
  set("branches_k_color", k=3) %>%
  # untangle(method = "step1side", k_seq = 3:20) %>%
  # set("clear_branches") %>% #otherwise the single lines are not black, since they retain the previous color from the branches_k_color.
  tanglegram(faster = TRUE, color_lines=c("pink", "green", "blue")) # (common_subtrees_color_branches = TRUE)

color_vec

# plot dendrogram with heat map
library(gplots)
some_col_func <- function(n) rev(colorspace::heat_hcl(n, c = c(80, 30), l = c(30, 90), power = c(1/5, 1.5)))
gplots::heatmap.2(as.matrix(odata_edge.mrel), 
                  main = "Heatmap for otolith edge",
                  srtCol = 20,
                  dendrogram = "row",
                  Rowv = dend_edge,
                  Colv = "NA", # this to make sure the columns are not ordered
                  trace="none",          
                  margins =c(5,0.1),      
                  key.xlab = "Cm",
                  denscol = "grey",
                  density.info = "density",
                  RowSideColors = rev(labels_colors(dend_edge)), # to add nice colored strips        
                  col = some_col_func
)
