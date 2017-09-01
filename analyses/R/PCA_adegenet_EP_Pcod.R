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
noreps <-read.genepop("batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_noreps.gen")

# To retreive useful data summaries
(summary(noreps))
noreps$pop

# To view missing data information
sum(is.na(noreps$tab))

# To replace missing data information with the mean
X <- scaleGen(noreps, NA.method="mean")

# To conduct the PCA
pca1 <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=3)
barplot(pca1$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca1)

s.label(pca1$li)
?dudi.pca
#To graph the data

#Different color options. Choose one.
#col <- rich.colors(8, palette = "temperature", plot = TRUE)
#col  <- brewer.pal(9, "Paired")


col <- c("#999999","#CC79A7","#E69F00","#EECC16","#009E73","#56B4E9", "deepskyblue4", "#D55E00", "coral1")


par(cex.axis = 0.7, mar = c(5, 4, 4, 4), cex.lab = 0.8, xpd = TRUE)

s.class(pca1$li, pop(noreps),
        xax=1,yax=2, 
        col=transp(col,.6), 
        clabel = 0, 
        axesell=FALSE,
        cstar=0, 
        cpoint=2, 
        grid=FALSE, 
        pch=c(16,16,16,16,16, 16, 16, 16, 16)[as.numeric(pop(noreps))])


legend ("topleft", legend = c("Pohang '15", "Geoje '15", "Namhae '15", "YellowSea '16", "Jukbyeon '07", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Boryeong '07", "Geoje '14"), 
        fill = col, 
        border = FALSE, bty = "n", cex = 0.9, y.intersp = 1, 
        title = "Population")

pca3$li



#################### RETAINED INDIVIDUALS (MINUS YS AND BOR INDIVIDUALS WITH HIGH NUMBERS OF TAGS) <--- note that this does include replicates! #############
# First, read in your data as a genepop file.The file
# can be delimited by tabs or spaces but there must abe a comma after each individual. 
# Specify how many characters code each allele with ncode. 
noYSBOR <-read.genepop("../analyses/batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_noHighTags.gen")

# To retreive useful data summaries
(summary(noYSBOR))
noYSBOR$pop

# To view missing data information
sum(is.na(noYSBOR$tab))

# To replace missing data information with the mean
X <- scaleGen(noYSBOR, NA.method="mean")

# To conduct the PCA
pca2 <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=3)
barplot(pca2$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca2)



#To graph the data

#Different color options. Choose one.
#col <- rich.colors(8, palette = "temperature", plot = TRUE)
#col  <- brewer.pal(9, "Paired")
col <- c("#999999","#CC79A7","#E69F00","#009E73","#56B4E9", "deepskyblue4", "coral1")

par(cex.axis = 0.7, mar = c(5, 4, 4, 4), cex.lab = 0.8, xpd = TRUE)

s.class(pca2$li, pop(noYSBOR),
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
south <-read.genepop("../analyses/batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_noreps_south.gen")

# To retreive useful data summaries
(summary(south))
south$pop

# To view missing data information
sum(is.na(south$tab))

# To replace missing data information with the mean
X <- scaleGen(south, NA.method="mean")

# To conduct the PCA
pca3 <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=3)
barplot(pca3$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca3)
?dudi.pca
s.label(pca3$li)
pca3$li

#To graph the data

#Different color options. Choose one.
#col <- rich.colors(8, palette = "temperature", plot = TRUE)
#col  <- brewer.pal(9, "Paired")

col <- c("#999999","#CC79A7","#E69F00", "#56B4E9", "deepskyblue4", "coral1")

par(cex.axis = 0.7, mar = c(5, 4, 4, 4), cex.lab = 0.8, xpd = TRUE)

s.class(pca3$li, pop(south),
        xax=1,yax=2, 
        col=transp(col,.6), 
        clabel = 0, 
        axesell=TRUE,
        cstar=0, 
        cpoint=2, 
        grid=FALSE, 
        pch=c(16,16,16,16,16, 16, 16, 16, 16)[as.numeric(pop(south))])


legend ("bottomleft", legend = c("Pohang '15", "Geoje '15", "Namhae '15", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Geoje '14"), 
        fill = col, 
        border = FALSE, bty = "n", cex = 0.9, y.intersp = 1, 
        title = "Population")




#################### RETAINED INDIVIDUALS WITH NO TEMPORAL REPLICATES #############
# First, read in your data as a genepop file.The file
# can be delimited by tabs or spaces but there must abe a comma after each individual. 
# Specify how many characters code each allele with ncode. 
combo <-read.genepop("batch_4.filteredMAF_filteredLoci_filteredIndivids_filteredHWE_noreps_combo.gen")

# To retreive useful data summaries
(summary(combo))
combo$pop

# To view missing data information
sum(is.na(combo$tab))

# To replace missing data information with the mean
X <- scaleGen(combo, NA.method="mean")

# To conduct the PCA
pca5 <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=3)
barplot(pca5$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca5)

s.label(pca5$li)
?dudi.pca
#To graph the data

#Different color options. Choose one.
#col <- rich.colors(8, palette = "temperature", plot = TRUE)
#col  <- brewer.pal(9, "Paired")


col <- c("#999999","#CC79A7","#E69F00","#EECC16","#009E73","#56B4E9")


par(cex.axis = 0.7, mar = c(5, 4, 4, 4), cex.lab = 0.8, xpd = TRUE)

s.class(pca5$li, pop(combo),
        xax=1,yax=2, 
        col=transp(col,.6), 
        clabel = 0, 
        axesell=FALSE,
        cstar=0, 
        cpoint=2, 
        grid=FALSE, 
        pch=c(16,16,16,16,16, 16, 16, 16, 16)[as.numeric(pop(combo))])


legend ("topleft", legend = c("Pohang", "Geoje", "Namhae", "YellowSea", "Jukbyeon", "Jinhae"), 
        fill = col, 
        border = FALSE, bty = "n", cex = 0.9, y.intersp = 1, 
        title = "Population")


