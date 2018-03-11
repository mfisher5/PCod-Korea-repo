######## RUN KMEANS ANALYSIS ON RELATIVIZED OTOLITH DATA ############
#
# MF 3/10/2018
# for SEFS 502 Final Project
# 
####################################################################


# Install Packages --------------------------------------------------------
install.packages("vegan")
library("vegan")


# Kmeans Edge -------------------------------------------------------------
edge_kmeans <- cascadeKM(odata_edge.mrel, inf.gr=2, sup.gr=7)
plot(edge_kmeans)

## best kmeans by calinski criterion
edge_k2 <- kmeans(x=odata_edge.mrel, centers=2, nstart=100, iter.max = 1000)
edge_kmeans2 <- edge_k2$cluster

## kmeans suggested by nmds
edge_k4 <- kmeans(x=odata_edge.mrel, centers=4, nstart=100, iter.max = 1000)
edge_kmeans4 <- edge_k4$cluster



# Kmeans Core -------------------------------------------------------------
core_kmeans <- cascadeKM(odata_core.mrel, inf.gr=2, sup.gr=7)
plot(core_kmeans)

## best kmeans by calinski criterion
core_k2 <- kmeans(x=odata_core.mrel, centers=2, nstart=100, iter.max = 1000)
core_kmeans2 <- core_k2$cluster


## kmeans suggested by nmds
core_k4 <- kmeans(x=odata_core.mrel, centers=4, nstart=100, iter.max = 1000)
core_kmeans4 <- core_k4$cluster



# Join kmeans to Data Frame -----------------------------------------------
odata_combo_kmeans <- odata_combo %>%
  mutate(core.k2 = core_kmeans2) %>%
  mutate(core.k4 = core_kmeans4) %>%
  mutate(edge.k2 = edge_kmeans2) %>%
  mutate(edge.k4 = edge_kmeans4)
head(odata_combo_kmeans)


# Plot Kmeans Core over NMDS Edge ---------------------------------------------------
## k = 3, for best visualization
odata_edge.nmds3 <- metaMDS(comm = edge.mrel_dist, autotransform = FALSE,
                            distance = "euc", engine = "monoMDS", k = 3, weakties = TRUE,
                            model = "global", maxit = 400, try = 40, trymax = 200,
                            wascores = TRUE)
## plot
plot(odata_edge.nmds3, xaxt = "n", yaxt = "n", xlab = "", ylab = "", main = "NMDS of Edge with KMeans Clustering of Edge\nK=2")
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
legend(x="bottomleft", pch = 19, cex = 1, pt.cex = 1.2,
       col = c("#fb8072", "#bebada", "darkorange", "gold2", "#8dd3c7", "#80b1d3", "#b3de69"), 
       legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "JinhaeBay '07e", "JinhaeBay '07l", "Pohang '15"), title = "Sampling Site")


## add ordihull for k = 2
ordihull(odata_edge.nmds3, odata_combo_kmeans$core.k2, col=c("#8dd3c7","gold2"), draw = "polygon", alpha = 80)

## add ordihull for k = 4
ordihull(odata_edge.nmds3, odata_combo_kmeans$core.k4, col=c("#8dd3c7","gold2","#fb8072","#b3de69"), draw = "polygon", alpha = 80)



## add ordihull for k = 2
ordihull(odata_edge.nmds3, odata_combo_kmeans$edge.k2, col=c("#b3de69","#8dd3c7"), draw = "polygon", alpha = 80)

## add ordihull for k = 4
ordihull(odata_edge.nmds3, odata_combo_kmeans$edge.k4, col=c("#b3de69","#fb8072","gold2","#8dd3c7"), draw = "polygon", alpha = 80)
