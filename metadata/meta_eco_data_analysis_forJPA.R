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


## base
ggplot(data, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Migrant), size = 2)

## scaled shape by gonad size
ggplot(data, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Migrant, size = GW.g))

## colored by site, with line for maturity
gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}
ggcols <- gg_color_hue(2)

## wrapped by site
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

## wrapped by site
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

## colored by population
ggplot(plotdata, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Assigned.Pop, pch = Migrant), size = 3) +
  geom_point(data=filter(plotdata, Migrant == "Yes"), aes(x=TL.cm, y=BW.g), col = "black", pch = 2, size = 3) +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  scale_x_continuous(breaks = seq(0,110,by=10), labels = seq(0,110,by=10), limits = c(30,105)) +
  scale_color_manual(name = "Pop. of Origin", values = c("South" = "deepskyblue2", "West" = "firebrick4", "East" = "chartreuse")) +
  theme(axis.title = element_text(size = 14, face = "bold"), 
        axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), 
        legend.title = element_text(size = 12, face = "bold"),
        strip.text = element_text(size = 12))

  
gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}
ggcols <- gg_color_hue(2)
  
  
## only western sites
plotwest = plotdata %>%
  filter(Assigned.Pop == "West")

ggplot(plotwest, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Sex, pch = Migrant), size = 3) +
  geom_point(data=filter(plotwest, Migrant == "Yes"), aes(x=TL.cm, y=BW.g), col = "black", pch = 2, size = 3) +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  ggtitle("Western Coast Population") +
  scale_x_continuous(breaks = seq(0,80,by=10), labels = seq(0,80,by=10), limits = c(30,80)) +
  scale_y_continuous(breaks = seq(0,6000, by = 1000), labels = seq(0,6000, by = 1000)) +
  theme(axis.title = element_text(size = 14, face = "bold"), 
        axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), 
        legend.title = element_text(size = 12, face = "bold"),
        strip.text = element_text(size = 12)) +
  geom_vline(xintercept = 32.66, lty = 1, col = ggcols[2]) +
  geom_vline(xintercept = 44.02, lty = 1, col = ggcols[1])

## only southern sites
plotsouth = plotdata %>%
  filter(Assigned.Pop == "South")

ggplot(plotsouth, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Sex, pch = Migrant), size = 3) +
  geom_point(data=filter(plotsouth, Migrant == "Yes"), aes(x=TL.cm, y=BW.g), col = "black", pch = 2, size = 3) +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  ggtitle("Southern Coast Population") +
  scale_x_continuous(breaks = seq(0,110,by=10), labels = seq(0,110,by=10), limits = c(30,110)) +
  scale_y_continuous(breaks = seq(0,12000, by = 1000), labels = seq(0,12000, by = 1000)) +
  theme(axis.title = element_text(size = 14, face = "bold"), 
        axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), 
        legend.title = element_text(size = 12, face = "bold"),
        strip.text = element_text(size = 12)) +
  geom_vline(xintercept = 32.66, lty = 1, col = ggcols[2]) +
  geom_vline(xintercept = 44.02, lty = 1, col = ggcols[1])

plotwest %>%
  group_by(Migrant) %>%
  summarise(mean(BW.g))
mean(plotwest$BW.g)



# GSI --------------------------------------------------------
gsi_data <- data_ordered %>%
  filter(!is.na(GSI)) %>%
  mutate(maturity = ifelse(Sex == "F", ifelse(TL.cm > 44.02, "Mature", "Immature"), ifelse(TL.cm > 32.66, "Mature", "Immature")))

View(gsi_data)

gsi_migrant_data <- filter(gsi_data, Migrant == "Yes")

ggplot(gsi_data, aes(x = Assigned.Pop, y = GSI)) +
  geom_boxplot() +
  geom_point(data = gsi_migrant_data, aes(x = Assigned.Pop, y = GSI, col=Sex), pch = 17, size = 5) +
  facet_wrap(~maturity) +
  xlab("Population") +
  ylab("Gonadosomatic Index (%)") +
  scale_y_continuous(breaks = seq(0,40,5), labels = c(0,5,10,15,20,25,30,35,40))+
  theme(axis.title = element_text(size = 14), 
        axis.text = element_text(size = 12),
        strip.text = element_text(size = 12),
        legend.title = element_text(size = 12, face = "bold"))


# GSI and Length --------------------------------------------------------
## colored by site, with line for maturity
ggplot(gsi_data, aes(x=TL.cm, y=GSI)) +
  geom_point(aes(col = Sex)) +
  facet_wrap(~Site) +
  xlab("Total Length (cm)") +
  ylab("Gonadosomatic Index (%)") +
  geom_vline(xintercept = 44.02, col = ggcols[1]) +
  geom_vline(xintercept=32.66, col = ggcols[2]) +
  theme(axis.title = element_text(size = 14, face = "bold"), axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12, face = "bold"),
        strip.text = element_text(size = 12))


Site <- c("YSBlock", "Namhae", "Geoje", "Pohang")
LAM_Female = c(44.02, 44.02, 44.02,44.02,44.02,44.02,58.27)
LAM_Male <- c(32.66,32.66,32.66,32.66,32.66,32.66,58.82)

mat_data <- cbind(Site, LAM_Female, LAM_Male)
mat_data <- as.data.frame(mat_data)
mat_data$LAM_Female <- as.numeric(LAM_Female)
mat_data$LAM_Male <- as.numeric(LAM_Male)
head(mat_data)
str(mat_data)





# For JPA Presentation ----------------------------------------------------

## First, run everything up to "Length v. Weight, Highlight Migrants"

## subset plot data
plotdata = data %>%
  filter(!is.na(TL.cm)) %>%
  filter(Site %in% c("Geoje", "Jukbyeon", "Namhae", "Pohang")) %>%
  mutate(point = ifelse(Migrant == "Yes", 16,1))
View(plotdata)


## create a data frame for maturity data
Site <- c("Pohang", "Jukbyeon", "Jukbyeon","Namhae", "Geoje")
LAM_Female = c(44.02, 58.27, 44.02, 44.02,44.02)
LAM_Male <- c(32.66,58.82, 32.66,32.66,32.66)
linetype <- c(1,1,2,1,1)

mat_data <- cbind(Site, LAM_Female, LAM_Male, linetype)
mat_data <- as.data.frame(mat_data)
mat_data$LAM_Female <- as.numeric(LAM_Female)
mat_data$LAM_Male <- as.numeric(LAM_Male)
head(mat_data)
str(mat_data)


ggplot(plotdata, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Sex, pch = Migrant), size = 3) +
  geom_point(data=filter(plotdata, Migrant == "Yes"), aes(x=TL.cm, y=BW.g), col = "black", pch = 2, size = 3) +
  facet_wrap(~Site, nrow = 2, ncol = 2, scales = "free") +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  # scale_x_continuous(trans = squish_trans(85,110,4)) +
  theme(axis.title = element_text(size = 14, face = "bold"), 
        axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), 
        legend.title = element_text(size = 12, face = "bold"),
        strip.text = element_text(size = 12)) +
  geom_vline(data=mat_data, aes(xintercept = LAM_Female, lty = linetype), col = ggcols[1]) +
  geom_vline(data=mat_data, aes(xintercept = LAM_Male, lty = linetype), col = ggcols[2])

## just jukbyeon
plotdata_juk <- subset(plotdata, Site == "Jukbyeon")
ggplot(plotdata_juk, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Sex, pch = Migrant), size = 3) +
  geom_point(data=filter(plotdata_juk, Migrant == "Yes"), aes(x=TL.cm, y=BW.g), col = "black", pch = 2, size = 3) +
  # facet_wrap(~Site, nrow = 2, ncol = 2, scales = "free") +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  scale_x_continuous(breaks = seq(0,60,by=5), labels = seq(0,60,by=5), limits = c(30,60)) +
  scale_y_continuous(breaks = seq(0,2000,by=500), labels = seq(0,2000,by=500), limits = c(0,2000)) +
  theme(axis.title = element_text(size = 14, face = "bold"), 
        axis.text = element_text(size = 12),
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 12, face = "bold"),
        strip.text = element_text(size = 12)) +
  geom_vline(data=subset(mat_data, Site == "Jukbyeon"), aes(xintercept = LAM_Female, lty = linetype), col = ggcols[1]) +
  geom_vline(data=subset(mat_data, Site == "Jukbyeon"), aes(xintercept = LAM_Male, lty = linetype), col = ggcols[2])


##
gsi_data %>%
  group_by(Assigned.Pop) %>%
  count(maturity)
