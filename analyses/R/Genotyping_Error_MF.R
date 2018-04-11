############# plot % mismatches between replicates ##########
#
# MF 4/11/2018
#
#################################################################

library(readr)
library(dplyr)
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo")



# Read in data ------------------------------------------------------------
mydata <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/stacks_b8_verif/batch_8_verif_replicates_mismatches.txt", "\t", escape_double = FALSE, trim_ws = TRUE)
head(mydata)



# plot --------------------------------------------------------------------
ggplot(mydata, aes(x=loci.genotyped, y=p.mismatch)) +
  geom_point(size=2) +
  facet_wrap(~type) +
  xlab("Number of Loci Genotyped in Both Samples") +
  ylab("Percent Mismatched Genotypes") +
  theme(axis.title = element_text(size=14), axis.text = element_text(size=14))


ggplot(mydata, aes(x=diff.missing, y=p.mismatch)) +
  geom_point(size=2) +
  facet_wrap(~type) +
  xlab("Difference in # Loci with Missing Data") +
  ylab("Percent Mismatched Genotypes") +
  theme(axis.title = element_text(size=14), axis.text = element_text(size=14))




# Filter Samples <5,000 Loci ----------------------------------------------
mydata_filtered <- mydata %>%
  filter(loci.genotyped > 5000) %>%
  filter(diff.missing < 300)
ggplot(mydata_filtered, aes(x=type, y=p.mismatch, group=type)) +
  geom_boxplot() +
  ylab("Percent of Genotypes Mismatched") +
  theme(axis.title.y = element_text(size=14), axis.title.x = element_blank(), axis.text = element_text(size=14))

mydata_filtered %>% group_by(type) %>% summarise(avg = mean(p.mismatch))




# Plot DAPC to Compare All Replicates ------------------------------------
## to do this, you need a genepop file containing your replicates 
library(ape)
library(ade4)
library(adegenet)
mydata <-read.genepop("stacks_b8_verif/batch_8_replicates_south_DAPC.gen")
## run dapc
mydata_dapc <- dapc(mydata,mydata$pop,n.pca=234,n.da=5) 
## find optimal number of principal components
test_a_score <- optim.a.score(mydata_dapc) 
## run dapc only on optimal number of principal components
mydata_dapc <- dapc(mydata,mydata$pop,n.pca=14,n.da=5)

## plot
#pop_cols <- c("gray45", "deepskyblue","mediumorchid2", "mediumorchid4", "chartreuse","coral1","firebrick4")
#col_leg <- c("firebrick4","coral1","mediumorchid4", "mediumorchid1","deepskyblue", "gray","chartreuse")

pop_cols <- c("gray45", "deepskyblue","deepskyblue4","mediumorchid2", "mediumorchid4")
col_leg <- c("mediumorchid4", "mediumorchid1","deepskyblue","deepskyblue4", "grey45")


scatter(mydata_dapc,scree.da=FALSE, posi.da="bottomright", scree.pca = FALSE, posi.pca = "bottomleft", cellipse=0,leg=FALSE,label=c("", "", "", "", ""), pch = 19,csub=2,cex=1.5,col = pop_cols, clabel=1,solid=0.7, inset.solid=0.7)

legend (x=-13, y=11.5, legend = c( "Geoje '14-'15", "Geoje '13-'14", "Jin. Bay Dec.", "Jin. Bay Feb.","Pohang"), col = col_leg, border = FALSE, bty = "n", cex = 0.9, pt.cex=1.5, y.intersp = 1, title = "Sampling Site",pch=19)



# DAPC to Compare 300ng & 500ng --------------------------------------------------------------------
mydata <-read.genepop("stacks_b8_verif/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredCR_south_nomigrants_300ng.gen")
summary(mydata)
## run pca
X <- scaleGen(mydata, NA.method="mean")
pca_all <- dudi.pca(X,cent=FALSE,scale=FALSE)
barplot(pca_all$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca_all)
pca_all <- dudi.pca(X,cent=FALSE,scale=FALSE, nf=2, scannf=FALSE)




## create the population labels for the legend and set the colors for each population##
col <- c("darkgray","mediumorchid1","aquamarine2","deepskyblue", "deepskyblue4","mediumorchid4", "orange")
pop_labels <- c("Pohang '15", "Geoje '15", "Namhae '15", "Jin. Bay '07 Dec.", "Jin. Bay '07 Feb.", "Geoje '14", "Geoje '14 500ng")
col_leg <- c("mediumorchid4", "mediumorchid1","orange","deepskyblue","deepskyblue4", "grey45")
s.class(pca_all$li, fac=pop(mydata), 
        col=col, #color of points. will retain lines between points
        clabel=0, #remove population labels
        cellipse=0, #remove ellipses; to add back in, make >=1
        cpoint=1.5,
        grid=FALSE, #otherwise will have light gray grid markers
        pch=19, #change point shapes
        axesell=TRUE)

legend (x=35, y=45, legend = c( "Geoje '14-'15", "Geoje '13-'14", "Geoje '13-'14 500ng","Jin. Bay Dec.", "Jin. Bay Feb.","Pohang"), col = col_leg, border = FALSE, bty = "n", cex = 0.9, pt.cex=1.5, y.intersp = 1, title = "Sampling Site",pch=19)

