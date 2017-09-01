# Purpose: getting Fis per locus
#
#From: Natalie 3/24/2017
#Changed for Pcod (US) 
#
#
#
# ---------------------------------------------------------------------------------

# Import these libraries
install.packages("hierfstat")
library(adegenet)
library(hierfstat)

# Set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses")


# Read in your data as a genepop file, with a ".gen" file extension
# Need comma after each individual, can be space or tab delimited
# Specify how many characters code each allele with ncode
my_data <-read.genepop("batch_6.filteredMAF_filteredLoci_30filteredIndivids_filteredHWE_noreps.gen")

# To retreive useful data summaries
(summary(my_data))
my_data$pop

###########################################################
# Calculate allele frequencies for each locus in each population . Output saved as list
my_freq <- pop.freq(my_data)


#Query a locus of interest:
my_freq$L_27234

##############################################################
# Calculate number of individuals in data

# Counts the number of individual genotyped per locus and population
my_ind <- ind.count(my_data)
my_stats <- basic.stats(my_data)

#Get Observed heterozygosities per locus and pop
my_stats$Ho

# Get Expected heterozygosities per locus and pop (well, a proxy for them called 'gene diversity". Fucking Goudet)
my_stats$Hs

# Count succesful genotypes per locus
basic.stats(my_data)$n.ind.samp

# Get Fis per locus and pop 
my_stats$Fis

# Write any ofthese stats out to a text file so you can see what the fuck you are doing
write.table(my_stats$Hs, "b6_30_Hs_hierfstat.txt", sep="\t")
write.table(my_stats$Fis, "b6_30_Fis_hierfstat.txt", sep="\t")
write.table(basic.stats(my_data)$n.ind.samp, "Genotype_counts.txt", sep="\t")



##########################################################################################################

my_data <-read.genepop("batch_6.filteredMAF_filteredLoci_20filteredIndivids_filteredHWE_noreps.gen")

# To retreive useful data summaries
(summary(my_data))
my_data$pop
my_stats <- basic.stats(my_data)

# Write any ofthese stats out to a text file so you can see what the fuck you are doing
write.table(my_stats$Hs, "b6_20_Hs_hierfstat.txt", sep="\t")
write.table(my_stats$Fis, "b6_20_Fis_hierfstat.txt", sep="\t")

