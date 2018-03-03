

# Install packages --------------------------------------------------------
install.packages("vegan")
library(vegan)
install.packages("dplyr")
library(dplyr)

# Save groups from clustering K = 2-4 -------------------------------------

core.hclust <- hclust(d = core.mrel_dist, method = "ward.D2")
core.hclust.g2 <- cutree(core.hclust, k=2)
core.hclust.g3 <- cutree(core.hclust, k=3)
core.hclust.g4 <- cutree(core.hclust, k=4)





# Run NMDS ---------------------------------------------------------------

odata_edge.nmds7 <- metaMDS(comm = edge.mrel_dist, autotransform = FALSE,
                            distance = "euc", engine = "monoMDS", k = 7, weakties = TRUE,
                            model = "global", maxit = 400, try = 40, trymax = 200,
                            wascores = TRUE)


# Plot Cluster onto NMDS --------------------------------------------------

plot(odata_edge.nmds7, xaxt = "n", yaxt = "n", xlab = "", ylab = "", main = "NMDS\nMicrochemistry from Otolith Edge")
points(odata_edge.nmds7$points[odata_combo$SiteYear == "Pohang_2015",], 
       pch = 19, col = "#b3de69", cex = 1.2)
points(odata_edge.nmds7$points[odata_combo$SiteYear == "Geoje_2015",], 
       pch = 19, col = "gold2", cex = 1.2)
points(odata_edge.nmds7$points[odata_combo$SiteYear == "Namhae_2015",], 
       pch = 19, col = "#bebada", cex = 1.2)
points(odata_edge.nmds7$points[odata_combo$SiteYear == "YSBlock_2016",], 
       pch = 19, col = "#fb8072", cex = 1.2)
points(odata_edge.nmds7$points[odata_combo$SiteYear == "JinhaeBay_2007",], 
       pch = 19, col = "#8dd3c7", cex = 1.2)
points(odata_edge.nmds7$points[odata_combo$SiteYear == "JinhaeBay_2008",], 
       pch = 19, col = "#80b1d3", cex = 1.2)
points(odata_edge.nmds7$points[odata_combo$SiteYear == "Geoje_2014",], 
       pch = 19, col = "darkorange", cex = 1.2)
legend(x="topright", pch = 19, bty="n", cex = 1, pt.cex = 1.2,
       col = c("#fb8072", "#bebada", "darkorange", "gold2", "#8dd3c7", "#80b1d3", "#b3de69"), 
       legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "JinhaeBay '07e", "JinhaeBay '07l", "Pohang '15"), title = "Sampling Site")

# K = 2-4
ordihull(odata_edge.nmds7, groups = core.hclust.g2, col = "gray28", lwd = 2, lty= 2)
ordihull(odata_edge.nmds7, groups = core.hclust.g3, col = "gray28", lwd = 2, lty= 2)
ordihull(odata_edge.nmds7, groups = core.hclust.g4, col = "gray28", lwd = 2, lty= 2)





##################################################################################################

## Save optimal partition from NbClust
partition.g2 <-c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,1,2,2,2,1,2,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,1,1,2,1,2,2,2,2,2,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
odata_edge_g2 <- cbind(odata_edge, Group=partition.g2)
View(odata_edge_g2)


## plot NMDS
plot(odata_edge.nmds7, xaxt = "n", yaxt = "n", xlab = "", ylab = "", main = "NMDS\nMicrochemistry from Otolith Edge")
points(odata_edge.nmds7$points[odata_edge_g2$Group == 1 & odata_combo$SiteYear == "Pohang_2015",], 
       pch = 19, col = "#b3de69", cex = 1.2)
points(odata_edge.nmds7$points[odata_edge_g2$Group == 2 & odata_combo$SiteYear == "Pohang_2015",], 
       pch = 17, col = "#b3de69", cex = 1.2)
points(odata_edge.nmds7$points[odata_edge_g2$Group == 1 & odata_combo$SiteYear == "Geoje_2015",], 
       pch = 19, col = "gold2", cex = 1.2)
points(odata_edge.nmds7$points[odata_edge_g2$Group == 2 & odata_combo$SiteYear == "Geoje_2015",], 
       pch = 17, col = "gold2", cex = 1.2)
points(odata_edge.nmds7$points[odata_edge_g2$Group == 1 & odata_combo$SiteYear == "Namhae_2015",], 
       pch = 19, col = "#bebada", cex = 1.2)
points(odata_edge.nmds7$points[odata_edge_g2$Group == 2 & odata_combo$SiteYear == "Namhae_2015",], 
       pch = 17, col = "#bebada", cex = 1.2)
points(odata_edge.nmds7$points[odata_edge_g2$Group == 1 & odata_combo$SiteYear == "YSBlock_2016",], 
       pch = 19, col = "#fb8072", cex = 1.2)
points(odata_edge.nmds7$points[odata_edge_g2$Group == 2 & odata_combo$SiteYear == "YSBlock_2016",], 
       pch = 17, col = "#fb8072", cex = 1.2)
points(odata_edge.nmds7$points[odata_edge_g2$Group == 1 & odata_combo$SiteYear == "JinhaeBay_2007",], 
       pch = 19, col = "#8dd3c7", cex = 1.2)
points(odata_edge.nmds7$points[odata_edge_g2$Group == 2 & odata_combo$SiteYear == "JinhaeBay_2007",], 
       pch = 17, col = "#8dd3c7", cex = 1.2)
points(odata_edge.nmds7$points[odata_edge_g2$Group == 1 & odata_combo$SiteYear == "JinhaeBay_2008",], 
       pch = 19, col = "#80b1d3", cex = 1.2)
points(odata_edge.nmds7$points[odata_edge_g2$Group == 2 & odata_combo$SiteYear == "JinhaeBay_2008",], 
       pch = 17, col = "#80b1d3", cex = 1.2)
points(odata_edge.nmds7$points[odata_edge_g2$Group == 1 & odata_combo$SiteYear == "Geoje_2014",], 
       pch = 19, col = "darkorange", cex = 1.2)
points(odata_edge.nmds7$points[odata_edge_g2$Group == 2 & odata_combo$SiteYear == "Geoje_2014",], 
       pch = 17, col = "darkorange", cex = 1.2)

legend(x="topright", pch = c(19,19,19,19,19,19,19,1,2), bty="n", cex = 1, pt.cex = 1.2,
       col = c("#fb8072", "#bebada", "darkorange", "gold2", "#8dd3c7", "#80b1d3", "#b3de69", "black", "black"), 
       legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "JinhaeBay '07e", "JinhaeBay '07l", "Pohang '15", "Group 1", "Group 2"), title = "Sampling Site")
