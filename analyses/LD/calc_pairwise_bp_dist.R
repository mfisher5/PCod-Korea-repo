########### Calculate pairwise base pair distance ##########
#
# MF 8/20/2018
#
############################################################


# Set Working Directory / Load Packages -----------------------------------
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses/LD")

library(dplyr)
library(ggplot2)

# Import Data -------------------------------------------------------------
samdat <- read.csv("batch_8_verif_alignment_positions.csv")
head(samdat)



# Create Function ------------------------------------------------------
pairwise_dist <- function(data, scaffold){
  ## subset the data frame to include only loci for that scaffold, and arrange by base pair position
  mydat <- data %>%
    filter(Scaffold == scaffold) %>%
    arrange(Start_bp)
  ## initiate empty final data frame
  final_df <- data.frame(Locus1 = as.character(),
                         Locus2 = as.character(),
                         Scaffold = as.character(),
                         Distance = as.numeric(),
                         MQ = as.numeric())
  ## for "i" in a list of numbers 1: length of data
  for(i in seq(1,length(mydat$Locus))){
    ### save new locus at position "i"
    tmp_locus <- mydat$Locus[i]
    ### save position of that locus as the tmp_start
    tmp_start <- mydat$Start_bp[i]
    ### select all rows below tmp_locus (already did calculations for rows above)
    to_calc <- slice(mydat, i+1:n())
    ### rename the locus in the first column as the first locus
    colnames(to_calc)[1] <- "Locus1"
    colnames(to_calc)[3] <- "Locus1_Start"
    ### add columns with tmp_locus name / start position, and the distance between tmp_locus / each row's locus
    dist_df <- to_calc %>%
      mutate(Locus2 = tmp_locus) %>%
      mutate(Locus2_Start = tmp_start) %>%
      mutate(Distance = abs(tmp_start - Locus1_Start))
    ### reorder columns
    dist_df <- select(dist_df, c(Locus1, Locus2, Scaffold, Locus1_Start, Locus2_Start, Distance, MQ))
    final_df <- rbind(final_df, dist_df)
  }
  return(final_df)
}



# Apply function to each scaffold -----------------------------------------
outdat <- data.frame(Locus1 = as.character(),
                     Locus2 = as.character(),
                     Scaffold = as.character(),
                     Distance = as.numeric(),
                     MQ = as.numeric())

for(s in unique(samdat$Scaffold)){
  newdat <- pairwise_dist(data = samdat, scaffold = s)
  outdat <- rbind(outdat,newdat)
}



# Write out data frame ----------------------------------------------------
write.csv(file="batch_8_verif_alignment_pairwise_dist.csv", x=outdat, row.names=FALSE)



# Distribution of distances -----------------------------------------------
ggplot(outdat, aes(outdat$Distance)) +
  geom_bar()


