########### Comparing Ne Estimates ##############
#
# Compare Pacific cod Ne estimates between Korean and Alaskan populations
#
# MF 5/9/2018
#
#################################################


# Load Packages -----------------------------------------------------------
library(readr)
library(ggplot2)
library(dplyr)



# Read in Data ------------------------------------------------------------
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses/Ne/NeEstimator")
mydata <- read_delim("Ne_Korea_v_Alaska_corrected.txt", "\t", escape_double = FALSE, trim_ws = TRUE)

mydata

mydata <- mutate(mydata, Subpopulation = paste(Site, Year, sep = " "))

## only aggregate level
aggs <- filter(mydata, Site != "South Coast")

## only stock level
stock_list <- c("West Coast", "East Coast", "South Coast", "Salish Sea", "Juan de Fuca", "Wash. Coast", "Hecate Strait", "PWSound", "Kodiak", "Unimak Pass", "Adak")

stocks <- filter(mydata, Site %in% stock_list)

# Plot Data ---------------------------------------------------------------


#################### plotting function to squish axis ####################
library(scales)
squish_trans <- function(from, to, factor) {
  
  trans <- function(x) {
    
    # get indices for the relevant regions
    isq <- x > from & x < to
    ito <- x >= to
    
    # apply transformation
    x[isq] <- from + (x[isq] - from)/factor
    x[ito] <- from + (to - from)/factor + (x[ito] - to)
    
    return(x)
  }
  
  inv <- function(x) {
    
    # get indices for the relevant regions
    isq <- x > from & x < from + (to - from)/factor
    ito <- x >= from + (to - from)/factor
    
    # apply transformation
    x[isq] <- from + (x[isq] - from) * factor
    x[ito] <- to + (x[ito] - (from + (to - from)/factor))
    
    return(x)
  }
  
  # return the transformation
  return(trans_new("squished", trans, inv))
}
###########################################################


ggplot(aggs, aes(x=Subpopulation, y=Ne1)) +
  geom_point(aes(col = Population), size = 2)+
  geom_errorbar(aes(ymin=Ne1_lower, ymax = Ne1_upper, col = Population), size = 1)+
  ylab("Ne (x 1000)") +
  xlab("Sampling Site") +
  scale_y_continuous(breaks = seq(0,40000, 10000), labels = c("0", "10", "20", "30", "40")) +
  scale_x_discrete(limits = aggs$Subpopulation) +
  theme(axis.title.x=element_text(size = 18),
        axis.text.x=element_text(angle=90, hjust = 0, size = 8),
        axis.title.y=element_text(size=18),
        axis.text.y=element_text(size = 14))
  
  
  
  
  