# This code was written by Eleni and Dan on July 18, 2017
# Function of the code:
# This code will compare replicated samples for genotype mismatches. 
# Genotype mismatch rate is defined as = (number of mismatches)/(number of loci genotyped in both samples being compared)

# 1. Reads in a matrix of genotypes. Columns = samples, rows = loci. 
# 2. The samples you want to compare to each other must be right next to each other on the spreadsheet.Sample1 = odd column; sample2= even row 
# 3. It will calculate the % match in each sample pair! Yay!



# Set working directory 
setwd("D:/sequencing_data/Herring_DissertationCH1/scripts_R")

#Read in your data tables from a tab-delimited text files 

mydata1 <- read.delim("MismatchRate_JuvenileSamples_NaOCltoNaOCl_3502loci.txt", row.names = 1)
mydata2 <- read.delim("MismatchRate_JuvenileSamples_NulltoNaOCl_3502loci.txt", row.names = 1)

# This next piece of code counts the number of genotypes in the even columns that
# match the the number of genotypes in the odd columns. It then divides that number by the 
# number of loci in the dataset, and subtracts it from one to get the mismatch rate. 



#NaOCl-NaOCl treatment comparison

mismatch_rate1 <- c()

for(i in seq(1, ncol(mydata1)-1, 2)){
  good_data <- which(mydata1[,i]!=0 & mydata1[,(i+1)] !=0) # Figure out which loci are genotyped in both samples
  mismatch_rate1[length(mismatch_rate1)+1] <- 1-length(which((mydata1[good_data,i]==mydata1[good_data,(i+1)])==TRUE))/length(good_data)
}

mean(mismatch_rate1)
sd(mismatch_rate1)



#Null-NaOCl
mismatch_rate2 <- c()

for(i in seq(1, ncol(mydata2)-1, 2)){
  good_data2 <- which(mydata2[,i]!=0 & mydata2[,(i+1)] !=0)
  mismatch_rate2[length(mismatch_rate2)+1] <- 1-length(which((mydata2[good_data2,i]==mydata2[good_data2,(i+1)])==TRUE))/length(good_data2)
}

mean(mismatch_rate2)
sd(mismatch_rate2)


## Extra metadata for plotting the results

Treatment <- c(rep("NaOCl", 8), rep("Null vs. NaOCl", 16))
mismatch_vector <- c(mismatch_rate1, mismatch_rate2)


final_df <- data.frame(mismatch_vector, Treatment)


# Plot the data!

library(ggplot2)
theme_set(theme_classic()) 

myplot <- ggplot(final_df, aes(Treatment, mismatch_vector, fill = Treatment)) +
  geom_boxplot() + 
  labs(x="\nComparison of replicated juvenile samples",
       y="Genotyping mismatch rate\n") +
  theme(text = element_text(size = 14), plot.margin = unit(c(1,1,1,1), "cm"))

myplot
