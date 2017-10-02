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

################################################################################################################################

############# Let's first run a DAPC with all individuals  #############

## read in genepop
alldata<-read.genepop("../stacks_b8_wgenome/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredRepsC.gen")
summary(alldata)

## note that there are 256 individuals in the file: POH = 31, GE15 = 32, NAM = 13, YS = 25, JUK = 33, JBE = 40, JBL = 36, BOR = 22, GE14 = 24


pop_groups <- as.factor(c(rep("POH15",30),rep("GE15",33),rep("NAM15",16),rep("YS16",23),rep("JUK",22),rep("JBE",32), rep("JBL",26), rep("BOR07", 22), rep("GE14", 22)))
pop_labels <- c("Pohang '15", "Geoje '15", "Namhae '15", "YellowSea '16", "Jukbyeon '07", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Boryeong '07", "Geoje '14")
pop_cols <- c("seagreen1","mediumorchid1","darkgoldenrod","firebrick4","chartreuse","deepskyblue", "deepskyblue4", "coral1", "mediumorchid4")

## run dapc
dapc_all <- dapc(alldata,alldata$pop,n.pca=84,n.da=9) ##Retain all (259/3), then identify optimal number by optim.a.score
## find optimal number of principal components
test_a_score <- optim.a.score(dapc_all)
## run dapc only on optimal number of principal components
dapc_all <- dapc(alldata,alldata$pop,n.pca=30,n.da=9) ##30 PC's is the optimal number

#2D plot WITH ALL POPULATIONS
scatter(dapc_all,scree.da=TRUE, posi.pca = "bottomright", scree.pca = FALSE, cellipse=0,leg=FALSE,label=c("POH15","GE15","NAM15","SB16","JUK07","JBE", "JBL","BOR07", "GE14"), pch = c(19, 19, 19, 17, 15, 19, 19, 17, 19), posi.da="topleft",csub=2,col=pop_cols,cex=1.5,clabel=1,solid=0.7, inset.solid=0.7)

legend(x = 27, y = -350, bty='n', legend = pop_labels,pch=c(19, 19, 19, 17, 15, 19, 19, 17, 19),col=pop_cols)


dapc_all$var  ### Proportion of variance conserved by the principal components
#0.2369589
dapc_all$eig[1]/sum(dapc_all$eig)  ### Variance explained by first discriminant function
# 0.6276672
dapc_all$eig[2]/sum(dapc_all$eig)  ### Variance explained by second discriminant function
#0.2607412

summary(dapc_all)
$n.dim
[1] 8

$n.pop
[1] 9

$assign.prop
[1] 0.6484375

$assign.per.pop
PO010715_07_rep     GE011215_11   NA021015_30   YS_121316_07    JUK07_33 
0.5161290       0.8125000       0.3076923       0.8800000       0.8787879 
JB121807_29 JB021108_11_rep      BOR07_21_2  GEO020414_30_2 
0.6000000       0.5833333       0.7727273       0.2916667 

###########################################################################################



#######################################################################################


###### Run DAPC on ONLY SOUTHERN SAMPLES  ############################


## read in genepop
south <-read.genepop("batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredRepsC_south.gen")
summary(south)

## note that there are 176 individuals in the file: POH = 31, GE15 = 32, NAM = 13, JBE = 40, JBL = 36, GE14 = 24


Pohang15 <- rep("POH15",30)
Geoje15 <- rep("GE15",33)
Namhae15 <- rep("NAM15",16)
Geoje14 <- rep("GE14", 32)
JinhaeBayEarly <- rep("JBE",26)
JinhaeBayLate <- rep("JBL",22)



pop_labels <- c("Pohang '15", "Geoje '15", "Namhae '15", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Geoje '14")

pop_cols <- c("#999999","#CC79A7","#E69F00", "#56B4E9", "deepskyblue4", "coral1")


## run dapc
dapc_south <- dapc(south,south$pop,n.pca=57,n.da=6) ##Retain all, then identify optimal number by optim.a.score
## find optimal number of principal components
test_a_score <- optim.a.score(dapc_south)
## run dapc only on optimal number of principal components
dapc_south <- dapc(south,south$pop,n.pca=57,n.da=6) ##57 PC's is the optimal number



#2D plot WITH ALL POPULATIONS
scatter(xax = 1, yax = 2, dapc_south,scree.da=TRUE, posi.da="bottomleft", scree.pca = FALSE, posi.pca = "bottomleft", cellipse=0,leg=FALSE,label=c("POH15","GE15","NAM15","JBE", "JBL", "GE14"), pch = c(19, 19, 19, 19, 19, 19),csub=2,col=pop_cols,cex=1.5,clabel=1,solid=0.9, inset.solid=0.7)


legend("top", bty='n', legend = pop_labels,pch=19,col=pop_cols)





dapc_south$var  ### Proportion of variance conserved by the principal components
# 0.4816039
dapc_south$eig[1]/sum(dapc_south$eig)  ### Variance explained by first discriminant function
#0.3589432
dapc_south$eig[2]/sum(dapc_south$eig)  ### Variance explained by second discriminant function
#0.2267812

summary(dapc_south)  # To get assignment probabilities ($assign)
$n.dim
[1] 5

## OUTPUT
$n.dim
[1] 5

$n.pop
[1] 6

$assign.prop
[1] 0.7897727

$assign.per.pop
PO010715_07_rep     GE011215_11     NA021015_30     JB121807_29 JB021108_11_rep 
0.8064516       0.9687500       0.8461538       0.7250000       0.6944444 
GEO020414_30_2 
0.7500000 

$prior.grp.size

PO010715_07_rep     GE011215_11     NA021015_30     JB121807_29 JB021108_11_rep 
31              32              13              40              36 
GEO020414_30_2 
24 

$post.grp.size

PO010715_07_rep     GE011215_11     NA021015_30     JB121807_29 JB021108_11_rep 
32              34              12              41              37 
GEO020414_30_2 
20 


##################################################################################################################################


##################################################################################################################################

############## DAPC of Western populations only #############

## read in genepop
west<-read.genepop("batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredRepsC_west.gen")
summary(west)

## note that there are 47 individuals in the file: YS = 25, BOR = 22


pop_labels <- c("YellowSea '16", "Boryeong '07")
pop_cols <- c("firebrick4","mediumorchid4")

## run dapc
dapc_west <- dapc(west,west$pop,n.pca=15,n.da=2) ##Retain all (223/3), then identify optimal number by optim.a.score
## find optimal number of principal components
test_a_score <- optim.a.score(dapc_west)
## run dapc only on optimal number of principal components
dapc_west <- dapc(west,west$pop,n.pca=10,n.da=2) ##10 PC's is the optimal number

#2D plot WITH ALL POPULATIONS
scatter(dapc_west,scree.da=TRUE, posi.pca = "bottomright", scree.pca = FALSE, cellipse=0,leg=FALSE,label=c("SB16","BOR07"), pch = c(17, 17), posi.da="topright",csub=2,col=pop_cols,cex=1.5,clabel=1,solid=0.7, inset.solid=0.7)


legend("topright", bty='n', legend = pop_labels,pch=c(17, 17),col=pop_cols)


dapc_west$var  ### Proportion of variance conserved by the principal components
#0.2699075
dapc_west$eig[1]/sum(dapc_west$eig)  ### Variance explained by first discriminant function
# 1
dapc_west$eig[2]/sum(dapc_west$eig)  ### Variance explained by second discriminant function
# NA


summary(dapc_west) #get assignment probabilities

$n.pop
[1] 2

$assign.prop
[1] 0.9148936

$assign.per.pop
YS_121316_07   BOR07_21_2 
0.9200000    0.9090909 

$prior.grp.size

YS_121316_07   BOR07_21_2 
25           22 

$post.grp.size

YS_121316_07   BOR07_21_2 
25           22 

####################################################################################################

####################################################################################################

####################################################################################################

pop_cols <- c("#999999","#CC79A7","#E69F00", "#56B4E9", "deepskyblue4", "coral1")
assignplot(dapc_south, subset = 1:100)


compoplot(dapc_west)


## note that there are 179 individuals in the file: POH = 31, GE15 = 32, NAM = 16, JBE = 40, JBL = 36, GE14 = 24

# pohang
compoplot(dapc_south, subset = 1:31)

# namhae
compoplot(dapc_south, subset = 64:79) ### WHY DOES THIS INCLUDE CONTAMINATED NAMHAE SAMPLES????

# JB07
compoplot(dapc_south, subset = 80:119)

# JB08

