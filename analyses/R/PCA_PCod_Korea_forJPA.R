############### PCA ANALYSIS AND GRAPHING #####################

## From Eleni Petrou for Herring 
## MF Edited 5/9/2017 for Pacific Cod

###############################################################


# Load packages  ----------------------------------------------------------
install.packages("adegenet")
install.packages("hierfstat")
install.packages("gplots")
library(adegenet)
library(hierfstat)
library (gplots)




############################# PCA WITH ALL INDIVIDUALS #############################
# Read in Data as a genepop file ------------------------------------------------------------
# File can be delimited by tabs or spaces but there must abe a comma after each individual. 
# Specify how many characters code each allele with ncode. 
my_data_all <-read.genepop("../../stacks_b8_verif/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredCR.gen")

# To retreive useful data summaries
(summary(my_data_all))
my_data_all$pop

# To replace missing data information with the mean
X <- scaleGen(my_data_all, NA.method="mean")


# Run PCA -----------------------------------------------------------------
# To conduct the PCA. IF YOU DO NOT KNOW HOW MANY AXES TO RETAIN
pca_all <- dudi.pca(X,cent=FALSE,scale=FALSE)
barplot(pca_all$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca_all)

# To conduct the PCA. IF YOU KNOW HOW MANY AXES TO RETAIN
pca_all <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=2) #nf = number to retain
barplot(pca_all$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca_all)




# Plot PCA ----------------------------------------------------------------


#Color of points (order in genepop)
col <- c("darkgray","mediumorchid1","aquamarine2","firebrick4","chartreuse","deepskyblue", "deepskyblue4", "coral1", "mediumorchid4")
#Color of legend (order easier to read)
col_leg <- c("firebrick4","coral1","aquamarine2","mediumorchid4", "mediumorchid1","deepskyblue", "deepskyblue4", "gray","chartreuse")
#Point shapes for legend (here is by region)
points_leg <- c(16,17,16,16,16,16, 16, 16,17)

#to graph with lines between samples
s.class(pca_all$li, fac=pop(my_data_all), 
        col=col, #color of points. will retain lines between points
        clabel=0, #remove population labels
        cellipse=0, #remove ellipses; to add back in, make >=1
        cpoint=1.5,
        grid=FALSE, #otherwise will have light gray grid markers
        pch=c(16,16,16,16,17,16, 16, 17, 16)[as.numeric(pop(my_data_all))], #change point shapes
        axesell=TRUE)
# add legend
legend ("topleft", legend = c("YellowSeaBlock", "Boryeong", "Namhae", "Geoje '14-'15", "Geoje '13-'14", "Jinhae Bay Dec.", "Jinhae Bay Feb.", "Pohang", "Jukbyeon"), col = col_leg, border = FALSE, bty = "n", cex = 0.9, pt.cex=1.5, y.intersp = 1, title = "Sampling Site",pch=points_leg)
# add eigenvalues plot as inset
add.scatter.eig(pca_all$eig[1:50],posi="bottom", 3,2,1,ratio=.2)

## -- Eigenvalues as percentages of the total variation in the data
eig.perc <- 100*pca_all$eig/sum(pca_all$eig)
head(eig.perc)

library(factoextra)
pca_all_coords <- get_pca_ind(pca_all)
pca_all_coords$coord


























############################# PCA WITH SOUTHERN INDIVIDUALS, NO MIGRANTS #############################
# Read in Data as a genepop file ------------------------------------------------------------
# File can be delimited by tabs or spaces but there must abe a comma after each individual. 
# Specify how many characters code each allele with ncode. 
my_data_south <-read.genepop("../../stacks_b8_verif/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredCR_south_nomigrants.gen")

# To retreive useful data summaries
(summary(my_data_south))
my_data_south$pop

# To replace missing data information with the mean
X <- scaleGen(my_data_south, NA.method="mean")


# Run PCA -----------------------------------------------------------------
# To conduct the PCA. IF YOU DO NOT KNOW HOW MANY AXES TO RETAIN
pca_south <- dudi.pca(X,cent=FALSE,scale=FALSE)
barplot(pca_south$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca_south)

# To conduct the PCA. IF YOU KNOW HOW MANY AXES TO RETAIN
pca_south <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=2) #nf = number to retain
barplot(pca_south$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca_south)




# Plot PCA ----------------------------------------------------------------


#Color of points (order in genepop)
col <- c("darkgray","mediumorchid1","aquamarine2","deepskyblue", "deepskyblue4", "mediumorchid4")
#Color of legend (order easier to read)
col_leg <- c("aquamarine2","mediumorchid4", "mediumorchid1","deepskyblue", "deepskyblue4", "gray")
#Point shapes for legend (here is by region)
points_leg <- c(16,16,16,16, 16, 16)

#to graph with lines between samples
s.class(pca_south$li, fac=pop(my_data_south), 
        col=col, #color of points. will retain lines between points
        clabel=0, #remove population labels
        cellipse=0, #remove ellipses; to add back in, make >=1
        cpoint=1.5,
        grid=FALSE, #otherwise will have light gray grid markers
        pch=16, #change point shapes
        axesell=TRUE)
# add legend
legend ("bottomleft", legend = c("Namhae", "Geoje '14-'15", "Geoje '13-'14", "Jinhae Bay Dec.", "Jinhae Bay Feb.", "Pohang"), col = col_leg, border = FALSE, bty = "n", cex = 0.9, pt.cex=1.5, y.intersp = 1, title = "Sampling Site",pch=points_leg)
# add eigenvalues plot as inset
add.scatter.eig(pca_south$eig[1:50],posi="bottomright", 3,2,1,ratio=.2)

## -- Eigenvalues as percentages of the total variation in the data
eig.perc <- 100*pca_south$eig/sum(pca_south$eig)
head(eig.perc)



















