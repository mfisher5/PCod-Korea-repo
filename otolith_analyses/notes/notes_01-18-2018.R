############# Class Notes 1-19-2018 #############
#
#Group Comparisons I
#MF
#
#################################################
setwd("~/SEFS_502")


# Permutation example -----------------------------------------------------
# data file: permutation example
perm.eg <- read.csv(file.choose(), header = TRUE, row.names = 1)

# plot the data
install.packages("ggplot2")
library(ggplot2)

ggplot(data = perm.eg, aes(x=Resp1, y=Resp2)) +
  geom_point(aes(colour=Group, shape=Group), size=5) +
  labs(title="Permutation Example Data") +
  theme_bw()

# save the data
ggsave("graphics/permutations.png", width=3, height=2.5, units="in", dpi=300)


# permutation of the group identities
perm.eg$group.perm1 <- sample(perm.eg$Group)
perm.eg

ggplot(data = perm.eg, aes(x=Resp1, y=Resp2)) +
  geom_point(aes(colour=group.perm1, shape=group.perm1), size=5) +
  labs(title="Permutation 1") +
  theme_bw()




# Permutation OakWood data: grazing ----------------------------------------------------
# how is the plant community affected by grazing pressure?

setwd("~/SEFS_502")

#open data
Oak <- read.csv("data/Oak_data_47x216.csv", header = TRUE, row.names = 1)
Oak_species <- read.csv("data/Oak_species_189x5.csv", header = TRUE)
Oak_abund <- Oak[ , colnames(Oak) %in% Oak_species$SpeciesCode]

#load packages
library(labdsv)
library(vegan)

#remove rare species
Oak1 <- vegtab(Oak_abund, minval=0.05*nrow(Oak_abund))

#relative abundance between 0 and 1 based on maximum abundance
Oak1 <- decostand(Oak1, "max")

#create a unique object of just the grazing status of each plot (instead of indexing it each time we need it)
grazing <- Oak$GrazCurr

# ANOSIM with Bray-Curtis distances
#-- can take a distance matrix input or data (use "distance" option to calc distance matrix)

#-- simple example
perm.eg
perm.eg.anosim <- anosim(dat=perm.eg[,c("Resp1", "Resp2")], grouping=perm.eg$Group,
                         permutations=999, distance="euclidean") #error message: only 719 possible permutations
perm.eg.anosim


#-- oak data
#--- p = 999
oak.anosim <- anosim(dat=Oak1,grouping=grazing,
                     permutations=999, distance="bray",
                     strata=NULL, parallel=getOption("mc.cores"))

oak.anosim
#R=0.1333; p=0.009
plot(oak.anosim)
plot(density(oak.anosim$perm))
abline(v=oak.anosim$statistic, col="red")

#--- p = 9
oak.anosim.p9 <- anosim(dat=Oak1,grouping=grazing,
                     permutations=9, distance="bray",
                     strata=NULL, parallel=getOption("mc.cores"))

oak.anosim.p9
#R=0.1333; p=0.1


#--- p = 99
oak.anosim.p99 <- anosim(dat=Oak1,grouping=grazing,
                        permutations=99, distance="bray",
                        strata=NULL, parallel=getOption("mc.cores"))

oak.anosim.p99
#R=0.1333; p=0.01

#--- p = 9999
oak.anosim.p9999 <- anosim(dat=Oak1,grouping=grazing,
                         permutations=9999, distance="bray",
                         strata=NULL, parallel=getOption("mc.cores"))

oak.anosim.p9999
#R=0.1333; p=0.013

