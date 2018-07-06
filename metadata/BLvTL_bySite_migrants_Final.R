###################### Plotting Sample TL v. BW for Final Chapt 1. Draft ######################
#
# MF 4/25/2018
#
#################################################################################

library(readr)
library(ggplot2)
library(dplyr)


# Load Data ---------------------------------------------------------------
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/metadata")

sample_data <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/metadata/sample_data_newJB.txt", "\t", escape_double = FALSE, trim_ws = TRUE)

sample_list <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/metadata/sample_list_wjb.txt", "\t", escape_double = FALSE, trim_ws = TRUE)


mydata <- right_join(sample_data, sample_list, by="Sample.ID")
dim(mydata)
dim(sample_list)
View(mydata)



# Edit Data Frame -----------------------------------------------
## max for x axis
xmax <-  max(as.numeric(mydata$TL.cm), na.rm = TRUE) + 1

## filter for NAs, make numeric
data = subset(mydata, !is.na(BW.g))
data = subset(data, !is.na(TL.cm))
data$TL.cm <- as.numeric(data$TL.cm)
data$TL.cm <- as.numeric(data$TL.cm)
head(data)

##
neworder <- c("YSBlock", "Boryeong", "Namhae", "Geoje", "Jinhae Bay", "Pohang","Jukbyeon")
plotdata <- arrange(transform(data,
                             Site=factor(Site,levels=neworder)),Site)


# 50% LAM -----------------------------------------------------------------

Site <- c("Pohang", "Jukbyeon", "Jukbyeon","Namhae", "Geoje", "YSBlock", "Boryeong", "Jinhae Bay")
LAM_Female = c(44.02, 58.27, 44.02, 44.02,44.02,44.02,44.02,44.02)
LAM_Male <- c(32.66,58.82, 32.66,32.66,32.66,32.66,32.66,32.66)
linetype <- c(1,1,2,1,1,1,1,1)

mat_data <- cbind(Site, LAM_Female, LAM_Male, linetype)
mat_data <- as.data.frame(mat_data)
mat_data$LAM_Female <- as.numeric(LAM_Female)
mat_data$LAM_Male <- as.numeric(LAM_Male)
head(mat_data)
str(mat_data)





# Total Length v. Body Weight plot ----------------------------------------

## code to squish Y axis
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


## create colors for male, female
gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}
ggcols <- gg_color_hue(2)


## plot
ggplot(plotdata, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Sex, pch = Migrant), size = 3) +
  geom_point(data=filter(plotdata, Migrant == "Yes"), aes(x=TL.cm, y=BW.g), col = "black", pch = 2, size = 3) +
  facet_wrap(~Site, nrow = 4, ncol = 2) +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  scale_x_continuous(trans = squish_trans(85,110,4)) +
  theme(axis.title = element_text(size = 14, face = "bold"), 
        axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), 
        legend.title = element_text(size = 12, face = "bold"),
        strip.text = element_text(size = 12)) +
  geom_vline(data=mat_data, aes(xintercept = LAM_Female, lty = linetype), col = ggcols[1]) +
  geom_vline(data=mat_data, aes(xintercept = LAM_Male, lty = linetype), col = ggcols[2])









