######## RUN PERMANOVA ON RELATIVIZED OTOLITH DATA ############
#
# MF 2/25/2018
# for SEFS 502 Final Project
# 
##############################################################


# Install Packages --------------------------------------------------------
install.packages("vegan")
install.packages("dplyr")
library(vegan)
library(dplyr)



# Run PERMANOVA on Edge data - Site only ----------------------------------

## PERMANOVA: sampling site effect on full microchemical fingerprint
sites <- odata_combo$Sampling.Site # create vector of sampling sites
odata_sites.res <- adonis2(odata_edge ~ sites,
                           permutations = 99999, method = "euc")
odata_sites.res




# Run PERMANOVA on Edge data - Year only ----------------------------------

## PERMANOVA: year effect on full microchemical fingerprint (only temporal replicates)
## data frames of sites with temporal replications
odata_temp_ge <- filter(odata_combo, Sampling.Site == "Geoje")
odata_temp_jb <- filter(odata_combo, Sampling.Site == "JinhaeBay")

years_ge <- odata_temp_ge$Year # create vector of year for Geoje
years_jb <- odata_temp_jb$Year # create vector of year for Jinhae Bay

## relativize element edge concentrations
odata_jb.mrel <- decostand(odata_temp_jb[,10:17], method="max")
odata_ge.mrel <- decostand(odata_temp_ge[,10:17], method="max")

## make sure relativization worked
head(odata_jb.mrel)
head(odata_ge.mrel)

## PERMANOVA for JB site
odata_jbyears.res <- adonis2(odata_jb.mrel ~ years_jb,
                             permutations = 99999, method = "euc")
odata_jbyears.res


## PERMANOVA for GE site
odata_geyears.res <- adonis2(odata_ge.mrel ~ years_ge,
                             permutations = 99999, method = "euc")
odata_geyears.res






# Plot SS from PERMANOVA --------------------------------------------------
sitess <- c(16.526, 19.501)
jbss <- c(2.2845, 13.8284)
gess <- c(1.7266, 11.7150)
type <- c("Site / Temporal", "Residual")
sumsquares <- cbind(sitess, jbss, gess)
rownames(sumsquares) <- type
colnames(sumsquares) <- c("Sampling Site", "Temporal-Year", "Temporal-Month")
sumsquares

barplot(height = sumsquares, legend.text=TRUE, 
        col=c("cornflowerblue", "darkgrey"),
        ylab="PERMANOVA Sum of Squares")






# Run ANOVAs for each element by site ---------------------------------------------

## B11

## Ba
Ba.ln <- log(odata_edge$Ba138.e)
anova <- aov(Ba.ln ~ sites, data = odata_combo)
summary(anova)

## Li

## Mg24
Mg.ln <- log(odata_edge$Mg24.e)
anova <- aov(Mg.ln ~ sites, data = odata_combo)
summary(anova)

## Mn55

## Pb208

## Sr88
Sr <- odata_edge$Sr88.e
anova <- aov(Sr ~ sites, data = odata_combo)
summary(anova)

## Zn66
Zn.ln <- log(odata_edge$Zn66.e)
anova <- aov(Zn.ln ~ sites, data = odata_combo)
summary(anova)




# Run ANOVAs for each element by spawning month ---------------------------------------------

## B11

## Ba
Ba.ln <- log(odata_jb.mrel$Ba138.e)
anova <- aov(Ba.ln ~ years_jb)
summary(anova)

## Li

## Mg24
Mg.ln <- log(odata_jb.mrel$Mg24.e)
anova <- aov(Mg.ln ~ years_jb)
summary(anova)

## Mn55

## Pb208

## Sr88
Sr <- odata_jb.mrel$Sr88.e
anova <- aov(Sr ~ years_jb)
summary(anova)

## Zn66
Zn.ln <- log(odata_jb.mrel$Zn66.e)
anova <- aov(Zn.ln ~ years_jb)
summary(anova)






# Run ANOVAs for each element by spawning year ---------------------------------------------

## B11

## Ba
Ba.ln <- log(odata_ge.mrel$Ba138.e)
anova <- aov(Ba.ln ~ years_ge)
summary(anova)

## Li

## Mg24
Mg.ln <- log(odata_ge.mrel$Mg24.e)
anova <- aov(Mg.ln ~ years_ge)
summary(anova)

## Mn55

## Pb208

## Sr88
Sr <- odata_ge.mrel$Sr88.e
anova <- aov(Sr ~ years_ge)
summary(anova)

## Zn66
Zn.ln <- log(odata_ge.mrel$Zn66.e)
anova <- aov(Zn.ln ~ years_ge)
summary(anova)




