###################### Plotting Sample Metadata / Eco data ######################
#
# MF 4/25/2018
#
#################################################################################

library(readr)
library(ggplot2)
library(dplyr)

# Load Data ---------------------------------------------------------------
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/metadata")

sample_data <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/metadata/sample_data.txt", "\t", escape_double = FALSE, trim_ws = TRUE)

sample_list <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/metadata/sample_list.txt", "\t", escape_double = FALSE, trim_ws = TRUE)


mydata <- right_join(sample_data, sample_list, by="Sample.ID")
dim(mydata)
dim(sample_list)
View(mydata)


# Sex ----------------------------------------------------------------
data.sex <- mydata %>%
  group_by(Site) %>%
  count(Sex)
data.sex

ggplot(data.sex, aes(x=Site, y = n, fill = Sex)) +
  geom_col()


# Length v. Weight --------------------------------------------------------
xmax <-  max(as.numeric(mydata$TL.cm), na.rm = TRUE) + 1
data = subset(mydata, !is.na(BW.g))
data$TL.cm <- as.numeric(data$TL.cm)
data$TL.cm <- as.numeric(data$TL.cm)
View(data)

## faceted by site
gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}
ggcols <- gg_color_hue(2)

plotdata = filter(data, Site == "Jukbyeon")
ggplot(plotdata, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Sex, size = Migrant)) +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  ggtitle("Jukbyeon") +
  scale_x_continuous(breaks = seq(0,max(plotdata$TL.cm) + 10, by=5)) +
  theme(axis.title = element_text(size = 14, face = "bold"), axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12, face = "bold")) +
  geom_vline(xintercept = 44.02, col = ggcols[1], lty = 2) +
  geom_vline(xintercept = 32.66, col = ggcols[2], lty = 2) +
  geom_vline(xintercept = 58.27, col = ggcols[1], lty = 1) +
  geom_vline(xintercept = 58.82, col = ggcols[2], lty = 1)


plotdata = filter(data, Site == "Geoje")
ggplot(plotdata, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Sex, size = Migrant)) +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  ggtitle("Geoje") +
  scale_x_continuous(breaks = seq(0,max(plotdata$TL.cm, na.rm = TRUE) + 1, by=5)) +
  theme(axis.title = element_text(size = 14, face = "bold"), axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12, face = "bold")) +
  geom_vline(xintercept = 44.02, col = ggcols[1]) +
  geom_vline(xintercept = 32.66, col = ggcols[2])


plotdata = filter(data, Site == "Namhae")
ggplot(plotdata, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Sex, size = Migrant)) +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  ggtitle("Namhae") +
  scale_x_continuous(breaks = seq(0,max(plotdata$TL.cm, na.rm = TRUE) + 1, by=5)) +
  theme(axis.title = element_text(size = 14, face = "bold"), axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12, face = "bold")) +
  geom_vline(xintercept = 44.02, col = ggcols[1]) +
  geom_vline(xintercept = 32.66, col = ggcols[2])



plotdata = filter(data, Site == "Pohang")
ggplot(plotdata, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Sex, size = Migrant)) +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  ggtitle("Pohang") +
  scale_x_continuous(breaks = seq(0,max(plotdata$TL.cm) + 1, by=5)) +
  theme(axis.title = element_text(size = 14, face = "bold"), axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12, face = "bold")) +
  geom_vline(xintercept = 44.02, col = ggcols[1]) +
  geom_vline(xintercept = 32.66, col = ggcols[2])






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


# Length v. Weight all sites ----------------------------------------------------
plotdata = data %>%
  filter(Site %in% c("Pohang", "Namhae", "Geoje", "Jukbyeon")) %>%
  filter(!is.na(TL.cm))
View(plotdata)

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




##########################################################


## colored by site, with line for maturity
ggplot(data, aes(x=TL.cm, y=GSI)) +
  geom_point(aes(col = Site, size = Migrant, pch = Sex)) +
  xlab("Total Length (cm)") +
  ylab("Gonadosomatic Index (%)") +
  theme(axis.title = element_text(size = 14, face = "bold"), axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12, face = "bold")) +
  geom_hline(yintercept = 20, col = ggcols[1]) +
  geom_hline(yintercept = 38, col = ggcols[1])




