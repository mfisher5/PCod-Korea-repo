######## RUN NMDS ON RELATIVIZED OTOLITH DATA ############
#
# MF 2/25/2018
# for SEFS 502 Final Project
# 
#############################################################

## set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/otolith_analyses")

# Load packages -----------------------------------------------------------
install.packages("vegan")
install.packages("ggplot2")
install.packages("devtools")
devtools::install_github("gavinsimpson/ggvegan")
install.packages("dplyr")
library(ggvegan)
library(ggplot2)
library(vegan)
library(dplyr)




# Find optimal value of K for NMDS --------------------------------------------------------------------
## how many unique site / year combos?
unique(odata_combo$SiteYear)
ks <- c(1,2,3,4,5,6,7)

## run nmds for k = 1 through 7 and save stress values
stresses <- c()
for(k in ks){
  odata_core.nmds <- metaMDS(comm = core.mrel_dist, autotransform = FALSE,
                                  distance = "euc", engine = "monoMDS", k = k, weakties = TRUE,
                                  model = "global", maxit = 400, try = 40, trymax = 200,
                                  wascores = TRUE)
  stresses[k] <- odata_core.nmds$stress
}

## plot k v. stress
plot(ks,stresses, xlab="K", ylab="stress", main="Value of K v. Stress of NMDS, Core")
stresses


# NMDS with K = 7 --------------------------------------------------------- WARNING MESSAGE
odata_core.nmds7 <- metaMDS(comm = core.mrel_dist, autotransform = FALSE,
                                distance = "euc", engine = "monoMDS", k = 7, weakties = TRUE,
                                model = "global", maxit = 400, try = 40, trymax = 200,
                                wascores = TRUE)

odata_core.nmds3 <- metaMDS(comm = core.mrel_dist, autotransform = FALSE,
                            distance = "euc", engine = "monoMDS", k = 3, weakties = TRUE,
                            model = "global", maxit = 400, try = 40, trymax = 200,
                            wascores = TRUE)


# Evaluate Fit NMDS ---------------------------------------------------
stressplot(object=odata_core.nmds7, lwd=2)
stressplot(object=odata_core.nmds3, lwd=2)


# Plot NMDS color-coded K = 7 -------------------------------------
plot(odata_core.nmds3, xaxt = "n", yaxt = "n", xlab = "", ylab = "", main = "NMDS\nMicrochemistry from Otolith Core")
## set colors for points based on sampling site
points(odata_core.nmds3$points[odata_combo$SiteYear == "Pohang_2015",], 
       pch = 19, col = "#b3de69", cex = 1.2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "Geoje_2015",], 
       pch = 19, col = "gold2", cex = 1.2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "Namhae_2015",], 
       pch = 19, col = "#bebada", cex = 1.2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "YSBlock_2016",], 
       pch = 19, col = "#fb8072", cex = 1.2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "JinhaeBay_2007",], 
       pch = 19, col = "#8dd3c7", cex = 1.2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "JinhaeBay_2008",], 
       pch = 19, col = "#80b1d3", cex = 1.2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "Geoje_2014",], 
       pch = 19, col = "darkorange", cex = 1.2)
## add legend
legend(x="topleft", pch = 19, cex = 1, pt.cex = 1.2,
       col = c("#fb8072", "#bebada", "darkorange", "gold2", "#8dd3c7", "#80b1d3", "#b3de69"), 
       legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "JinhaeBay '07e", "JinhaeBay '07l", "Pohang '15"), title = "Sampling Site")



# Add ellipses etc. -------------------------------------------------------
ordiellipse(odata_core.nmds2, odata_combo$SiteYear, col=c("darkorange", "gold2", "#8dd3c7", "#80b1d3", "#bebada", "#b3de69", "#fb8072"), kind = "sd", lty = 2, lwd = 1.5)



# Add Element Vectors -----------------------------------------------------
## fit elements to nmds
elements.fit <- envfit(odata_core.nmds2 ~ B11.e + Ba138.e + Li7.e + Mg24.e + Mn55.e + Pb208.e + Sr88.e + Zn66.e, data = odata_combo)

## plot element vectors
plot(elements.fit, col = "black")








# Combo NMDS --------------------------------------------------------------
plot(odata_core.nmds7, xaxt = "n", yaxt = "n", xlab = "", ylab = "", main = "NMDS\nMicrochemistry from Otolith Core and Edge")
## CORE: set colors for points based on sampling site
points(odata_core.nmds7$points[odata_combo$SiteYear == "Pohang_2015",], 
       pch = 19, col = "#b3de69", cex = 1.2)
points(odata_core.nmds7$points[odata_combo$SiteYear == "Geoje_2015",], 
       pch = 19, col = "gold2", cex = 1.2)
points(odata_core.nmds7$points[odata_combo$SiteYear == "Namhae_2015",], 
       pch = 19, col = "#bebada", cex = 1.2)
points(odata_core.nmds7$points[odata_combo$SiteYear == "YSBlock_2016",], 
       pch = 19, col = "#fb8072", cex = 1.2)
points(odata_core.nmds7$points[odata_combo$SiteYear == "JinhaeBay_2007",], 
       pch = 19, col = "#8dd3c7", cex = 1.2)
points(odata_core.nmds7$points[odata_combo$SiteYear == "JinhaeBay_2008",], 
       pch = 19, col = "#80b1d3", cex = 1.2)
points(odata_core.nmds7$points[odata_combo$SiteYear == "Geoje_2014",], 
       pch = 19, col = "darkorange", cex = 1.2)
## EDGE: set colors for points based on sampling site
points(odata_edge.nmds7$points[odata_combo$SiteYear == "Pohang_2015",], 
       pch = 2, col = "#b3de69", cex = 1.2)
points(odata_edge.nmds7$points[odata_combo$SiteYear == "Geoje_2015",], 
       pch = 2, col = "gold2", cex = 1.2)
points(odata_edge.nmds7$points[odata_combo$SiteYear == "Namhae_2015",], 
       pch = 2, col = "#bebada", cex = 1.2)
points(odata_edge.nmds7$points[odata_combo$SiteYear == "YSBlock_2016",], 
       pch = 2, col = "#fb8072", cex = 1.2)
points(odata_edge.nmds7$points[odata_combo$SiteYear == "JinhaeBay_2007",], 
       pch = 2, col = "#8dd3c7", cex = 1.2)
points(odata_edge.nmds7$points[odata_combo$SiteYear == "JinhaeBay_2008",], 
       pch = 2, col = "#80b1d3", cex = 1.2)
points(odata_edge.nmds7$points[odata_combo$SiteYear == "Geoje_2014",], 
       pch = 2, col = "darkorange", cex = 1.2)
## add legend
legend(x="bottomleft", pch = c(19,19,19,19,19,19,19,19,2), bty="n", cex = 1, pt.cex = 1.2,
       col = c("#fb8072", "#bebada", "darkorange", "gold2", "#8dd3c7", "#80b1d3", "#b3de69","black","black"), 
       legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "Pohang '15", "JinhaeBay '07e", "JinhaeBay '07l", "Core", "Edge"), title = "Sampling Site")




## just ellipses on core ordination space
plot(odata_core.nmds7, xaxt = "n", yaxt = "n", xlab = "", ylab = "", main = "NMDS\nMicrochemistry from Otolith Core and Edge", col="white")
ordiellipse(odata_core.nmds7, odata_combo$SiteYear, col=c("darkorange", "gold2", "#8dd3c7", "#80b1d3", "#bebada", "#b3de69", "#fb8072"), kind = "sd", lwd = 1.5)
ordiellipse(odata_edge.nmds7, odata_combo$SiteYear, col=c("darkorange", "gold2", "#8dd3c7", "#80b1d3", "#bebada", "#b3de69", "#fb8072"), kind = "sd", lty = 2, lwd = 1.5)




