######## RUN MANTEL TESTS ON RELATIVIZED OTOLITH DATA ############
#
# MF 2/25/2018
# for SEFS 502 Final Project
# 
#############################################################

## set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/otolith_analyses")


# Load packages -----------------------------------------------------------
install.packages("vegan")
library(vegan)



# Mantel Test: edge v. core -----------------------------------------------

## run Mantel test
odata_mantel <- mantel(xdis = edge.mrel_dist, ydis = core.mrel_dist,
                       method = "pearson", permutations = 99999)
odata_mantel

#Mantel r = 0.3441 
#signficance = 1e-5; Tells us that 1 / 100,000 permutations had an r statistic greater than 0.3372
#Upper quantiles of permutations (null model):
#  90%    95%  97.5%    99% 
#  0.0624 0.0829 0.1010 0.1229 








