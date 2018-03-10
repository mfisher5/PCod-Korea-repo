######## RUN NMDS ON RELATIVIZED OTOLITH DATA ############
#
# MF 2/25/2018
# for SEFS 502 Final Project
# 
#############################################################

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


## set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/otolith_analyses")


# Load data ---------------------------------------------------------------
odata <- read.csv("data/PCod_Korea_Microchem_filtered.txt", header=TRUE, sep="\t")
odata_ex <- read.csv("data/PCod_Korea_ExpData_filtered.txt", header=TRUE, sep="\t")

dim(odata)
dim(odata_ex)



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
par(mfrow=c(1,1))
write.csv(odata_el.mrel, file = "data/PCod_Korea_Microchem_filtered_relativized.csv", row.names=FALSE)


## make data frame of only edge concentrations
odata_edge.mrel <- odata_el.mrel[,9:16]
head(odata_edge.mrel)
odata_core.mrel <- odata_el.mrel[,1:8]
head(odata_core.mrel)



##################################### entire data set #############################################

# Find optimal value of K for NMDS --------------------------------------------------------------------
## create distance matrix
edge.mrel_dist <- dist(odata_edge.mrel, method = "euclidean")
head(edge.mrel_dist)

## how many unique site / year combos?
unique(odata_combo$SiteYear)
ks <- c(1,2,3,4,5,6,7,8,9,10)

## run nmds for k = 1 through 7 and save stress values
stresses <- c()
for(k in ks){
  odata_edge.nmds <- metaMDS(comm = edge.mrel_dist, autotransform = FALSE,
                                  distance = "euc", engine = "monoMDS", k = k, weakties = TRUE,
                                  model = "global", maxit = 400, try = 40, trymax = 200,
                                  wascores = TRUE)
  stresses[k] <- odata_edge.nmds$stress
}

## plot k v. stress
plot(ks,stresses, xlab="K", ylab="stress", main="Value of K v. Stress of NMDS")


# NMDS --------------------------------------------------------- 
## k = 7, according to stresses
odata_edge.nmds7 <- metaMDS(comm = edge.mrel_dist, autotransform = FALSE,
                                distance = "euc", engine = "monoMDS", k = 7, weakties = TRUE,
                                model = "global", maxit = 400, try = 40, trymax = 200,
                                wascores = TRUE)

## k = 2, for best visualization
odata_edge.nmds2 <- metaMDS(comm = edge.mrel_dist, autotransform = FALSE,
                            distance = "euc", engine = "monoMDS", k = 2, weakties = TRUE,
                            model = "global", maxit = 400, try = 40, trymax = 200,
                            wascores = TRUE)


# Evaluate Fit ---------------------------------------------------
## k = 7
stressplot(object=odata_edge.nmds7, lwd=2)

## k = 2
stressplot(object=odata_edge.nmds2, lwd=2)


# Plot NMDS with ggplot---------------------------------------------------
## base plot function
plot(odata_edge.nmds7)
## Warning message:
## In ordiplot(x, choices = choices, type = type, display = display,  :
              ## Species scores not available
plot(odata_edge.nmds2)

## ggplot
nmds_points <- data.frame(scores(odata_edge.nmds7)); nmds_points #because of warning above, had to convert data

ggplot(nmds_points, aes(x=NMDS1, y=NMDS2)) +
  geom_point()



## color coding based on population, using combined data frame
##-- note that the combined data frame and response data frame must have same ORDER of samples!
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
  

# Plot NMDS color-coded, K=7 -------------------------------------
plot(odata_edge.nmds7, xaxt = "n", yaxt = "n", xlab = "", ylab = "", main = "NMDS\nMicrochemistry from Otolith Edge")
## set colors for points based on sampling site
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
## add legend
legend(x="topright", pch = 19, bty="n", cex = 1, pt.cex = 1.2,
       col = c("#fb8072", "#bebada", "darkorange", "gold2", "#8dd3c7", "#80b1d3", "#b3de69"), 
       legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "JinhaeBay '07e", "JinhaeBay '07l", "Pohang '15"), title = "Sampling Site")


## add ellipses
ordiellipse(odata_edge.nmds7, odata_combo$SiteYear, col=c("darkorange", "gold2", "#8dd3c7", "#80b1d3", "#bebada", "#b3de69", "#fb8072"), kind = "sd", lty = 2, lwd = 1.5)


## fit elements to nmds
elements.fit <- envfit(odata_edge.nmds7 ~ B11.e + Ba138.e + Li7.e + Mg24.e + Mn55.e + Pb208.e + Sr88.e + Zn66.e, data = odata_combo)

## plot element vectors
plot(elements.fit, col = "black")


# Plot NMDS color-coded, K=2 -------------------------------------
plot(odata_edge.nmds2, xaxt = "n", yaxt = "n", xlab = "", ylab = "", main = "NMDS\nMicrochemistry from Otolith Edge")
## set colors for points based on sampling site
points(odata_edge.nmds2$points[odata_combo$SiteYear == "Pohang_2015",], 
       pch = 19, col = "#b3de69", cex = 1.2)
points(odata_edge.nmds2$points[odata_combo$SiteYear == "Geoje_2015",], 
       pch = 19, col = "gold2", cex = 1.2)
points(odata_edge.nmds2$points[odata_combo$SiteYear == "Namhae_2015",], 
       pch = 19, col = "#bebada", cex = 1.2)
points(odata_edge.nmds2$points[odata_combo$SiteYear == "YSBlock_2016",], 
       pch = 19, col = "#fb8072", cex = 1.2)
points(odata_edge.nmds2$points[odata_combo$SiteYear == "JinhaeBay_2007",], 
       pch = 19, col = "#8dd3c7", cex = 1.2)
points(odata_edge.nmds2$points[odata_combo$SiteYear == "JinhaeBay_2008",], 
       pch = 19, col = "#80b1d3", cex = 1.2)
points(odata_edge.nmds2$points[odata_combo$SiteYear == "Geoje_2014",], 
       pch = 19, col = "darkorange", cex = 1.2)
## add legend
legend(x="bottomright", pch = 19, cex = 1, pt.cex = 1.2,
       col = c("#fb8072", "#bebada", "darkorange", "gold2", "#8dd3c7", "#80b1d3", "#b3de69"), 
       legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "JinhaeBay '07e", "JinhaeBay '07l", "Pohang '15"), title = "Sampling Site")


## add ellipses
ordiellipse(odata_edge.nmds2, odata_combo$SiteYear, col=c("darkorange", "gold2", "#8dd3c7", "#80b1d3", "#bebada", "#b3de69", "#fb8072"), kind = "sd", lty = 2, lwd = 1.5)


## fit elements to nmds
elements.fit <- envfit(odata_edge.nmds2 ~ B11.e + Ba138.e + Li7.e + Mg24.e + Mn55.e + Pb208.e + Sr88.e + Zn66.e, data = odata_combo)

## plot element vectors
plot(elements.fit, col = "black")







##################################### without Pohang #############################################


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


