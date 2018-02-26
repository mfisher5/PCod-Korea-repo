############ Assessing Multivariate Normality on Otolith Data ##########
#
# MF 2/15/2018
# Korean PCod Project - Otolith Microchemistry dataset
#
# Useful link for MVN package: https://cran.r-project.org/web/packages/MVN/vignettes/MVN.pdf
#
#########################################################################



# Install Packages --------------------------------------------------------
install.packages("ggplot2")
install.packages("zoo", type="source", repos="http://cran.stat.ucla.edu/")
library(zoo)
install.packages("MVN", dependencies=TRUE)
library(MVN)
library(ggplot2)
library(readr)
library(vegan)


# Read in data ------------------------------------------------------------
## load data
PCod_Korea_Microchem_filtered <- read_delim("~/SEFS_502/data/PCod_Korea_Microchem_filtered_bypop.txt","\t", escape_double = FALSE, trim_ws = TRUE)
odata <- PCod_Korea_Microchem_filtered
dim(odata)
View(odata)

## create new dataframe without sample IDs (just measurements)
odata_el <- odata[,2:17]
colnames(odata_el)



# Multivariate tests for normality, skewness ------------------------------

## MARDIA'S SKEWNESS AND KURTOSIS COEFFICIENTS
## requires MVN package
mardiaTest(odata_el, qqplot = TRUE)




# Univariate plots and tests ----------------------------------------------

## SHAPIRO WILKES: TEST FOR NORMALITY BY VARIABLE
shapiro_pvals_core <- c(shapiro.test(odata_el$B11.c)$p.value,
                   shapiro.test(odata_el$B11.c)$p.value,
                   shapiro.test(odata_el$Li7.c)$p.value,
                   shapiro.test(odata_el$Mg24.c)$p.value,
                   shapiro.test(odata_el$Mn55.c)$p.value,
                   shapiro.test(odata_el$Pb208.c)$p.value,
                   shapiro.test(odata_el$Sr88.c)$p.value,
                   shapiro.test(odata_el$Zn66.c)$p.value)
qplot(shapiro_pvals_core, geom="histogram")


shapiro_pvals_edge <- c(shapiro.test(odata_el$B11.e)$p.value,
                        shapiro.test(odata_el$B11.e)$p.value,
                        shapiro.test(odata_el$Li7.e)$p.value,
                        shapiro.test(odata_el$Mg24.e)$p.value,
                        shapiro.test(odata_el$Mn55.e)$p.value,
                        shapiro.test(odata_el$Pb208.e)$p.value,
                        shapiro.test(odata_el$Sr88.e)$p.value,
                        shapiro.test(odata_el$Zn66.e)$p.value)
qplot(shapiro_pvals_edge, geom="histogram")



## QQ-PLOTS: VISUALIZE NORMALITY BY VARIABLE
par(mfrow=c(2,4))
qqnorm(odata_el$B11.c, main="QQplot:B11.c"); qqline(odata_el$B11.c)
qqnorm(odata_el$Ba138.c, main="QQplot:Ba138.c"); qqline(odata_el$Ba138.c)
qqnorm(odata_el$Li7.c, main="QQplot:Li7.c"); qqline(odata_el$Li7.c)
qqnorm(odata_el$Mg24.c, main="QQplot:Mg24.c"); qqline(odata_el$Mg24.c)
qqnorm(odata_el$Mn55.c, main="QQplot:Mn55.c"); qqline(odata_el$Mn55.c)
qqnorm(odata_el$Pb208.c, main="QQplot:Pb208.c"); qqline(odata_el$Pb208.c)
qqnorm(odata_el$Sr88.c, main="QQplot:Sr88.c"); qqline(odata_el$Sr88.c)
qqnorm(odata_el$Zn66.c, main="QQplot:Zn66.c"); qqline(odata_el$Zn66.c)

qqnorm(odata_el$B11.e, main="QQplot:B11.e"); qqline(odata_el$B11.e)
qqnorm(odata_el$Ba138.e, main="QQplot:Ba138.e"); qqline(odata_el$Ba138.e)
qqnorm(odata_el$Li7.e, main="QQplot:Li7.e"); qqline(odata_el$Li7.e)
qqnorm(odata_el$Mg24.e, main="QQplot:Mg24.e"); qqline(odata_el$Mg24.e)
qqnorm(odata_el$Mn55.e, main="QQplot:Mn55.e"); qqline(odata_el$Mn55.e)
qqnorm(odata_el$Pb208.e, main="QQplot:Pb208.e"); qqline(odata_el$Pb208.e)
qqnorm(odata_el$Sr88.e, main="QQplot:Sr88.e"); qqline(odata_el$Sr88.e)
qqnorm(odata_el$Zn66.e, main="QQplot:Zn66.e"); qqline(odata_el$Zn66.e)

par(mfrow=c(1,1))


## HISTOGRAMS: VISUALIZE VARIANCE BY VARIABLE
## requires package MVN

par(mfrow=c(2,4))
uniPlot(odata_el, type = "histogram")
par(mfrow=c(1,1))






# Data Transformations for Normality --------------------------------------

## Log transform data?
odata_log <- decostand(x = odata_el, method = "log", MARGIN = "2")
mardiaTest(odata_log)
mardiaTest(odata_el)

plot(odata_log$B11.c, odata_el$B11.c)
qqnorm(odata_log$B11.c); qqline(odata_log$B11.c)
