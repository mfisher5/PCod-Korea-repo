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
odata <- read_delim("data/PCod_Korea_Microchem_filtered_edit.txt","\t", escape_double = FALSE, trim_ws = TRUE)
dim(odata)
View(odata)

## create new dataframe without sample IDs (just measurements)
odata_el <- odata[,2:17]
colnames(odata_el)
odata_core <- odata_el[1:8]
odata_edge <- odata_el[9:16]



# Multivariate & Univariate tests for normality, skewness ------------------------------

## MARDIA'S SKEWNESS AND KURTOSIS COEFFICIENTS
## requires MVN package
mvn(odata_el, mvnTest="mardia", univariateTest="SW",multivariatePlot = "qq", univariatePlot = "histogram")

mvn(odata_el.mrel, mvnTest="mardia", univariateTest="SW",multivariatePlot = "qq", univariatePlot = "histogram")

# Univariate plots and tests ----------------------------------------------

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



View(odata_edge)


# Data Transformations for Normality --------------------------------------

## Ln transform data?
odata_el_mat <- as.matrix(odata_el)
odata_ln <- apply(odata_el_mat, 2, "log")
View(odata_ln)
mvn(odata_ln, mvnTest="mardia", univariateTest="SW",multivariatePlot = "qq", univariatePlot = "histogram")

## Log transform data?
odata_log <- apply(odata_el_mat, 2, "log10")
mvn(odata_log, mvnTest="mardia", univariateTest="SW",multivariatePlot = "qq", univariatePlot = "histogram")


## Square root transform data?
odata_sr <- apply(odata_el_mat, 2, "sqrt")
mvn(odata_sr, mvnTest="mardia", univariateTest="SW",multivariatePlot = "qq", univariatePlot = "histogram")


## Cube root transform data?
cuberoot <- function(x){x^(1/3)}
odata_cr <- apply(odata_el_mat, 2, "cuberoot")
mvn(odata_cr, mvnTest="mardia", univariateTest="SW",multivariatePlot = "qq", univariatePlot = "histogram")



