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

# To conduct the PCA
pca3 <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=3)
barplot(pca3$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca3)

s.label(pca3$li)
?dudi.pca
#To graph the data

#Different color options. Choose one.
#col <- rich.colors(8, palette = "temperature", plot = TRUE)
#col  <- brewer.pal(9, "Paired")
col <- c("darkslateblue", "blue4", "dodgerblue3", "cyan3", "lawngreen", "deeppink2", "goldenrod1", "plum1", "firebrick3" )
col <- c("seagreen1","mediumorchid1","darkgoldenrod","firebrick4","chartreuse","deepskyblue", "deepskyblue4", "coral1", "mediumorchid4")

par(cex.axis = 0.7, mar = c(5, 4, 4, 4), cex.lab = 0.8, xpd = TRUE)

s.class(pca3$li, pop(my_data_all),
        xax=1,yax=2, 
        col=transp(col,.6), 
        clabel = 0, 
        axesell=FALSE,
        cstar=0, 
        cpoint=2, 
        grid=FALSE, 
        pch=c(16,16,16,16,16, 16, 16, 16, 16)[as.numeric(pop(my_data))])


legend ("topleft", legend = c("Pohang '15", "Geoje '15", "Namhae '15", "YellowSea '16", "Jukbyeon '07", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Boryeong '07", "Geoje '14"), 
        fill = col, 
        border = FALSE, bty = "n", cex = 0.9, y.intersp = 1, 
        title = "Population")





#################### RETAINED INDIVIDUALS (MINUS YS AND BOR INDIVIDUALS WITH HIGH NUMBERS OF TAGS) #############
# First, read in your data as a genepop file.The file
# can be delimited by tabs or spaces but there must abe a comma after each individual. 
# Specify how many characters code each allele with ncode. 
my_data <-read.genepop("../analyses/batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_noHighTags.gen")

# To retreive useful data summaries
(summary(my_data))
my_data$pop

# To view missing data information
sum(is.na(my_data$tab))

# To replace missing data information with the mean
X <- scaleGen(noYSBOR, NA.method="mean")

# To conduct the PCA
pca1 <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=3)
barplot(pca1$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca1)

s.label(pca1$li)

#To graph the data

#Different color options. Choose one.
#col <- rich.colors(8, palette = "temperature", plot = TRUE)
#col  <- brewer.pal(9, "Paired")
col <- c("darkslateblue", "blue4", "dodgerblue3", "cyan3", "lawngreen", "deeppink2", "goldenrod1", "plum1", "firebrick3" )
col <- c("seagreen1","mediumorchid1","darkgoldenrod","firebrick4","chartreuse","deepskyblue", "deepskyblue4", "coral1", "mediumorchid4")

par(cex.axis = 0.7, mar = c(5, 4, 4, 4), cex.lab = 0.8, xpd = TRUE)

s.class(pca1$li, pop(noYSBOR),
        xax=1,yax=2, 
        col=transp(col,.6), 
        clabel = 0, 
        axesell=FALSE,
        cstar=0, 
        cpoint=2, 
        grid=FALSE, 
        pch=c(16,16,16,16,16, 16, 16, 16, 16)[as.numeric(pop(noYSBOR))])


legend ("topleft", legend = c("Pohang '15", "Geoje '15", "Namhae '15", "YellowSea '16", "Jukbyeon '07", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Boryeong '07", "Geoje '14"), 
        fill = col, 
        border = FALSE, bty = "n", cex = 0.9, y.intersp = 1, 
        title = "Population")



#################### SOUTHERN POPULATIONS ONLY #############
# First, read in your data as a genepop file.The file
# can be delimited by tabs or spaces but there must abe a comma after each individual. 
# Specify how many characters code each allele with ncode. 
my_data_south <-read.genepop("../analyses/batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_south.gen")

# To retreive useful data summaries
(summary(my_data_south))
my_data_south$pop

# To view missing data information
sum(is.na(my_data_south$tab))

# To replace missing data information with the mean
X <- scaleGen(my_data_south, NA.method="mean")

# To conduct the PCA
pca2 <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=3)
barplot(pca2$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca2)
?dudi.pca
s.label(pca2$li)
pca2$li

#To graph the data

#Different color options. Choose one.
#col <- rich.colors(8, palette = "temperature", plot = TRUE)
#col  <- brewer.pal(9, "Paired")

col <- c("seagreen1","mediumorchid1","darkgoldenrod","deepskyblue", "deepskyblue4", "mediumorchid4")

par(cex.axis = 0.7, mar = c(5, 4, 4, 4), cex.lab = 0.8, xpd = TRUE)

s.class(pca2$li, pop(my_data_south),
        xax=1,yax=2, 
        col=transp(col,.6), 
        clabel = 0, 
        axesell=FALSE,
        cstar=0, 
        cpoint=2, 
        grid=FALSE, 
        pch=c(16,16,16,16,16, 16, 16, 16, 16)[as.numeric(pop(my_data))])


legend ("topleft", legend = c("Pohang '15", "Geoje '15", "Namhae '15", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Geoje '14"), 
        fill = col, 
        border = FALSE, bty = "n", cex = 0.9, y.intersp = 1, 
        title = "Population")



  #################### SOUTHERN POPULATIONS WITH OUTLIERS REMOVED #############
# First, read in your data as a genepop file.The file
# can be delimited by tabs or spaces but there must abe a comma after each individual. 
# Specify how many characters code each allele with ncode. 
south_noout <-read.genepop("../analyses/batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_south_rmoutliers.gen")

# To retreive useful data summaries
(summary(south_noout))
south_noout$pop

# To view missing data information
sum(is.na(south_noout$tab))

# To replace missing data information with the mean
X <- scaleGen(south_noout, NA.method="mean")

# To conduct the PCA
pca2 <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=3)
barplot(pca2$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca2)
?dudi.pca
s.label(pca2$li)
pca2$li

#To graph the data

#Different color options. Choose one.
#col <- rich.colors(8, palette = "temperature", plot = TRUE)
#col  <- brewer.pal(9, "Paired")

col <- c("seagreen1","mediumorchid1","darkgoldenrod","deepskyblue", "deepskyblue4", "mediumorchid4")

par(cex.axis = 0.7, mar = c(5, 4, 4, 4), cex.lab = 0.8, xpd = TRUE)

s.class(pca2$li, pop(south_noout),
        xax=1,yax=2, 
        col=transp(col,.6), 
        clabel = 0, 
        axesell=TRUE,
        cstar=0, 
        cpoint=2, 
        grid=FALSE, 
        addaxes = TRUE,
        pch=c(16,16,16,16,16, 16, 16, 16, 16)[as.numeric(pop(south_noout))])
?s.class

legend ("topright", legend = c("Pohang '15", "Geoje '15", "Namhae '15", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Geoje '14"), 
        fill = col, 
        border = FALSE, bty = "n", cex = 0.9, y.intersp = 1, 
        title = "Population")



