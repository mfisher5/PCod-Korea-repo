# Purpose: testing for significant changes in Fis, Ho per population
#
#From: MF 6/10/2018
#
#
#
# ---------------------------------------------------------------------------------

# Import these libraries
library(readr)
library(reshape2)
library(dplyr)


# Set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses")



# Western Population ------------------------------------------------------
# Import data
mydata <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/results/verif/Ho_Fis_perLocus_perSite.txt", "\t", escape_double = FALSE, trim_ws = TRUE)
head(mydata)

# Adjust data frame
mydata_het <- subset(x = mydata, select = c(locus, pop, Ho))
head(mydata_het)
west_het <- filter(mydata_het, pop %in% c("YS_121316_07", "BOR07_21_2"))
head(west_het)

mydata_fis <- subset(x = mydata, select=c(locus,pop,Fis_wc))
head(mydata_fis)
west_fis <- filter(mydata_fis, pop %in% c("YS_121316_07", "BOR07_21_2"))
head(west_fis)


# Run Wilcox Test
wilcox.test(Ho ~ pop, data = west_het)

wilcox.test(Fis_wc ~ pop, data = west_fis)



# Southern Population ------------------------------------------------------
# Import data
mydata <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/results/verif/Ho_Fis_perLocus_perYear_South.txt", "\t", escape_double = FALSE, trim_ws = TRUE)
head(mydata)

# Adjust data frame
mydata_het <- subset(x = mydata, select = c(locus, pop, Ho))
head(mydata_het)
mydata_het_1 <- filter(mydata_het, pop %in% c("JB021108_23","GEO020414_30_2"))
mydata_het_2 <- filter(mydata_het, pop %in% c("NA021015_26","GEO020414_30_2"))

mydata_fis <- subset(x = mydata, select=c(locus,pop,Fis_wc))
head(mydata_fis)
mydata_fis_1 <- filter(mydata_fis, pop %in% c("JB021108_23","GEO020414_30_2"))
mydata_fis_2 <- filter(mydata_fis, pop %in% c("NA021015_26","GEO020414_30_2"))


# Run Wilcox Test
wilcox.test(Ho ~ pop, data = mydata_het_1)
wilcox.test(Ho ~ pop, data = mydata_het_2)

wilcox.test(Fis_wc ~ pop, data = mydata_fis_1)
wilcox.test(Fis_wc ~ pop, data = mydata_fis_2)

