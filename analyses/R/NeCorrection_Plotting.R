############## Plot Naive v. Corrected Ne ############
#
# MF for Korea PCod 4/30/2018
#
######################################################

library(ggplot2)
library(dplyr)


# Read in Data ------------------------------------------------------------

setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses/Ne/NeEstimator/Correction")

Ne <- read.table("All_Ne_Uncorrected.txt", sep="\t", header = TRUE)
head(Ne)

Ne_correct <- read.table("All_Ne_LinkageCorrected.txt", sep="\t", header = TRUE)
head(Ne_correct)

Ne <- mutate(Ne, type = "Uncorrected")
Ne_correct <- mutate(Ne_correct, type = "Corrected")

myne <- bind_rows(Ne, Ne_correct)
myne <- mutate(myne, SiteYear = paste(Site, Year, sep = " "))
View(myne)


neworder <- c("Boryeong 2007-2008", "YS Block 2015-2016", "Geoje 2013-2014", "Geoje 2014-2015", "Jinhae Bay 2007-2008, Dec.", "Jinhae Bay 2007-2008, Feb.",  "Pohang 2014-2015", "Jukbyeon 2007-2008", "Southern Pop. 2007-2008", "Southern Pop. 2013-2014", "Southern Pop. 2014-2015")
myne_ordered <- arrange(transform(myne,
                                  SiteYear=factor(SiteYear,levels=neworder)),SiteYear)

View(myne_ordered)

ggplot(myne_ordered, aes(x = SiteYear, y = Ne1)) +
  geom_point(aes(col = type), size = 3) +
  geom_errorbar(data = myne_ordered, aes(ymin = Ne1_lower, ymax = Ne1_upper, col = type), width = 0.1) +
  xlab("Sampling Site") +
  ylab("Effective Population Size (MAF = 0.10)") +
  scale_y_continuous(breaks = seq(0,4000,500), labels = seq(0,4000,500)) +
  scale_x_discrete(labels = c("Boryeong", "YS Block", "Geoje 2013-14", "Geoje 2014-15", "Jinhae Bay Dec.", "Jinhae Bay Feb.",  "Pohang", "Jukbyeon", "South 2007-08", "South 2013-14", "South 2014-15")) +
  theme(axis.text.x = element_text(angle=45, hjust = 1),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12), 
        legend.title = element_blank(),
        legend.text = element_text(size = 12))



ggplot(myne_ordered, aes(x = SiteYear, y = Ne2)) +
  geom_point(aes(col = type), size = 3) +
  geom_errorbar(data = myne_ordered, aes(ymin = Ne2_lower, ymax = Ne2_upper, col = type), width = 0.1) +
  xlab("Sampling Site") +
  ylab("Effective Population Size (MAF = 0.20)") +
  scale_y_continuous(breaks = seq(0,4000,500), labels = seq(0,4000,500)) +
  scale_x_discrete(labels = c("Boryeong", "YS Block", "Geoje 2013-14", "Geoje 2014-15", "Jinhae Bay Dec.", "Jinhae Bay Feb.",  "Pohang", "Jukbyeon", "South 2007-08", "South 2013-14", "South 2014-15")) +
  theme(axis.text.x = element_text(angle=45, hjust = 1),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12), 
        legend.title = element_blank(),
        legend.text = element_text(size = 12))
