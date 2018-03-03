########## PLOT DENDROGRAM / CLUSTER ############

#https://cran.r-project.org/web/packages/dendextend/vignettes/Cluster_Analysis.html


library(dendextend)
install.packages("colorspace")
library(colorspace)
install.packages("ggplot2")
library(ggplot2)



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

# to turn it into a circle
install.packages("circlize")
library(circlize)
circlize_dendrogram(dend_edge)




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

