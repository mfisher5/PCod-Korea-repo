############### PCA ANALYSIS AND GRAPHING #####################

## From Eleni Petrou for Herring 
## MF Edited 5/9/2017 for Pacific Cod



install.packages("gplots")
library(adegenet)
library(hierfstat)
library (gplots)
#library(RColorBrewer)
#display.brewer.all()
#display.rich.colors()
install.packages("gplots")

getwd()
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses")


#################### RETAINED INDIVIDUALS #############
# First, read in your data as a genepop file.The file
# can be delimited by tabs or spaces but there must abe a comma after each individual. 
# Specify how many characters code each allele with ncode. 
my_data_all <-read.genepop("../stacks_b8_wgenome/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredRepsC.gen")

# To retreive useful data summaries
(summary(my_data_all))
my_data_all$pop

# To view missing data information
sum(is.na(my_data_all$tab))

# To replace missing data information with the mean
X <- scaleGen(my_data_all, NA.method="mean")

# To conduct the PCA. IF YOU DO NOT KNOW HOW MANY AXES TO RETAIN
pca_all <- dudi.pca(X,cent=FALSE,scale=FALSE)
barplot(pca_all$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca_all)

# To conduct the PCA. IF YOU KNOW HOW MANY AXES TO RETAIN
pca_all <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=2) #nf = number to retain
barplot(pca_all$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca_all)


#To graph the data

#Color of points / legend
col <- c("gray","mediumorchid1","aquamarine","firebrick4","chartreuse","deepskyblue", "deepskyblue4", "coral1", "mediumorchid4")
col_gss <- c("gray","mediumorchid1","aquamarine","firebrick4","chartreuse","deepskyblue4", "deepskyblue4", "coral1", "mediumorchid1")
col_leg_gss <- c("firebrick4","coral1","aquamarine","mediumorchid1","deepskyblue4", "gray","chartreuse")
col_leg <- c("firebrick4","coral1","aquamarine","mediumorchid4", "mediumorchid1","deepskyblue", "deepskyblue4", "gray","chartreuse")
points_leg <- c(17,17,16,16,16,16, 16, 16,15)

#adjust graph area
par(cex.axis = 0.7, mar = c(5, 4, 4, 4), cex.lab = 0.8, xpd = TRUE)

#to graph as a cluster of sample names
s.label(pca_all$li)

#to graph with lines between samples
s.class(pca_all$li, fac=pop(my_data_all), 
        col=col, #color of points. will retain lines between points
        clabel=0, #remove population labels
        cellipse=0, #remove ellipses; to add back in, make >=1
        cpoint=1.5,
        pch=c(16,16,16,17,15,16, 16, 17, 16)[as.numeric(pop(my_data_all))], #change point shapes
        axesell=TRUE)
legend ("bottomleft", legend = c("YellowSea '16", "Boryeong '07", "Namhae '15", "Geoje '14-15", "Geoje '14", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Pohang '15", "Jukbyeon '07"), col = col_leg, border = FALSE, bty = "n", cex = 0.9, pt.cex=1.5, y.intersp = 1, title = "Population",pch=points_leg)
add.scatter.eig(pca_all$eig[1:50],posi="top", 3,2,1,ratio=.2)
add.scatter.eig(pca_all$eig[1:50],posi="bottom", 3,2,1,ratio=.2)

#to graph without lines between samples, transparent points
s.class(pca_all$li, fac=pop(my_data_all),
        xax=1,yax=2, 
        col=transp(col,.6), 
        clabel = 0, 
        axesell=TRUE,
        cstar=0, 
        cpoint=2,
        pch=c(16,16,16,17,15, 16, 16, 17, 16)[as.numeric(pop(my_data_all))])
legend ("topleft", legend = c("YellowSea '16", "Boryeong '07", "Namhae '15", "Geoje '15", "Geoje '14", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Pohang '15", "Jukbyeon '07"), fill = col_leg, border = FALSE, bty = "n", cex = 0.9, y.intersp = 1, title = "Population")
?s.class

add.scatter.eig(pca_all$eig[1:50],3,1,2, ratio=.2)



summary(pca_all)
## -- Eigenvalues 
#Total inertia: 10770

#eigenvalues:
# Ax1     Ax2     Ax3     Ax4     Ax5 
# 333.14  175.33   95.47   87.48   84.84


## -- Eigenvalues as percentages of the total variation in the data
eig.perc <- 100*pca_all$eig/sum(pca_all$eig)
head(eig.perc)
# [1] 3.0940182 1.6283776 0.8867000 0.8124261 0.7879322 0.7854512


## -- Which alleles are contributing the most to showing the diversity among pops?

loadingplot(pca_all$c1^2)

## -- what are the individual coordinates on the plot?
cor(pca_all$li)
install.packages("devtools")
library("devtools")
install_github("kassambara/factoextra")
library("factoextra")
pca_all_coords <- get_pca_ind(pca_all)
pca_all_coords$coord

# -- what are the x and y axis limits?
par('xaxp') # 0,60
par('yaxp') # 0,350




#to graph with lines between samples GSS
s.class(pca_all$li, fac=pop(my_data_all), 
        col=col_gss, #color of points. will retain lines between points
        clabel=0, #remove population labels
        cellipse=0, #remove ellipses; to add back in, make >=1
        cpoint=1.5,
        pch=c(16,16,16,17,15,16, 16, 17, 16)[as.numeric(pop(my_data_all))], #change point shapes
        axesell=TRUE)
legend ("bottomleft", legend = c("YellowSea '16", "Boryeong '07", "Namhae '15", "Geoje '14-15", "Jin. Bay '07", "Pohang '15", "Jukbyeon '07"), col = col_leg_gss, border = FALSE, bty = "n", cex = 0.9, pt.cex=1.5, y.intersp = 1, title = "Population",pch=points_leg)
add.scatter.eig(pca_all$eig[1:50],posi="bottom", 3,2,1,ratio=.3)











#################### SOUTHERN INDIVIDUALS #############
# First, read in your data as a genepop file.The file
# can be delimited by tabs or spaces but there must abe a comma after each individual. 
# Specify how many characters code each allele with ncode. 
my_data_south <-read.genepop("../analyses/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredRepsC_south.gen")



# To retreive useful data summaries
(summary(my_data_south))
my_data_south$pop

# To view missing data information
sum(is.na(my_data_south$tab))

# To replace missing data information with the mean
XS <- scaleGen(my_data_south, NA.method="mean")

# To conduct the PCA. IF YOU DO NOT KNOW HOW MANY AXES TO RETAIN
pca_south <- dudi.pca(XS,cent=FALSE,scale=FALSE)
barplot(pca_south$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))



#To graph the data

#Color of points / legend
col <- c("gray","mediumorchid1","aquamarine","deepskyblue", "deepskyblue4", "mediumorchid4")
col_gss <- c("gray","mediumorchid1","aquamarine","deepskyblue4", "deepskyblue4","mediumorchid1")
col_leg_gss <- c("firebrick4","coral1","aquamarine","mediumorchid1","deepskyblue4", "gray","chartreuse")
points_leg <- c(16,16,16,16, 16, 16)

#adjust graph area
par(cex.axis = 0.7, mar = c(5, 4, 4, 4), cex.lab = 0.8, xpd = TRUE)

#to graph as a cluster of sample names
s.label(pca_all$li)

#to graph with lines between samples
s.class(pca_south$li, fac=pop(my_data_south), 
        col=col, #color of points. will retain lines between points
        clabel=0, #remove population labels
        cellipse=0, #remove ellipses; to add back in, make >=1
        cpoint=1.5,
        pch=16, #change point shapes
        axesell=TRUE)
legend ("bottomleft", legend = c("Namhae '15", "Geoje '15", "Geoje '14", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Pohang '15"), col = col_leg, border = FALSE, bty = "n", cex = 0.9, pt.cex=1.5, y.intersp = 1, title = "Population",pch=points_leg)
add.scatter.eig(pca_all$eig[1:50],posi="top", 3,2,1,ratio=.2)
add.scatter.eig(pca_all$eig[1:50],posi="bottom", 3,2,1,ratio=.2)




summary(pca_all)
## -- Eigenvalues 
#Total inertia: 10770

#eigenvalues:
#  Ax1     Ax2     Ax3     Ax4     Ax5 
# 224.6   158.9   132.4   129.2   125.8 


## -- Eigenvalues as percentages of the total variation in the data
eig.perc <- 100*pca_all$eig/sum(pca_all$eig)
head(eig.perc)
# [1] 3.5163457 1.4696136 0.9513576 0.8459531 0.8046527 0.7691684


## -- Which alleles are contributing the most to showing the diversity among pops?

loadingplot(pca_all$c1^2)

## -- what are the individual coordinates on the plot?
cor(pca_all$li)
install.packages("devtools")
library("devtools")
install_github("kassambara/factoextra")
library("factoextra")
pca_all_coords <- get_pca_ind(pca_all)
pca_all_coords$coord





#to graph with lines between samples GSS
s.class(pca_south$li, fac=pop(my_data_south), 
        col=col_gss, #color of points. will retain lines between points
        clabel=0, #remove population labels
        cellipse=0, #remove ellipses; to add back in, make >=1
        cpoint=1.5,
        pch=16, #change point shapes
        axesell=TRUE)
legend ("bottomleft", legend = c("Namhae '15", "Geoje '14-15", "Jin. Bay '07", "Pohang '15"), col = col_leg_gss, border = FALSE, bty = "n", cex = 0.9, pt.cex=1.5, y.intersp = 1, title = "Population",pch=points_leg)
add.scatter.eig(pca_all$eig[1:50],posi="bottom", 3,2,1,ratio=.3)






#################### SOUTHERN INDIVIDUALS NO MIGRANTS #############
# First, read in your data as a genepop file.The file
# can be delimited by tabs or spaces but there must abe a comma after each individual. 
# Specify how many characters code each allele with ncode. 
my_data_south_nm <-read.genepop("../analyses/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredRepsC_south_nomigrants.gen")




# To replace missing data information with the mean
XSnm <- scaleGen(my_data_south_nm, NA.method="mean") 

# To conduct the PCA. IF YOU DO NOT KNOW HOW MANY AXES TO RETAIN
pca_south_nm <- dudi.pca(XSnm,cent=FALSE,scale=FALSE) #4 axes
barplot(pca_south_nm$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))



#Color of points / legend
col <- c("gray","mediumorchid1","aquamarine","deepskyblue", "deepskyblue4", "mediumorchid4")
col_gss <- c("gray","mediumorchid1","aquamarine","deepskyblue4", "deepskyblue4","mediumorchid1")
col_leg_gss <- c("firebrick4","coral1","aquamarine","mediumorchid1","deepskyblue4", "gray","chartreuse")
points_leg <- c(16,16,16,16, 16, 16)

#adjust graph area
par(cex.axis = 0.7, mar = c(5, 4, 4, 4), cex.lab = 0.8, xpd = TRUE)

#to graph as a cluster of sample names
s.label(pca_all$li)

#to graph with lines between samples
s.class(pca_south$li, fac=pop(my_data_south), 
        col=col, #color of points. will retain lines between points
        clabel=0, #remove population labels
        cellipse=0, #remove ellipses; to add back in, make >=1
        cpoint=1.5,
        pch=16, #change point shapes
        axesell=TRUE)
legend ("bottomleft", legend = c("Namhae '15", "Geoje '15", "Geoje '14", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Pohang '15"), col = col_leg, border = FALSE, bty = "n", cex = 0.9, pt.cex=1.5, y.intersp = 1, title = "Population",pch=points_leg)
add.scatter.eig(pca_all$eig[1:50],posi="top", 3,2,1,ratio=.2)
add.scatter.eig(pca_all$eig[1:50],posi="bottom", 3,2,1,ratio=.2)




summary(pca_all)
## -- Eigenvalues 
#Total inertia: 10770

#eigenvalues:
#  Ax1     Ax2     Ax3     Ax4     Ax5 
# 224.6   158.9   132.4   129.2   125.8 


## -- Eigenvalues as percentages of the total variation in the data
eig.perc <- 100*pca_all$eig/sum(pca_all$eig)
head(eig.perc)
# [1] 3.5163457 1.4696136 0.9513576 0.8459531 0.8046527 0.7691684


## -- Which alleles are contributing the most to showing the diversity among pops?

loadingplot(pca_all$c1^2)

## -- what are the individual coordinates on the plot?
cor(pca_all$li)
install.packages("devtools")
library("devtools")
install_github("kassambara/factoextra")
library("factoextra")
pca_all_coords <- get_pca_ind(pca_all)
pca_all_coords$coord





#to graph with lines between samples GSS
s.class(pca_south_nm$li, fac=pop(my_data_south_nm), 
        col=col_gss, #color of points. will retain lines between points
        clabel=0, #remove population labels
        cellipse=0, #remove ellipses; to add back in, make >=1
        cpoint=1.5,
        pch=16, #change point shapes
        axesell=TRUE)
legend ("bottomleft", legend = c("Namhae '15", "Geoje '14-15", "Jin. Bay '07", "Pohang '15"), col = col_leg_gss, border = FALSE, bty = "n", cex = 0.9, pt.cex=1.5, y.intersp = 1, title = "Population",pch=points_leg)
add.scatter.eig(pca_south_nm$eig[1:50],posi="bottom", 3,2,1,ratio=.3)


s.label(pca_south_nm$li)

