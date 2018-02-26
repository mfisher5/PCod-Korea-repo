library(readr)
PCod_Korea_Microchem_filtered <- read_delim("~/SEFS_502/data/PCod_Korea_Microchem_filtered_bypop.txt","\t", escape_double = FALSE, trim_ws = TRUE)
odata <- PCod_Korea_Microchem_filtered
dim(odata)


View(odata)
install.packages("reshape2")
library(reshape2)
odata_reshape <- melt(odata) #uses SiteYear as id variables
View(odata_reshape)
colnames(odata_reshape) <- c("SiteYear", "Element", "Concentration")
View(odata_reshape)

## plot all elements as boxplots
par(mfrow=c(2,4), mar=c(2,2,2,2))
library(ggplot2)

ggplot(odata_reshape, aes(x=SiteYear,y=Concentration)) +
  geom_boxplot() +
  facet_wrap(~Element) +
  theme(axis.text.x = element_text(angle=90))

## plot all but Sr as boxplots
nosr <- c("B11.c","Ba138.c","Li7.c","Mg24.c","Mn55.c","Pb208.c","Zn66.c","B11.e","Ba138.e","Li7.e","Mg24.e", "Mn55.e","Pb208.e","Zn66.e")
odata_nosr <- odata_reshape[odata_reshape$Element %in% nosr,]

ggplot(odata_nosr, aes(x=SiteYear,y=Concentration)) +
  geom_boxplot() +
  facet_wrap(~Element) +
  theme(axis.text.x = element_text(angle=90))
