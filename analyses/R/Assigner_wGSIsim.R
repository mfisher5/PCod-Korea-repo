#-------------- ASSIGNER with GSIsim --------------#
#
# Use for PCod, Korea dataset
# MF 10/30/2017
#
# https://github.com/thierrygosselin/assigner
# https://github.com/eriqande/gsi_sim 
#
## Load the assigner package (according to theirrygosselin/assigner)
if (!require("devtools")) install.packages("devtools") # to install
devtools::install_github("thierrygosselin/assigner", build_vignettes = TRUE)  # to install WITH vignettes
assigner::install_gsi_sim(fromSource = TRUE) # to install gsi_sim from source
library(assigner)

## Load the assigner package (what actually worked)
install.packages("devtools")
library("devtools")
install.packages("NMF")
# install.packages("igraph") <- latest version (1.1.1) didn't work. 
#    manually downloaded the latest "stable" version 1.0.1 from https://cloud.r-project.org/ src/contrib/Archive/igraph
#    also see: https://github.com/igraph/rigraph/issues/191
install_github("thierrygosselin/assigner") # to install
library(assigner) # to load


