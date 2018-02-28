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

## make data frame of only edge concentrations
odata_edge <- odata[,10:17]
head(odata_edge)


# Relativize by maximum ---------------------------------------------------
odata_edge.mrel <- decostand(odata_edge, method="max")
head(odata_edge.mrel)
par(mfrow=c(2,4))
boxplot(odata_edge.mrel$B11.e, main = "B11.e")
boxplot(odata_edge.mrel$Ba138.e, main = "Ba138.e")
boxplot(odata_edge.mrel$Li7.e, main = "Li7.e")
boxplot(odata_edge.mrel$Mg24.e, main = "Mg24.e")
boxplot(odata_edge.mrel$Mn55.e, main = "Mn55.e")
boxplot(odata_edge.mrel$Pb208.e, main = "Pb208.e")
boxplot(odata_edge.mrel$Sr88.e, main = "Sr88.e")
boxplot(odata_edge.mrel$Zn66.e, main = "Zn66.e")
write.csv(odata_edge.mrel, file = "data/PCod_Korea_Microchem_edge_filtered_relativized.csv", row.names=FALSE)




# Find optimal value of K for NMDS --------------------------------------------------------------------
## create distance matrix
edge.mrel_dist <- dist(odata_edge.mrel, method = "euclidean")
View(odata_edge.mrel)

## how many unique site / year combos?
unique(odata_combo$SiteYear)
ks <- c(1,2,3,4,5,6,7)

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


# NMDS with K = 7 --------------------------------------------------------- WARNING MESSAGE
odata_edge.nmds7 <- metaMDS(comm = edge.mrel_dist, autotransform = FALSE,
                                distance = "euc", engine = "monoMDS", k = 7, weakties = TRUE,
                                model = "global", maxit = 400, try = 40, trymax = 200,
                                wascores = TRUE)

odata_edge.nmds7


# Evaluate Fit NMDS K=7 ---------------------------------------------------
stressplot(object=odata_edge.nmds7, lwd=2)


# Plot basic NMDS ---------------------------------------------------
## base plot function
plot(odata_edge.nmds7)
## Warning message:
## In ordiplot(x, choices = choices, type = type, display = display,  :
              ## Species scores not available

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
  

# Base Plot NMDS color-coded -------------------------------------
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



# Add ellipses etc. -------------------------------------------------------
ordiellipse(odata_edge.nmds7, odata_combo$SiteYear, col=c("darkorange", "gold2", "#8dd3c7", "#80b1d3", "#bebada", "#b3de69", "#fb8072"), kind = "sd", lty = 2, lwd = 1.5)



# Add Element Vectors -----------------------------------------------------
## fit elements to nmds
elements.fit <- envfit(odata_edge.nmds7 ~ B11.e + Ba138.e + Li7.e + Mg24.e + Mn55.e + Pb208.e + Sr88.e + Zn66.e, data = odata_combo)

## plot element vectors
plot(elements.fit, col = "black")





################################ RUN NMDS WITHOUT JINHAE BAY ##############################################


# subset data -------------------------------------------------------------
## subset response + explanatory variables
combo_nojb <- subset(odata_combo, Sampling.Site != "JinhaeBay")

## subset just response matrix
edge_elements <- colnames(odata_edge)
edge_nojb <- select(combo_nojb, edge_elements); View(edge_nojb)
dim(edge_nojb)



# relativize data ---------------------------------------------------------
edge_nojb.mrel <- decostand(edge_nojb, method="max")



# NMDS k = 1 through 5 ----------------------------------------------------
## create distance matrix
edge_nojb_dist <- dist(edge_nojb.mrel, method = "euclidean")

## how many unique site / year combos?
unique(combo_nojb$SiteYear)
ks <- c(1,2,3,4,5)

## run nmds for k = 1 through 7 and save stress values
stresses <- c()
for(k in ks){
  odata_edge.nmds <- metaMDS(comm = edge_nojb_dist, autotransform = FALSE,
                             distance = "euc", engine = "monoMDS", k = k, weakties = TRUE,
                             model = "global", maxit = 400, try = 40, trymax = 200,
                             wascores = TRUE)
  stresses[k] <- odata_edge.nmds$stress
}

## plot k v. stress
plot(ks,stresses, xlab="K", ylab="stress", main="Value of K v. Stress of NMDS")

# NMDS with K = 7 --------------------------------------------------------- WARNING MESSAGE
odata_edge_nojb.nmds5 <- metaMDS(comm = edge_nojb_dist, autotransform = FALSE,
                            distance = "euc", engine = "monoMDS", k = 5, weakties = TRUE,
                            model = "global", maxit = 400, try = 40, trymax = 200,
                            wascores = TRUE)

odata_edge_nojb.nmds5


# Evaluate Fit NMDS K=7 ---------------------------------------------------
stressplot(object=odata_edge_nojb.nmds5, lwd=2)


# Base Plot NMDS color-coded -------------------------------------
plot(odata_edge_nojb.nmds5, xaxt = "n", yaxt = "n", xlab = "", ylab = "", main = "NMDS without Jinhae Bay\nMicrochemistry from Otolith Edge")
## set colors for points based on sampling site
points(odata_edge_nojb.nmds5$points[combo_nojb$SiteYear == "Pohang_2015",], 
       pch = 19, col = "#b3de69", cex = 1.2)
points(odata_edge_nojb.nmds5$points[combo_nojb$SiteYear == "Geoje_2015",], 
       pch = 19, col = "gold2", cex = 1.2)
points(odata_edge_nojb.nmds5$points[combo_nojb$SiteYear == "Namhae_2015",], 
       pch = 19, col = "#bebada", cex = 1.2)
points(odata_edge_nojb.nmds5$points[combo_nojb$SiteYear == "YSBlock_2016",], 
       pch = 19, col = "#fb8072", cex = 1.2)
points(odata_edge_nojb.nmds5$points[combo_nojb$SiteYear == "Geoje_2014",], 
       pch = 19, col = "darkorange", cex = 1.2)
## add legend
legend(x="topleft", pch = 19, bty="n", cex = 1, pt.cex = 1.2,
       col = c("#fb8072", "#bebada", "darkorange", "gold2", "#b3de69"), 
       legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "Pohang '15"), title = "Sampling Site")


# Add ellipses etc. -------------------------------------------------------
ordiellipse(odata_edge_nojb.nmds5, combo_nojb$SiteYear, col=c("darkorange", "gold2", "#bebada", "#b3de69", "#fb8072"), kind = "sd", lty = 2, lwd = 1.5)



# Add Element Vectors -----------------------------------------------------
## fit elements to nmds
elements.fit <- envfit(odata_edge_nojb.nmds5 ~ B11.e + Ba138.e + Li7.e + Mg24.e + Mn55.e + Pb208.e + Sr88.e + Zn66.e, data = combo)

## plot element vectors
plot(elements.fit, col = "black")


