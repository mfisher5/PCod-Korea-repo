######================ R CODE FOR CREATING DAPC PLOTS ==================#####


## MF 5/9/2017 for Korea PCod data
## Based off of Charlie Waters' DAPC and PCA code 



# First set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses")

# Load all necessary R packages
library(ape)
library(ade4)
library(adegenet)


###################################################################################

#### LOAD IN (GENETIC) DATA ####
noreps <-read.genepop("../analyses/batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_noreps.gen")
summary(noreps)




#### RUNNING DAPC ANALYSIS ####

## run dapc
dapc_all <- dapc(noreps,noreps$pop,n.pca=234,n.da=9) ##Retain all pca / da, then identify optimal number by optim.a.score (see below)


## find optimal number of principal components
test_a_score <- optim.a.score(dapc_all) ##Use graph to identify optimal number of PCs


## run dapc only on optimal number of principal components
dapc_all <- dapc(noreps,noreps$pop,n.pca=28,n.da=9) ##28 PCs is the optimal number here



#### GRAPHING DAPC ANALYSIS ####


# arguments for "scatter" can be found on page 34 of the adegenet manual: https://cran.r-project.org/web/packages/adegenet/adegenet.pdf
# or on the site `RDocumentation` at https://www.rdocumentation.org/packages/adegenet/versions/2.0.1/topics/dapc%20graphics


## create the population labels for the legend and set the colors for each population##
pop_labels <- c("Pohang '15", "Geoje '15", "Namhae '15", "YellowSea '16", "Jukbyeon '07", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Boryeong '07", "Geoje '14")
pop_cols <- c("seagreen1","mediumorchid1","darkgoldenrod","firebrick4","chartreuse","deepskyblue", "deepskyblue4", "coral1", "mediumorchid4")



## Create 2D plot with DAPC output (for DA eigenvalues or PCA make `scree.da` / `scree.pca` TRUE)
scatter(dapc_noreps,scree.da=FALSE, posi.da="bottomright", scree.pca = FALSE, posi.pca = "bottomleft", cellipse=0,leg=FALSE,label=c("POH15","GE15","NAM15","YS16","JUK07","JBE", "JBL","BOR07", "GE14"), pch = c(19, 19, 19, 17, 15, 19, 19, 17, 19),csub=2,col=pop_cols,cex=1.5,clabel=1,solid=0.7, inset.solid=0.7)

## add legend
legend("bottomright",bty='n', legend = pop_labels,pch=c(19, 19, 19, 17, 15, 19, 19, 17, 19),col=pop_cols,cex=1)



