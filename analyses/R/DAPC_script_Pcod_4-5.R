######================ R CODE FOR CREATING DAPC PLOTS ==================#####


## MF 5/9/2017 for Korea PCod data
## Based off of Charlie Waters' DAPC and PCA code 

# First set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses")

# Load all necessary R packages
install.packages("ape")
install.packages("ade4")
install.packages("adegenet")
library(ape)
library(ade4)
library(adegenet)
library(diveRsity)
library(doParallel)
library(foreach)
library(genetics)
library(hierfstat)
library(httpuv)
library(iterators)
library(sendplot)
library(xlsx)
library(pegas)
library(plotrix)

###################################################################################
# Let's first run a DAPC with all individuals and all loci

## read in genepop
b6i30<-read.genepop("../stacks_b6_wgenome/batch_6.filteredMAF_filteredLoci_30filteredIndivids_filteredHWE.gen")
summary(KoreaPcod)

## note that there are 120 individuals in the file: POH = 28, GE15 = 33, NAM = 16, YS = 7, BOR = 3, GE14 = 32, SM = 1



Pohang15 <- rep("POH15",31)
Geoje15 <- rep("GE15",33)
Namhae15 <- rep("NAM15",16)
YellowSea16 <- rep("YS16",24)
Jukbyeon07 <- rep("JUK07",25)
JinhaeBayEarly <- rep("JBE",21)
JinhaeBayLate <- rep("JBL",34)
Boryeong07 <- rep("BOR07", 20)
Geoje14 <- rep("GE14", 30)


pop_groups <- as.factor(c(rep("POH15",31),rep("GE15",33),rep("NAM15",16),rep("YS16",24),rep("JBE",21),rep("JBE",21), rep("JBL",34), rep("BOR07", 20), rep("GE14", 30)))
pop_labels <- c("Pohang '15", "Geoje '15", "Namhae '15", "YellowSea '16", "Jukbyeon '07", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Boryeong '07", "Geoje '14")
pop_cols <- c("seagreen1","mediumorchid1","darkgoldenrod","firebrick4","chartreuse","deepskyblue", "deepskyblue4", "coral1", "mediumorchid4")

## run dapc
dapc_all <- dapc(KoreaPcod,KoreaPcod$pop,n.pca=234,n.da=9) ##Retain all, then identify optimal number by optim.a.score
## find optimal number of principal components
test_a_score <- optim.a.score(dapc_all)
## run dapc only on optimal number of principal components
dapc_all <- dapc(KoreaPcod,KoreaPcod$pop,n.pca=28,n.da=9) ##28 PC's is the optimal number

#2D plot WITH ALL POPULATIONS
scatter(dapc_all,scree.da=FALSE,cellipse=0,leg=FALSE,label=c("POH15","GE15","NAM15","YS16","JUK07","JBE", "JBL","BOR07", "GE14"), posi.da="bottomleft",csub=2,col=pop_cols,cex=1.5,clabel=1,pch=c(19),solid=1)
legend(x = 5, y = 8,bty='n', legend = pop_labels,pch=c(19),col=pop_cols,cex=1)

#2D plot WITH CLUSTERING
test_snpzip<-snpzip(KoreaPcod,dapc_all,loading.plot=TRUE,method="median", label=c("POH15","GE15","NAM15","YS16","JUK07","JBE", "JBL","BOR07", "GE14"), col=pop_cols) 

###########################################################################################



###################################################################################
# ALL INDIVIDUALS, NO REPS

## read in genepop
noreps <-read.genepop("../analyses/batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_noreps.gen")
summary(noreps)

## total 213 individuals

Pohang15 <- rep("POH15",30)
Geoje15 <- rep("GE15",33)
Namhae15 <- rep("NAM15",16)
YellowSea16 <- rep("YS16",23)
Jukbyeon07 <- rep("JUK07",22)
JinhaeBayEarly <- rep("JBE",20)
JinhaeBayLate <- rep("JBL",29)
Boryeong07 <- rep("BOR07", 20)
Geoje14 <- rep("GE14", 20)



pop_labels <- c("Pohang '15", "Geoje '15", "Namhae '15", "SeaBlock '16", "Jukbyeon '07", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Boryeong '07", "Geoje '14")

pop_cols <- c("#999999","#CC79A7","#E69F00","#EECC16","#009E73","#56B4E9", "deepskyblue4", "#D55E00", "coral1")


pop_cols_orig <- c("seagreen1","mediumorchid1","darkgoldenrod","firebrick4","chartreuse","deepskyblue", "deepskyblue4", "coral1", "mediumorchid4")

## run dapc
dapc_noreps <- dapc(noreps,noreps$pop,n.pca=70,n.da=9) ##Retain all, then identify optimal number by optim.a.score
## find optimal number of principal components
test_a_score <- optim.a.score(dapc_noreps)
## run dapc only on optimal number of principal components
dapc_noreps <- dapc(noreps,noreps$pop,n.pca=14,n.da=9) ##14 PC's is the optimal number

#2D plot WITH ALL POPULATIONS
scatter(dapc_noreps,scree.da=TRUE, posi.pca = "bottomright", scree.pca = FALSE, cellipse=0,leg=FALSE,label=c("POH15","GE15","NAM15","SB16","JUK07","JBE", "JBL","BOR07", "GE14"), pch = c(19, 19, 19, 17, 15, 19, 19, 17, 19), posi.da="bottomleft",csub=2,col=pop_cols,cex=1.5,clabel=1,solid=0.7, inset.solid=0.7)
summary(dapc_noreps)
dapc_noreps$ind.coord

## extract first two columns and plot as scatter with new labels

legend("left",bty='n', legend = c("West", "South", "East"),pch = c(19, 17, 15),col=pop_cols,cex=1)



dapc_noreps$var  ### Proportion of variance conserved by the principal components
#0.1460506
dapc_noreps$eig[1]/sum(dapc_noreps$eig)  ### Variance explained by first discriminant function
#0.6265693
dapc_noreps$eig[2]/sum(dapc_noreps$eig)  ### Variance explained by second discriminant function
#0.3008403

dapc_noreps$ind.coord


#2D plot WITH CLUSTERING
test_snpzip<-snpzip(noreps,dapc_noreps,loading.plot=TRUE,method="median", label=c("POH15","GE15","NAM15","YS16","JUK07","JBE", "JBL","BOR07", "GE14"), col=pop_cols) 

###########################################################################################



###################################################################################
# TEMPORAL REPLICATES COMBINED; BORYEONG AND SEA BLOCK 161 COMBINED #


## read in genepop
combo <-read.genepop("batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_noreps_combo.gen")
summary(combo)




pop_labels <- c("Pohang", "Geoje", "Namhae", "Yellow Sea", "Jukbyeon", "Jinhae")

pop_cols <- c("#999999","#CC79A7","#E69F00","#EECC16","#009E73","#56B4E9")



## run dapc
dapc_combo <- dapc(combo,combo$pop,n.pca=70,n.da=6) ##Retain all, then identify optimal number by optim.a.score
## find optimal number of principal components
test_a_score <- optim.a.score(dapc_combo)
## run dapc only on optimal number of principal components
dapc_combo <- dapc(combo,combo$pop,n.pca=6,n.da=6) ##14 PC's is the optimal number

#2D plot WITH ALL POPULATIONS
scatter(dapc_combo,scree.da=TRUE, posi.pca = "bottomright", scree.pca = FALSE, cellipse=0,leg=FALSE,label=c("POH","GE","NAM","YS","JUK","JIN"), pch = c(19, 19, 19, 17, 15, 19), posi.da="bottomleft",csub=2,col=pop_cols,cex=1.5,clabel=1,solid=0.7, inset.solid=0.7)
summary(dapc_combo)
dapc_noreps$ind.coord




dapc_combo$var  ### Proportion of variance conserved by the principal components
#0.08746617
dapc_combo$eig[1]/sum(dapc_combo$eig)  ### Variance explained by first discriminant function
#0.675528
dapc_combo$eig[2]/sum(dapc_combo$eig)  ### Variance explained by second discriminant function
#0.3107449

dapc_combo$ind.coord


assignplot(dapc_combo, subset = 1:50)

compoplot(dapc_combo, posi = "bottomright", subset = 1:30, txt.leg=pop_labels, lab = "", ncol = 1, xlab = "individuals", col = pop_cols)


compoplot(dapc_combo, posi = "bottomright", subset = 32:65, txt.leg=pop_labels, lab = "", ncol = 1, xlab = "individuals", col = pop_cols)

###########################################################################################



###################################################################################

## Run DAPC on all samples EXCEPT Yellow Sea and Boryeong. 
## read in genepop
noYSBOR <-read.genepop("batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_noreps_noYSBOR.gen")
summary(noYSBOR)

# total number of individuals = 170

Pohang15 <- rep("POH15",30)
Geoje15 <- rep("GE15",33)
Namhae15 <- rep("NAM15",16)
Jukbyeon07 <- rep("JUK07",22)
JinhaeBayEarly <- rep("JBE",20)
JinhaeBayLate <- rep("JBL",29)
Geoje14 <- rep("GE14", 20)


pop_labels <- c("Pohang '15", "Geoje '15", "Namhae '15", "Jukbyeon '07", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Geoje '14")

pop_cols <- c("#999999","#CC79A7","#E69F00","#009E73","#56B4E9", "deepskyblue4", "coral1")

## run dapc
dapc_noYSBOR <- dapc(noYSBOR,noYSBOR$pop,n.pca=55,n.da=7) ##Retain all, then identify optimal number by optim.a.score
## find optimal number of principal components
test_a_score <- optim.a.score(dapc_noYSBOR)
## run dapc only on optimal number of principal components
dapc_noYSBOR <- dapc(noYSBOR,noYSBOR$pop,n.pca=28,n.da=7) ##28 PC's is the optimal number

#2D plot WITH ALL POPULATIONS
scatter(dapc_noYSBOR,scree.da=TRUE, posi.pca = "bottomright", scree.pca = FALSE, cellipse=0,leg=FALSE,label=c("POH15","GE15","NAM15","JUK07","JBE", "JBL", "GE14"), pch = c(19, 19, 19, 15, 19, 19, 19), posi.da="bottomright",csub=2,col=pop_cols,cex=1.5,clabel=1,solid=0.7, inset.solid=0.7)
legend(x = 5, y = -1,bty='n', legend = pop_labels,pch=c(19),col=pop_cols,cex=1)

dapc_noYSBOR$ind.coord # To get loading factor coordinates per individual

summary(dapc_noYSBOR)  # To get assignment probabilities ($assign)

dapc_noYSBOR$var  ### Proportion of variance conserved by the principal components
#0.2705905
dapc_noYSBOR$eig[1]/sum(dapc_noYSBOR$eig)  ### Variance explained by first discriminant function
#0.8468807
dapc_noYSBOR$eig[2]/sum(dapc_noYSBOR$eig)  ### Variance explained by second discriminant function
#0.06732317





#2D plot WITH CLUSTERING
test_snpzip<-snpzip(KoreaPcod,dapc_all,loading.plot=TRUE,method="median", label=c("POH15","GE15","NAM15","YS16","JUK07","JBE", "JBL","BOR07", "GE14"), col=pop_cols) 


###########################################################################################



###################################################################################

## Run DAPC on all samples that DID NOT have abnormal tag numbers after the first round of ustacks 
## read in genepop
safe <-read.genepop("batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_noreps_noHighTags.gen")
summary(safe)


#200 individuals

Pohang15 <- rep("POH15",30)
Geoje15 <- rep("GE15",33)
Namhae15 <- rep("NAM15",16)
YellowSea16 <- rep("YS16",16)
Jukbyeon07 <- rep("JUK07",22)
JinhaeBayEarly <- rep("JBE",20)
JinhaeBayLate <- rep("JBL",29)
Boryeong07 <- rep("BOR07", 14)
Geoje14 <- rep("GE14", 20)



pop_labels <- c("Pohang '15", "Geoje '15", "Namhae '15", "YellowSea '16", "Jukbyeon '07", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Boryeong '07", "Geoje '14")
pop_cols <- c("seagreen1","mediumorchid1","darkgoldenrod","firebrick4","chartreuse","deepskyblue", "deepskyblue4", "coral1", "mediumorchid4")

## run dapc
dapc_safe_all <- dapc(safe,safe$pop,n.pca=65,n.da=9) ##Retain all, then identify optimal number by optim.a.score
## find optimal number of principal components
test_a_score <- optim.a.score(dapc_safe_all)
## run dapc only on optimal number of principal components
dapc_safe_all <- dapc(safe,safe$pop,n.pca=35,n.da=9) ##21 PC's is the optimal number

#2D plot WITH ALL POPULATIONS
scatter(dapc_safe_all,scree.da=TRUE, posi.pca = "bottomright", scree.pca = FALSE, cellipse=0,leg=FALSE,label=c("POH15","GE15","NAM15","YS16","JUK07","JBE", "JBL","BOR07", "GE14"), pch = c(19, 19, 19, 17, 15, 19, 19, 17, 19), posi.da="bottomright",csub=2,col=pop_cols,cex=1.5,clabel=1,solid=0.7, inset.solid=0.7)
legend(x = 5, y = 8,bty='n', legend = pop_labels,pch=c(19),col=pop_cols,cex=1)

#2D plot WITH CLUSTERING
test_snpzip<-snpzip(KoreaPcod,dapc_all,loading.plot=TRUE,method="median", label=c("POH15","GE15","NAM15","YS16","JUK07","JBE", "JBL","BOR07", "GE14"), col=pop_cols) 



## Run DAPC on all samples that DID NOT have abnormal tag numbers after the first round of ustacks 
## read in genepop
safe_all <-read.genepop("../analyses/batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_noHighTags.gen")
summary(safe_all)


#######################################################################################


###### Run DAPC on ONLY SOUTHERN SAMPLES WITH NO REPLICATES ############################




## read in genepop
south <-read.genepop("batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_noreps_south.gen")
summary(south)



Pohang15 <- rep("POH15",31)
Geoje15 <- rep("GE15",33)
Namhae15 <- rep("NAM15",16)
JinhaeBayEarly <- rep("JBE",20)
JinhaeBayLate <- rep("JBL",32)
Geoje14 <- rep("GE14", 20)



pop_labels <- c("Pohang '15", "Geoje '15", "Namhae '15", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Geoje '14")

pop_cols <- c("#999999","#CC79A7","#E69F00", "#56B4E9", "deepskyblue4", "coral1")


dapc1 <- dapc(south, grp$grp)

grp <- find.clusters(south, max.n.clust=20)


## run dapc
dapc_south <- dapc(south,south$pop,n.pca=50,n.da=6) ##Retain all, then identify optimal number by optim.a.score
## find optimal number of principal components
test_a_score <- optim.a.score(dapc_south)
## run dapc only on optimal number of principal components
dapc_south <- dapc(south,south$pop,n.pca=40,n.da=6) ##40 PC's is the optimal number



#2D plot WITH ALL POPULATIONS
scatter(xax = 1, yax = 2, dapc_south,scree.da=TRUE, posi.da="topleft", scree.pca = FALSE, posi.pca = "topleft", cellipse=0,leg=FALSE,label=c("POH15","GE15","NAM15","JBE", "JBL", "GE14"), pch = c(19, 19, 19, 19, 19, 19),csub=2,col=pop_cols,cex=1.5,clabel=1,solid=0.9, inset.solid=0.7)


summary(dapc_south)  # To get assignment probabilities ($assign)

dapc_south$var  ### Proportion of variance conserved by the principal components
#0.3949879
dapc_south$eig[1]/sum(dapc_south$eig)  ### Variance explained by first discriminant function
#0.4008412
dapc_south$eig[2]/sum(dapc_south$eig)  ### Variance explained by second discriminant function
#0.2177612











## add legend
legend("bottomright",bty='n', legend = pop_labels,pch=c(19, 19, 19, 17, 15, 19, 19, 17, 19),col=pop_cols,cex=1)

?scatter

dapc_south$ind.coord

#2D plot WITH CLUSTERING
test_snpzip<-snpzip(KoreaPcod,dapc_all,loading.plot=TRUE,method="median", label=c("POH15","GE15","NAM15","YS16","JUK07","JBE", "JBL","BOR07", "GE14"), col=pop_cols) 



#######################################################################################


###### Run DAPC on ONLY SOUTHERN SAMPLES WITH NO TEMPORAL OR SAMPLE REPLICATES ############################




## read in genepop
south_combo <-read.genepop("batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_south_combo.gen")
summary(south_combo)



Pohang15 <- rep("POH15",31)
Geoje15 <- rep("GE15",33)
Namhae15 <- rep("NAM15",16)
JinhaeBayEarly <- rep("JBE",20)
JinhaeBayLate <- rep("JBL",32)
Geoje14 <- rep("GE14", 20)



pop_labels <- c("Pohang '15", "Geoje '15", "Namhae '15", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Geoje '14")

pop_cols <- c("#999999","#CC79A7","#E69F00", "#56B4E9", "deepskyblue4", "coral1")


dapc1 <- dapc(south_combo, grp$grp)

grp <- find.clusters(south, max.n.clust=20)


## run dapc
dapc_south_combo <- dapc(south_combo,south_combo$pop,n.pca=50,n.da=4) ##Retain all, then identify optimal number by optim.a.score
## find optimal number of principal components
test_a_score <- optim.a.score(dapc_south_combo)
## run dapc only on optimal number of principal components
dapc_south_combo <- dapc(south_combo,south_combo$pop,n.pca=37,n.da=4) ##37 PC's is the optimal number



#2D plot WITH ALL POPULATIONS
scatter(xax = 1, yax = 2, dapc_south_combo,scree.da=TRUE, posi.da="topleft", scree.pca = FALSE, posi.pca = "topleft", cellipse=0,leg=FALSE,label=c("POH","GE","NAM","JIN"), pch = c(19, 19, 19, 19),csub=2,col=pop_cols,cex=1.5,clabel=1,solid=0.9, inset.solid=0.7)

dapc_south_combo$ind.coord

summary(dapc_south_combo)  # To get assignment probabilities ($assign)

dapc_south_combo$var  ### Proportion of variance conserved by the principal components
#0.3903558
dapc_south_combo$eig[1]/sum(dapc_south_combo$eig)  ### Variance explained by first discriminant function
#0.5303903
dapc_south_combo$eig[2]/sum(dapc_south_combo$eig)  ### Variance explained by second discriminant function
#0.3449362






