######## RUN NMDS ON RELATIVIZED OTOLITH DATA ############
#
# MF 2/25/2018
# for SEFS 502 Final Project
# 
#############################################################


## set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/otolith_analyses")


# Load data ---------------------------------------------------------------
odata <- read.csv("data/PCod_Korea_Microchem_filtered.txt", header=TRUE, sep="\t")
odata_ex <- read.csv("data/PCod_Korea_ExpData_filtered.txt", header=TRUE, sep="\t")

dim(odata)
dim(odata_ex)


# Load packages -----------------------------------------------------------
install.packages("vegan")
library(vegan)
install.packages("ggplot2")
library(ggplot2)
install.packages("devtools")
devtools::install_github("gavinsimpson/ggvegan")
library(ggvegan)
install.packages("dplyr")
library(dplyr)




# Manipulate data frames --------------------------------------------------
## need to make sure the order of the explanatory variables are the same as the element concentrations
odata_combo <- full_join(x=odata,y=odata_ex,by="Sample") 
odata_combo <- mutate(odata_combo, SiteYear=paste(Sampling.Site,Year,sep="_")) # add column with site & year
head(odata_combo)
odata_el <- odata_combo[,2:17]
head(odata_el)


# Relativize by maximum ---------------------------------------------------
odata_el.mrel <- decostand(odata_el, method="max")
head(odata_el.mrel)
par(mfrow=c(2,4))
boxplot(odata_el.mrel$B11.e, main = "B11.e")
boxplot(odata_el.mrel$Ba138.e, main = "Ba138.e")
boxplot(odata_el.mrel$Li7.e, main = "Li7.e")
boxplot(odata_el.mrel$Mg24.e, main = "Mg24.e")
boxplot(odata_el.mrel$Mn55.e, main = "Mn55.e")
boxplot(odata_el.mrel$Pb208.e, main = "Pb208.e")
boxplot(odata_el.mrel$Sr88.e, main = "Sr88.e")
boxplot(odata_el.mrel$Zn66.e, main = "Zn66.e")
write.csv(odata_edge.mrel, file = "data/PCod_Korea_Microchem_edge_filtered_relativized.csv", row.names=FALSE)


## make data frame of only edge concentrations
odata_edge.mrel <- odata_el.mrel[,9:16]
head(odata_edge)
odata_core.mrel <- odata_el.mrel[,1:8]
head(odata_core)



# Find optimal value of K for NMDS --------------------------------------------------------------------
## create distance matrix
core.mrel_dist <- dist(odata_core.mrel, method = "euclidean")
head(odata_core.mrel)

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


# NMDS with K = 7 --------------------------------------------------------- WARNING MESSAGE
odata_core.nmds7 <- metaMDS(comm = core.mrel_dist, autotransform = FALSE,
                                distance = "euc", engine = "monoMDS", k = 7, weakties = TRUE,
                                model = "global", maxit = 400, try = 40, trymax = 200,
                                wascores = TRUE)

odata_core.nmds7


# Evaluate Fit NMDS K=7 ---------------------------------------------------
stressplot(object=odata_core.nmds7, lwd=2)


# Base Plot NMDS color-coded -------------------------------------
plot(odata_core.nmds7, xaxt = "n", yaxt = "n", xlab = "", ylab = "", main = "NMDS\nMicrochemistry from Otolith Core")
## set colors for points based on sampling site
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
## add legend
legend(x="bottomleft", pch = 19, bty="n", cex = 1, pt.cex = 1.2,
       col = c("#fb8072", "#bebada", "darkorange", "gold2", "#8dd3c7", "#80b1d3", "#b3de69"), 
       legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "JinhaeBay '07e", "JinhaeBay '07l", "Pohang '15"), title = "Sampling Site")



# Add ellipses etc. -------------------------------------------------------
ordiellipse(odata_core.nmds7, odata_combo$SiteYear, col=c("darkorange", "gold2", "#8dd3c7", "#80b1d3", "#bebada", "#b3de69", "#fb8072"), kind = "sd", lty = 2, lwd = 1.5)



# Add Element Vectors -----------------------------------------------------
## fit elements to nmds
elements.fit <- envfit(odata_core.nmds7 ~ B11.e + Ba138.e + Li7.e + Mg24.e + Mn55.e + Pb208.e + Sr88.e + Zn66.e, data = odata_combo)

## plot element vectors
plot(elements.fit, col = "black")





################################ RUN NMDS WITHOUT JINHAE BAY ##############################################


# subset data -------------------------------------------------------------
## subset response + explanatory variables
combo_nojb <- subset(odata_combo, Sampling.Site != "JinhaeBay")

## subset just response matrix
core_elements <- colnames(odata_core)
core_nojb <- select(combo_nojb, core_elements); View(core_nojb)
dim(core_nojb)
dim(odata_core)

# relativize data ---------------------------------------------------------
core_nojb.mrel <- decostand(core_nojb, method="max")



# NMDS k = 1 through 5 ----------------------------------------------------
## create distance matrix
core_nojb_dist <- dist(core_nojb.mrel, method = "euclidean")

## how many unique site / year combos?
unique(combo_nojb$SiteYear)
ks <- c(1,2,3,4,5)

## run nmds for k = 1 through 7 and save stress values
stresses <- c()
for(k in ks){
  odata_core.nmds <- metaMDS(comm = core_nojb_dist, autotransform = FALSE,
                             distance = "euc", engine = "monoMDS", k = k, weakties = TRUE,
                             model = "global", maxit = 400, try = 40, trymax = 200,
                             wascores = TRUE)
  stresses[k] <- odata_core.nmds$stress
}

## plot k v. stress
plot(ks,stresses, xlab="K", ylab="stress", main="Value of K v. Stress of NMDS, Core (no JB)")

# NMDS with K = 7 --------------------------------------------------------- WARNING MESSAGE
odata_core_nojb.nmds5 <- metaMDS(comm = core_nojb_dist, autotransform = FALSE,
                            distance = "euc", engine = "monoMDS", k = 5, weakties = TRUE,
                            model = "global", maxit = 400, try = 40, trymax = 200,
                            wascores = TRUE)

odata_core_nojb.nmds5


# Evaluate Fit NMDS K=7 ---------------------------------------------------
stressplot(object=odata_core_nojb.nmds5, lwd=2)


# Base Plot NMDS color-coded -------------------------------------
plot(odata_core_nojb.nmds5, xaxt = "n", yaxt = "n", xlab = "", ylab = "", main = "NMDS without Jinhae Bay\nMicrochemistry from Otolith Edge")
## set colors for points based on sampling site
points(odata_core_nojb.nmds5$points[combo_nojb$SiteYear == "Pohang_2015",], 
       pch = 19, col = "#b3de69", cex = 1.2)
points(odata_core_nojb.nmds5$points[combo_nojb$SiteYear == "Geoje_2015",], 
       pch = 19, col = "gold2", cex = 1.2)
points(odata_core_nojb.nmds5$points[combo_nojb$SiteYear == "Namhae_2015",], 
       pch = 19, col = "#bebada", cex = 1.2)
points(odata_core_nojb.nmds5$points[combo_nojb$SiteYear == "YSBlock_2016",], 
       pch = 19, col = "#fb8072", cex = 1.2)
points(odata_core_nojb.nmds5$points[combo_nojb$SiteYear == "Geoje_2014",], 
       pch = 19, col = "darkorange", cex = 1.2)
## add legend
legend(x="topleft", pch = 19, bty="n", cex = 1, pt.cex = 1.2,
       col = c("#fb8072", "#bebada", "darkorange", "gold2", "#b3de69"), 
       legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "Pohang '15"), title = "Sampling Site")


# Add ellipses etc. -------------------------------------------------------
ordiellipse(odata_core_nojb.nmds5, combo_nojb$SiteYear, col=c("darkorange", "gold2", "#bebada", "#b3de69", "#fb8072"), kind = "sd", lty = 2, lwd = 1.5)



# Add Element Vectors -----------------------------------------------------
## fit elements to nmds
elements.fit.k5 <- envfit(odata_core_nojb.nmds5 ~ B11.e + Ba138.e + Li7.e + Mg24.e + Mn55.e + Pb208.e + Sr88.e + Zn66.e, data = combo_nojb)

## plot element vectors
plot(elements.fit.k5, col = "black")









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




