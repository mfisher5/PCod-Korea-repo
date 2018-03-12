

# Exploring Dendrograms ----------------------------------------------------
library(dendextend)
install.packages("colorspace")
library(colorspace)
install.packages("ggplot2")
library(ggplot2)
install.packages("dplyr")
library(dplyr)

# ZOOM #
dend_core <- as.dendrogram(core.hclust)

## prepare colors for leaves
color_code <- as.character(odata_combo$Sample)[order.dendrogram(dend_core)]
colors <- c()
for(i in color_code){
  if(i == "PO010715_11"){
    colors <-c(colors, "#b3de69")
  } else if(i == "PO020515_06"){
    colors <-c(colors, "#b3de69")
  }  else if(i == "GE012315_04"){
    colors <-c(colors, "gold2")
  } else if(i == "NA021015_13"){
    colors <-c(colors, "#bebada")
  } else if(i == "NA021015_22"){
    colors <-c(colors, "#bebada")
  } else if(i == "NA021015_30"){
    colors <-c(colors, "#bebada")
  } else if(i == "GEO020414_06"){
    colors <-c(colors, "darkorange")
  } else{colors<-c(colors, "grey")}
}

## plot dendrogram, color coded and labeled
labels_colors(dend_core) <- colors
labels(dend_core) <- as.character(as.factor(odata_combo$Sample))[order.dendrogram(dend_core)]
dend_core <- set(dend_core, "labels_cex", 1)
dend_core <- hang.dendrogram(dend_core,hang_height=0.1)
plot(dend_core, 
     main = "Core Microchemistry", 
     horiz =  TRUE,  nodePar = list(cex = .007))
plot(cut(dend_core,h=2.5)$lower[[1]])



## CIRCULAR DENDROGRAM
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

## to turn it into a circle
install.packages("circlize")
library(circlize)
circlize_dendrogram(dend_core)










# Plot NMDS with ggplot---------------------------------------------------
## ggplot
nmds_points <- data.frame(scores(odata_edge.nmds7)); nmds_points #because of warning above, had to convert data

ggplot(nmds_points, aes(x=NMDS1, y=NMDS2)) +
  geom_point()

## color coding based on population, using combined data frame
View(odata_combo)
View(odata)

`Sampling Site` <- odata_combo$SiteYear

ggplot(nmds_points, aes(x=NMDS1, y=NMDS2)) +
  geom_point(aes(col=`Sampling Site`), size = 3) +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank())

install.packages("devtools")
devtools::install_github("jfq3/ggordiplots")
library(ggordiplots)

gg_ordiplot(odata_edge.nmds7, groups = `Sampling Site`) +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank())

# Plot NMDS color-coded, no Pohang -------------------------------

# subset data
## subset response + explanatory variables
combo_nopo <- subset(odata_combo, Sampling.Site != "Pohang")
## subset just response matrix
edge_elements <- colnames(odata_edge.mrel)
edge_nopo <- select(combo_nopo, edge_elements); dim(edge_nopo)



# relativize data
edge_nopo.mrel <- decostand(edge_nopo, method="max")



# NMDS k = 1 through 5
## create distance matrix
edge_nopo_dist <- dist(edge_nopo.mrel, method = "euclidean")

## how many unique site / year combos?
unique(combo_nopo$SiteYear)
ks <- c(1,2,3,4,5,6,7,8)

## run nmds for k = 1 through 7 and save stress values
stresses <- c()
for(k in ks){
  odata_edge.nmds <- metaMDS(comm = edge_nopo_dist, autotransform = FALSE,
                             distance = "euc", engine = "monoMDS", k = k, weakties = TRUE,
                             model = "global", maxit = 400, try = 40, trymax = 200,
                             wascores = TRUE)
  stresses[k] <- odata_edge.nmds$stress
}

## plot k v. stress
plot(ks,stresses, xlab="K", ylab="stress", main="Value of K v. Stress of NMDS")
stresses

# NMDS with K = 5
odata_edge_nopo.nmds6 <- metaMDS(comm = edge_nopo_dist, autotransform = FALSE,
                                 distance = "euc", engine = "monoMDS", k = 6, weakties = TRUE,
                                 model = "global", maxit = 400, try = 40, trymax = 200,
                                 wascores = TRUE)

# NMDS with K = 2
odata_edge_nopo.nmds2 <- metaMDS(comm = edge_nopo_dist, autotransform = FALSE,
                                 distance = "euc", engine = "monoMDS", k = 2, weakties = TRUE,
                                 model = "global", maxit = 400, try = 40, trymax = 200,
                                 wascores = TRUE)


# Evaluate Fit NMDS K=5
stressplot(object=odata_edge_nopo.nmds6, lwd=2)
stressplot(object=odata_edge_nopo.nmds2, lwd=2)


# Base Plot NMDS color-coded
plot(odata_edge_nopo.nmds2, xaxt = "n", yaxt = "n", xlab = "", ylab = "", main = "NMDS without Pohang\nMicrochemistry from Otolith Edge")
## set colors for points based on sampling site
points(odata_edge_nopo.nmds2$points[combo_nopo$SiteYear == "Geoje_2015",], 
       pch = 19, col = "gold2", cex = 1.2)
points(odata_edge_nopo.nmds2$points[combo_nopo$SiteYear == "Namhae_2015",], 
       pch = 19, col = "#bebada", cex = 1.2)
points(odata_edge_nopo.nmds2$points[combo_nopo$SiteYear == "YSBlock_2016",], 
       pch = 19, col = "#fb8072", cex = 1.2)
points(odata_edge_nopo.nmds2$points[combo_nopo$SiteYear == "Geoje_2014",], 
       pch = 19, col = "darkorange", cex = 1.2)
points(odata_edge_nopo.nmds2$points[combo_nopo$SiteYear == "JinhaeBay_2007",], 
       pch = 19, col = "#8dd3c7", cex = 1.2)
points(odata_edge_nopo.nmds2$points[combo_nopo$SiteYear == "JinhaeBay_2008",], 
       pch = 19, col = "#80b1d3", cex = 1.2)
## add legend
legend(x="bottomright", pch = 19, cex = 1, pt.cex = 1.2,
       col = c("#fb8072", "#bebada", "darkorange", "gold2", "#8dd3c7", "#80b1d3"), 
       legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "JinhaeBay '07e", "JinhaeBay '07l"), title = "Sampling Site")


## add ellipses
ordiellipse(odata_edge_nopo.nmds2, odata_combo_nopo$SiteYear, col=c("darkorange", "gold2", "#8dd3c7", "#80b1d3", "#bebada", "#b3de69"), kind = "sd", lty = 2, lwd = 1.5)




# Add Element Vectors
## fit elements to nmds
elements.fit.k2 <- envfit(odata_edge_nopo.nmds2 ~ B11.e + Ba138.e + Li7.e + Mg24.e + Mn55.e + Pb208.e + Sr88.e + Zn66.e, data = combo_nopo)

## plot element vectors
plot(elements.fit.k2, col = "black")

