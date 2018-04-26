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

## base
ggplot(data, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Migrant), size = 2)

## scaled shape by gonad size
ggplot(data, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Migrant, size = GW.g))
  
## colored by site, with line for maturity
ggplot(data, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Site, size = Migrant)) +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  theme(axis.title = element_text(size = 14, face = "bold"), axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12, face = "bold"))



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
  scale_x_continuous(breaks = seq(0,max(plotdata$TL.cm) + 1, by=5)) +
  theme(axis.title = element_text(size = 14, face = "bold"), axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12, face = "bold")) +
  geom_vline(xintercept = 58.6, col = ggcols[1]) +
  geom_vline(xintercept = 56.3, col = ggcols[2])

plotdata = filter(data, Site == "Geoje")
ggplot(plotdata, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Sex, size = Migrant)) +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  scale_x_continuous(breaks = seq(0,max(plotdata$TL.cm, na.rm = TRUE) + 1, by=5)) +
  theme(axis.title = element_text(size = 14, face = "bold"), axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12, face = "bold")) +
  geom_vline(xintercept = 62, col = ggcols[1]) +
  geom_vline(xintercept = 58, col = ggcols[2])


plotdata = filter(data, Site == "Namhae")
ggplot(plotdata, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Sex, size = Migrant)) +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  scale_x_continuous(breaks = seq(0,max(plotdata$TL.cm, na.rm = TRUE) + 1, by=5)) +
  theme(axis.title = element_text(size = 14, face = "bold"), axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12, face = "bold")) +
  geom_vline(xintercept = 62, col = ggcols[1]) +
  geom_vline(xintercept = 58, col = ggcols[2])


plotdata = filter(data, Site == "Pohang")
ggplot(plotdata, aes(x=TL.cm, y=BW.g)) +
  geom_point(aes(col = Sex, size = Migrant)) +
  xlab("Total Length (cm)") +
  ylab("Body Weight (g)") +
  scale_x_continuous(breaks = seq(0,max(plotdata$TL.cm) + 1, by=5)) +
  theme(axis.title = element_text(size = 14, face = "bold"), axis.text = element_text(size = 12), 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12, face = "bold")) +
  geom_vline(xintercept = 62, col = ggcols[1]) +
  geom_vline(xintercept = 58, col = ggcols[2])



