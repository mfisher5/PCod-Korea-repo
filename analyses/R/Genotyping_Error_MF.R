############# plot % mismatches between replicates ##########
#
# MF 4/11/2018
#
#################################################################

library(readr)
library(dplyr)


# Read in data ------------------------------------------------------------
mydata <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/stacks_b8_verif/batch_8_verif_replicates_mismatches.txt", "\t", escape_double = FALSE, trim_ws = TRUE)
head(mydata)



# plot --------------------------------------------------------------------
ggplot(mydata, aes(x=loci.genotyped, y=p.mismatch)) +
  geom_point(size=2) +
  facet_wrap(~type) +
  xlab("Number of Loci Genotyped in Both Samples") +
  ylab("Percent Mismatched Genotypes") +
  theme(axis.title = element_text(size=14), axis.text = element_text(size=14))


ggplot(mydata, aes(x=diff.missing, y=p.mismatch)) +
  geom_point(size=2) +
  facet_wrap(~type) +
  xlab("Difference in # Loci with Missing Data") +
  ylab("Percent Mismatched Genotypes") +
  theme(axis.title = element_text(size=14), axis.text = element_text(size=14))




# Filter Samples <5,000 Loci ----------------------------------------------
mydata_filtered <- mydata %>%
  filter(loci.genotyped > 5000) %>%
  filter(diff.missing < 300)
ggplot(mydata_filtered, aes(x=type, y=p.mismatch, group=type)) +
  geom_boxplot() +
  ylab("Percent of Genotypes Mismatched") +
  theme(axis.title.y = element_text(size=14), axis.title.x = element_blank(), axis.text = element_text(size=14))

mydata_filtered %>% group_by(type) %>% summarise(avg = mean(p.mismatch))







