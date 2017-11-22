################# R Code for Principal Components Analysis #################
#
## 11/8/2017
#
## This code should run a PCA on any data set, and then allow you to plot the results / extract coordinates for individual samples
## FOR PCA FUNCTION `dudi.pca` CODE OPTIONS: https://pbil.univ-lyon1.fr/ade4/ade4-html/dudi.pca.html
## FOR PCA FUNCTION `prcomp()` CODE OPTIONS: https://stat.ethz.ch/R-manual/R-devel/library/stats/html/prcomp.html
## FOR OTHER OPTIONS TO RUN A PCA: http://www.gastonsanchez.com/visually-enforced/how-to/2012/06/17/PCA-in-R/
#
## Questions? Email Mary Fisher (mfisher5@uw.edu)
#
############################################################################

######################### Getting Set up ###########################

## Load required packages 
if(!require(devtools)) install.packages("devtools")
devtools::install_github("kassambara/factoextra")
library(factoextra)

install.packages("gplots")
library(gplots)


## Set your working directory to the folder with your data files 
getwd()
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses")


## Import your data set
#-- The data should be in a table format, with 1 row for a sample and 1 column for each variable.
#-- On each row: The first column should contain your sample ID, and the remaining columns should include measurements for each variable
#-- Be sure to import with a heading!
library(readr) 
my_data <- read_delim("path_to_file/file.txt", "\t", escape_double = FALSE, trim_ws = TRUE) # read in data
View(my_data) # view data


###################### OPTION 1: Run the PCA using dudi.pca() ################################

## Load required package
install.packages("ade4")
library(ade4)


## Compute PCA using dudi.pca()
#-- Regarding the "scannf" argument: this allows you to see a scree plot before choosing the number of axes you want
my_data.pca <- dudi.pca(my_data, scannf = TRUE)


## Access PCA results

#-- Eigenvalues
my_data.pca$eig

#-- Coordinates for each individual
my_data.ind <- get_pca_ind(my_data.pca)
my_data.ind$coord





###################### OPTION 2: Run the PCA using prcomp() ################################

## Compute PCA using prcomp()
#-- Regarding the "scale" argument:  =this tells R whether the variables should be scaled to have unit variance before the analysis takes place
my_data.pca <- prcomp(my_data, scale = TRUE)

## Visualize eigenvalues (scree plot). This will show the percentage of variance explained by each principal component
fviz_eig(my_data.pca)


## Access PCA results

#-- Eigenvalues
my_data.eig <- get_eigenvalue(my_data.pca)
my_data.eig

#-- Coordinates for each individual
my_data.ind <- get_pca_ind(my_data.pca)
my_data.ind$coord






########################### Plot PCA ##############################


## Create vectors with colors and lables for the plot

#-- sampling site names
popnames <- c("YellowSeaBlock_2016", 
              "Boryeong_2007",
              "Namhae_2015",
              "Geoje_2014",
              "Geoje_2015",
              "Jin.Bay_2007",
              "Jin.Bay_2008",
              "Pohang_2015",
              "Jukbyeon_2007")

#-- colors for points in plot. each sampling site has a different point color (match order to name vector above). these colors match my PCA plot
pt_colors <- c("firebrick4",
         "coral1",
         "aquamarine",
         "mediumorchid1",
         "mediumorchid4",
         "deepskyblue",
         "deepskyblue4",
         "gray",
         "chartreuse")

#-- shapes for points in plot. each *region* has a different point shape (West,South,East) (match order to name vector above). these shapes match my PCA plot
pt_shapes=c(17,17,16,16,16,16, 16, 16,15)





## OPTION 1: Plot PCA results with lines to centroids

#-- main plot area
s.class(my_data.pca$li, fac=pop(my_data), 
        col=pt_colors, #color of points. this argument will retain lines between points
        clabel=0, #removed population labels at centroids; to add back in, make >= 1
        cellipse=0, #removed ellipses; to add back in, make >=1
        cpoint=1.5, #size of each point
        pch=pt_shapes[as.numeric(pop(my_data))], #change point shapes
        axesell=TRUE)

#-- legend
legend ("bottomleft", legend = popnames, col = pt_colors, border = FALSE, bty = "n", cex = 0.9, pt.cex=1.5, y.intersp = 1, title = "Sampling Site",pch=pt_shapes)

#-- display eigenvalues plot as an inset
add.scatter.eig(pca_all$eig[1:50],posi="bottom", 3,2,1,ratio=.3)






## OPTION 2: Plot PCA results without lines to centroids, and transparent points 
#-- main plot area
s.class(my_data.pca$li, fac=pop(my_data),
        xax=1,yax=2, 
        col=transp(pt_colors,.6),  #color of points. this argument will create unconnected, semi-transparent points
        clabel = 0, 
        axesell=TRUE,
        cstar=0, 
        cpoint=2,
        pch=pt_shapes[as.numeric(pop(my_data))])

#-- legend
legend ("bottomleft", legend = popnames, col = pt_colors, border = FALSE, bty = "n", cex = 0.9, pt.cex=1.5, y.intersp = 1, title = "Sampling Site",pch=pt_shapes)

#-- display eigenvalues plot as an inset
add.scatter.eig(pca_all$eig[1:50],posi="bottom", 3,2,1,ratio=.3)
