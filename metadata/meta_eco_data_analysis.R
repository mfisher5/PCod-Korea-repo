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

sample_data <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/metadata/sample_data_wjb.txt", "\t", escape_double = FALSE, trim_ws = TRUE)

sample_list <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/metadata/sample_list_wjb.txt", "\t", escape_double = FALSE, trim_ws = TRUE)


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




# Length v. Weight, don't highlight migrants --------------------------------------------------------
xmax <-  max(as.numeric(mydata$TL.cm), na.rm = TRUE) + 1
data = subset(mydata, !is.na(BW.g))
data$TL.cm <- as.numeric(data$TL.cm)
data$TL.cm <- as.numeric(data$TL.cm)
View(data)

neworder <- c("YSBlock", "Boryeong", "Geoje", "Namhae", "Jinhae Bay", "Pohang", "Jukbyeon")
data_ordered <- arrange(transform(data,
                             Site=factor(Site,levels=neworder)),Site)
View(data_ordered)


## create a data frame for maturity data
Site <- c("YSBlock", "Boryeong", "Namhae", "Geoje", "Jinhae Bay","Pohang", "Jukbyeon")
LAM_Female = c(44.02, 44.02, 44.02,44.02,44.02,44.02,58.27)
LAM_Male <- c(32.66,32.66,32.66,32.66,32.66,32.66,58.82)

mat_data <- cbind(Site, LAM_Female, LAM_Male)
mat_data <- as.data.frame(mat_data)
mat_data$LAM_Female <- as.numeric(LAM_Female)
mat_data$LAM_Male <- as.numeric(LAM_Male)
head(mat_data)
str(mat_data)


## base
ggplot(data, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Migrant), size = 2)

## scaled shape by gonad size
ggplot(data, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Migrant, size = GW.g))

## colored by site, with line for maturity
ggplot(data_ordered, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Sex)) +
  facet_wrap(~Site) +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  geom_vline(data=mat_data, aes(xintercept = LAM_Female), col = ggcols[1]) +
  geom_vline(data=mat_data, aes(xintercept = LAM_Male), col = ggcols[2]) +
  theme(axis.title = element_text(size = 14, face = "bold"), axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12, face = "bold"),
        strip.text = element_text(size = 12))



# Length v. Weight, highlight migrants --------------------------------------------------------

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


plotdata = data %>%
  filter(!is.na(TL.cm)) %>%
  mutate(point = ifelse(Migrant == "Yes", 16,1))
View(plotdata)

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



# GSI --------------------------------------------------------
gsi_data <- filter(data_ordered, !is.na(GSI))
View(gsi_data)

gsi_migrant_data <- filter(gsi_data, Migrant == "Yes")
gsi_migrant_data

ggplot(gsi_data, aes(x = Site, y = GSI)) +
  geom_boxplot() +
  geom_point(data = gsi_migrant_data, aes(x = Site, y = GSI, col = Sex), size = 5, pch = 17) +
  xlab("Sampling Site") +
  ylab("Gonadosomatic Index (%)") +
  scale_x_discrete(labels=c("Yellow Sea Block","Geoje '14-'15", "Namhae", "Pohang")) +
  theme(axis.title = element_text(size = 14), axis.text = element_text(size = 12))
  
ggplot(gsi_data, aes(x = Site, y = GSI)) +
  geom_point(aes(col=Sex), size = 3) +
  xlab("Sampling Site") +
  ylab("Gonadosomatic Index (%)") +
  scale_y_continuous(breaks = seq(0,40,5), labels = c(0,5,10,15,20,25,30,35,40))+
  theme(axis.title = element_text(size = 14), axis.text = element_text(size = 12))
