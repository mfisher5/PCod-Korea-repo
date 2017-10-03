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


#################### ALL INDIVIDUALS #############
# First, read in your data as a genepop file.The file
# can be delimited by tabs or spaces but there must abe a comma after each individual. 
# Specify how many characters code each allele with ncode. 
data <-read.genepop("../stacks_b8_wgenome/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredRepsC.gen")

# To retreive useful data summaries
(summary(data))
data$pop

# To view missing data information
sum(is.na(data$tab))

# To replace missing data information with the mean
X <- scaleGen(data, NA.method="mean")

# To conduct the PCA
pca_all <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=3)
barplot(pca_all$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca_all)

s.label(pca_all$li)
?dudi.pca
#To graph the data

#Different color options. Choose one.
#col <- rich.colors(8, palette = "temperature", plot = TRUE)
#col  <- brewer.pal(9, "Paired")


col <- c("#999999","#CC79A7","#E69F00","#EECC16","#009E73","#56B4E9", "deepskyblue4", "#D55E00", "coral1")


par(cex.axis = 0.7, mar = c(5, 4, 4, 4), cex.lab = 0.8, xpd = TRUE)

s.class(pca1$li, pop(data),
        xax=1,yax=2, 
        col=transp(col,.6), 
        clabel = 0, 
        axesell=TRUE,
        cstar=0, 
        cpoint=2, 
        grid=FALSE, 
        pch=c(19, 19, 19, 17, 15, 19, 19, 17, 19)[as.numeric(pop(data))])


legend (x = -35, y = 50, legend = c("Pohang '15", "Geoje '15", "Namhae '15", "YellowSea '16", "Jukbyeon '07", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Boryeong '07", "Geoje '14"), 
        fill = col, 
        border = FALSE, bty = "n", cex = 0.9, y.intersp = 1, 
        title = "Sampling Site")
add.scatter.eig(pca1$eig[1:50],3,1,2, ratio=.3)


s.class(pca1$li, fac=pop(data),
        col=col,
        axesel=FALSE, cstar=0, cpoint=3)
add.scatter.eig(pca1$eig[1:50],3,1,2, ratio=.3)


## -- Eigenvalues 
#Total inertia: 10770

#eigenvalues:
#  Ax1     Ax2     Ax3     Ax4     Ax5 
#332.97  174.19   94.91   87.52   84.69 

## -- Eigenvalues as percentages of the total variation in the data
eig.perc <- 100*pca_all$eig/sum(pca_all$eig)
head(eig.perc)
# [1] 3.0922756 1.6176674 0.8814314 0.8128150 0.7865451 0.7835788


## -- Which alleles are contributing the most to showing the diversity among pops?

loadingplot(pca_all$c1^2)

## -- what are the individual coordinates on the plot?
cor(pca_all$li)
pc <- prcomp(data, scale = TRUE)
pca_all$ind.coord

#################### SOUTHERN SAMPLING SITES ONLY #########################

# First, read in your data as a genepop file.The file
# can be delimited by tabs or spaces but there must abe a comma after each individual. 
# Specify how many characters code each allele with ncode. 
south <-read.genepop("batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredRepsC_south.gen")

# To retreive useful data summaries
(summary(south))
data$pop

# To view missing data information
sum(is.na(south$tab))

# To replace missing data information with the mean
X <- scaleGen(south, NA.method="mean")

# To conduct the PCA
pca_south <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=3)
barplot(pca_south$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
summary(pca_south)

s.label(pca1$li)
?dudi.pca
#To graph the data

#Different color options. Choose one.
#col <- rich.colors(8, palette = "temperature", plot = TRUE)
#col  <- brewer.pal(9, "Paired")


col <- c("#999999","#CC79A7","#E69F00","#56B4E9", "deepskyblue4", "coral1")


par(cex.axis = 0.7, mar = c(5, 4, 4, 4), cex.lab = 0.8, xpd = TRUE)

s.class(pca_south$li, pop(south),
        xax=1,yax=2, 
        col=transp(col,.6), 
        clabel = 0, 
        axesell=TRUE,
        cstar=0, 
        cpoint=2, 
        grid=FALSE, 
        pch=c(19, 19, 19, 19, 19, 19)[as.numeric(pop(south))])

legend ("right", legend = c("Pohang '15", "Geoje '15", "Namhae '15", "Jin. Bay '07 Early", "Jin. Bay '07 Late", "Geoje '14"), 
        fill = col, 
        border = FALSE, bty = "n", cex = 0.9, y.intersp = 1, 
        title = "Sampling Site")
add.scatter.eig(pca_south$eig[1:50],3,1,2, ratio=.3)


s.class(pca1$li, fac=pop(data),
        col=col,
        axesel=FALSE, cstar=0, cpoint=3)
add.scatter.eig(pca1$eig[1:50],3,1,2, ratio=.3)

## -- Eigenvalues 
#Total inertia: 10180

#eigenvalues:
 # Ax1     Ax2     Ax3     Ax4     Ax5 
#224.6   158.9   132.4   129.2   125.8 

## -- Eigenvalues as percentages of the total variation in the data
eig.perc <- 100*pca_south$eig/sum(pca_south$eig)
head(eig.perc)
# [1] 2.206973 1.561822 1.301112 1.269651 1.236049 1.182854


###################### OTHER GRAPHS ###############################

# Sample Sizes
barplot(table(pop(data)), col=funky(9), las=1,
        xlab="Population", ylab="Sample size", 
        names.arg = c("Poh.'15", "Geoje'15", "Nam.'15", "SB'16", "Juk.'07", "JB'07(E)", "JB'07(L)", "Bor.'07", "Geoje'14"))

# Observed v. Expected heterozygosity
temp <- summary(data)
plot(temp$Hexp, temp$Hobs, pch=20, cex=3, xlim=c(0,.6), ylim=c(0,.6))
abline(0,1,lty=2)


################ PRINCIPAL COORDINATES ANALYSIS ##################