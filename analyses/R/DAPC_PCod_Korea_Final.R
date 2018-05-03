############### DAPC ANALYSIS AND GRAPHING #####################
#
## Based off of Charlie Waters' DAPC and PCA code 
## MF Edited 4/11/2018 for Pacific Cod, southern sites
#
###############################################################


# Load packages  ----------------------------------------------------------
library(ape)
library(ade4)
library(adegenet)



# Read in Data ------------------------------------------------------------
## set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses")

## data
mydata <-read.genepop("../stacks_b8_verif/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredCR_south_nomigrants.gen")
summary(mydata)




# Run DAPC ----------------------------------------------------------------

## run dapc
mydata_dapc <- dapc(mydata,mydata$pop,n.pca=234,n.da=6) ##Retain all pca / da, then identify optimal number by optim.a.score (see below). 


## find optimal number of principal components
test_a_score <- optim.a.score(mydata_dapc) ##Use graph to identify optimal number of PCs


## run dapc only on optimal number of principal components
mydata_dapc <- dapc(mydata,mydata$pop,n.pca=25,n.da=9) ##25 PCs is the optimal number here







# Plot DAPC ---------------------------------------------------------------

## create the population labels for the legend and set the colors for each population##
pop_labels <- c("Pohang '15", "Geoje '15", "Namhae '15", "Jin. Bay '07 Dec.", "Jin. Bay '07 Feb.", "Geoje '14")
pop_cols <- c("gray45","mediumorchid4","seagreen1","deepskyblue", "deepskyblue4", "mediumorchid2")



## Create 2D plot with DAPC output (for DA eigenvalues or PCA make `scree.da` / `scree.pca` TRUE)
scatter(mydata_dapc,scree.da=FALSE, posi.da="bottomright", scree.pca = FALSE, posi.pca = "bottomleft", cellipse=0,leg=FALSE,label=c("POH","GE'15","NAM","JB Dec.", "JB Feb.","GE'14"), pch = 19,csub=2,col=pop_cols,cex=1.5,clabel=1,solid=0.7, inset.solid=0.7)

## add legend
legend(x=-3.75,y=-2, bty = 'n', legend = pop_labels,pch=19,col=pop_cols,cex=1, pt.cex = 2, title="Sampling Site")
## add eigenvalues
add.scatter.eig(mydata_dapc$eig[1:5],posi="bottomright", 3,2,1,ratio=.2)


## -- Eigenvalues as percentages of the total variation in the data
eig.perc <- 100*mydata_dapc$eig/sum(mydata_dapc$eig)
head(eig.perc)

