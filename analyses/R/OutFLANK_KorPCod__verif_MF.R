###################### USING OUTFLANK TO IDENTIFY OUTLIERS ##########################

## MF 10/5/2017
## for Korea PCod
## see github: https://github.com/whitlock/OutFLANK/blob/master/R/OutFLANK.R
## PDF with instructions: https://github.com/whitlock/OutFLANK/blob/master/OutFLANK%20readme.pdf


####### Set working directory #######
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses/Outliers/batch8_verif")


####### Install necessary packages ##########

install.packages("devtools")
library(devtools)
source("http://bioconductor.org/biocLite.R")
biocLite("qvalue")
install_github("whitlock/OutFLANK", force = TRUE)
library(OutFLANK)
source("https://raw.githubusercontent.com/whitlock/OutFLANK/master/R/Fst%20Diploids.R")



# Outflank, All Sampling Sites --------------------------------------------

# Load input file #
# File format: input file is a dataframe. Each row is a locus.
#       The column headers are- $LocusName, $FST, $T1, $T2, $FSTNoCorr, $T1NoCorr, $T2NoCorr, $He
# MakeDiploidFSTMat(SNPmat, locusNames, popNames)
#       This will generate the input data frame from an array with rows - individuals, columns - loci. Alleles are coded as (0,1,2,9).

# To convert a genepop file to the input SNPmat, see python script here:https://github.com/mfisher5/PCod-Korea-repo/blob/master/analyses/Outliers/convert_genepop_to_SNPmat.py

loci <- read.table("batch_8_verif_SNPmat_locusnames.txt", header=F)
pops <- read.table("batch_8_verif_SNPmat_popnames.txt", header=F)
data = read.csv("batch_8_verif_final_filtered_SNPmat.txt", header = FALSE, sep = "\t")
View(data)
datamat = as.matrix(data)

FstDataFrame <- MakeDiploidFSTMat(SNPmat = data, locusNames = loci, popNames = pops)





# Identify Outliers #


allKOR <- OutFLANK(FstDataFrame, LeftTrimFraction=0.05, RightTrimFraction=0.05, Hmin=0.1, NumberOfSamples=9, qthreshold=0.05)

# take a look at the output! 
head(allKOR)
typeof(allKOR) # spoiler: it's a list.
dim(allKOR$results[which(allKOR$results$OutlierFlag==T),]) # how many outliers do you have? 1st num




# Write output to a text file #

head(allKOR$results)
outlier_indices <- which(allKOR$results$OutlierFlag == "TRUE")

locus <- c()
he <- c()
fst <-c ()
meanAlleleFreq <- c()
qvals <- c()
pv <- c()
outlier <- c()


for(i in outlier_indices){
  locus <- c(locus, allKOR$results$LocusName[i])
  he <- c(he, allKOR$results$He[i])
  fst <- c(fst, allKOR$results$FST[i])
  meanAlleleFreq <- c(meanAlleleFreq, allKOR$results$meanAlleleFreq[i])
  qvals <- c(qvals, allKOR$results$qvalues[i])
  pv <- c(pv, allKOR$results$pvalues[i])
  outlier <- c(outlier, allKOR$results$OutlierFlag[i])
}

#it's not great, but it works
dataframe <- cbind(locus, he, fst, meanAlleleFreq, qvals, pv, outlier)
write.csv(dataframe, file="allKOR_b8_verif_outflank_outliers.csv", quote=FALSE,  row.names=FALSE)



# Plotting results #

# plots the actual (yellow) and theoretical (smoothed blue curve) distribution of Fst
OutFLANKResultsPlotter(allKOR)

# plots Fst against expected Heterozygosity
plot(allKOR$results$FST, allKOR$results$He, xlab = "Per Locus FST", ylab = "Per Locus He")


# Outflank, By Region -----------------------------------------------------


# Load input file #\

loci <- read.table("batch_8_verif_SNPmat_byreg_locusnames.txt", header=F)
pops <- read.table("batch_8_verif_SNPmat_byreg_popnames.txt", header=F)
data = read.csv("batch_8_verif_final_filtered_byreg_SNPmat.txt", header = FALSE, sep = "\t")
View(data)
datamat = as.matrix(data)

FstDataFrame <- MakeDiploidFSTMat(SNPmat = data, locusNames = loci, popNames = pops)



# Identify Outliers #
regKOR <- OutFLANK(FstDataFrame, LeftTrimFraction=0.05, RightTrimFraction=0.05, Hmin=0.1, NumberOfSamples=9, qthreshold=0.05)

# take a look at the output! 
dim(regKOR$results[which(regKOR$results$OutlierFlag==T),]) # how many outliers do you have? 1st num


# Write output to a text file #

head(regKOR$results)
outlier_indices <- which(regKOR$results$OutlierFlag == "TRUE")

locus <- c()
he <- c()
fst <-c ()
meanAlleleFreq <- c()
qvals <- c()
pv <- c()
outlier <- c()


for(i in outlier_indices){
  locus <- c(locus, regKOR$results$LocusName[i])
  he <- c(he, regKOR$results$He[i])
  fst <- c(fst, regKOR$results$FST[i])
  meanAlleleFreq <- c(meanAlleleFreq, regKOR$results$meanAlleleFreq[i])
  qvals <- c(qvals, regKOR$results$qvalues[i])
  pv <- c(pv, regKOR$results$pvalues[i])
  outlier <- c(outlier, regKOR$results$OutlierFlag[i])
}

#it's not great, but it works
dataframe <- cbind(locus, he, fst, meanAlleleFreq, qvals, pv, outlier)
write.csv(dataframe, file="allKOR_b8_verif_outflank_outliers_byregion.csv", quote=FALSE,  row.names=FALSE)

# Plotting results #

# plots the actual (yellow) and theoretical (smoothed blue curve) distribution of Fst
OutFLANKResultsPlotter(regKOR)

# plots Fst against expected Heterozygosity
plot(regKOR$results$FST, regKOR$results$He, xlab = "Per Locus FST", ylab = "Per Locus He")



# Outflank, Southern Sampling Sites -----------------------------------------------------


# Load input file #

loci <- read.table("batch_8_verif_SNPmat_south_locusnames.txt", header=F)
pops <- read.table("batch_8_verif_SNPmat_south_popnames.txt", header=F)
data = read.csv("batch_8_verif_final_filtered_south_SNPmat.txt", header = FALSE, sep = "\t")
View(data)
datamat = as.matrix(data)

FstDataFrame <- MakeDiploidFSTMat(SNPmat = data, locusNames = loci, popNames = pops)



# Identify Outliers #


southKOR <- OutFLANK(FstDataFrame, LeftTrimFraction=0.05, RightTrimFraction=0.05, Hmin=0.1, NumberOfSamples=6, qthreshold=0.05)

# take a look at the output! 
dim(southKOR$results[which(southKOR$results$OutlierFlag==T),]) # how many outliers do you have? 1st num

# Write output to a text file #

head(southKOR$results)
outlier_indices <- which(southKOR$results$OutlierFlag == "TRUE")

locus <- c()
he <- c()
fst <-c ()
meanAlleleFreq <- c()
qvals <- c()
pv <- c()
outlier <- c()


for(i in outlier_indices){
  locus <- c(locus, southKOR$results$LocusName[i])
  he <- c(he, southKOR$results$He[i])
  fst <- c(fst, southKOR$results$FST[i])
  meanAlleleFreq <- c(meanAlleleFreq, southKOR$results$meanAlleleFreq[i])
  qvals <- c(qvals, southKOR$results$qvalues[i])
  pv <- c(pv, southKOR$results$pvalues[i])
  outlier <- c(outlier, southKOR$results$OutlierFlag[i])
}

#it's not great, but it works
dataframe <- cbind(locus, he, fst, meanAlleleFreq, qvals, pv, outlier)
write.csv(dataframe, file="southKOR_b8_verif_outflank_outliers.csv", quote=FALSE,  row.names=FALSE)



# Plotting results #

# plots the actual (yellow) and theoretical (smoothed blue curve) distribution of Fst
OutFLANKResultsPlotter(southKOR)

# plots Fst against expected Heterozygosity
plot(southKOR$results$FST, southKOR$results$He, xlab = "Per Locus FST", ylab = "Per Locus He")




# Outflank, Jinhae Bay Temp -----------------------------------------------------


# Load input file #

loci <- read.table("batch_8_verif_SNPmat_jb_locusnames.txt", header=F)
pops <- read.table("batch_8_verif_SNPmat_jb_popnames.txt", header=F)
data = read.csv("batch_8_verif_final_filtered_jb_SNPmat.txt", header = FALSE, sep = "\t")

datamat = as.matrix(data)

FstDataFrame <- MakeDiploidFSTMat(SNPmat = data, locusNames = loci, popNames = pops)



# Identify Outliers #


jbKOR <- OutFLANK(FstDataFrame, LeftTrimFraction=0.05, RightTrimFraction=0.05, Hmin=0.1, NumberOfSamples=1, qthreshold=0.05)

# take a look at the output! 
dim(jbKOR$results[which(jbKOR$results$OutlierFlag==T),]) # how many outliers do you have? 1st num


# Write output to a text file #

head(jbKOR$results)
outlier_indices <- which(jbKOR$results$OutlierFlag == "TRUE")

locus <- c()
he <- c()
fst <-c ()
meanAlleleFreq <- c()
qvals <- c()
pv <- c()
outlier <- c()


for(i in outlier_indices){
  locus <- c(locus, jbKOR$results$LocusName[i])
  he <- c(he, jbKOR$results$He[i])
  fst <- c(fst, jbKOR$results$FST[i])
  meanAlleleFreq <- c(meanAlleleFreq, jbKOR$results$meanAlleleFreq[i])
  qvals <- c(qvals, jbKOR$results$qvalues[i])
  pv <- c(pv, jbKOR$results$pvalues[i])
  outlier <- c(outlier, jbKOR$results$OutlierFlag[i])
}

#it's not great, but it works
dataframe <- cbind(locus, he, fst, meanAlleleFreq, qvals, pv, outlier)
write.csv(dataframe, file="jbKOR_b8_verif_outflank_outliers.csv", quote=FALSE,  row.names=FALSE)



# Plotting results #

# plots the actual (yellow) and theoretical (smoothed blue curve) distribution of Fst
OutFLANKResultsPlotter(jbKOR)

# plots Fst against expected Heterozygosity
plot(jbKOR$results$FST, jbKOR$results$He, xlab = "Per Locus FST", ylab = "Per Locus He")




# Outflank, Geoje Temp -----------------------------------------------------


# Load input file #

loci <- read.table("batch_8_verif_SNPmat_ge_locusnames.txt", header=F)
pops <- read.table("batch_8_verif_SNPmat_ge_popnames.txt", header=F)
data = read.csv("batch_8_verif_final_filtered_ge_SNPmat.txt", header = FALSE, sep = "\t")

datamat = as.matrix(data)

FstDataFrame <- MakeDiploidFSTMat(SNPmat = data, locusNames = loci, popNames = pops)



# Identify Outliers #


geKOR <- OutFLANK(FstDataFrame, LeftTrimFraction=0.05, RightTrimFraction=0.05, Hmin=0.1, NumberOfSamples=2, qthreshold=0.05)


# take a look at the output! 
dim(geKOR$results[which(geKOR$results$OutlierFlag==T),]) # how many outliers do you have? 1st num


# Write output to a text file #

head(geKOR$results)
outlier_indices <- which(geKOR$results$OutlierFlag == "TRUE")

locus <- c()
he <- c()
fst <-c ()
meanAlleleFreq <- c()
qvals <- c()
pv <- c()
outlier <- c()


for(i in outlier_indices){
  locus <- c(locus, geKOR$results$LocusName[i])
  he <- c(he, geKOR$results$He[i])
  fst <- c(fst, geKOR$results$FST[i])
  meanAlleleFreq <- c(meanAlleleFreq, geKOR$results$meanAlleleFreq[i])
  qvals <- c(qvals, geKOR$results$qvalues[i])
  pv <- c(pv, geKOR$results$pvalues[i])
  outlier <- c(outlier, geKOR$results$OutlierFlag[i])
}

#it's not great, but it works
dataframe <- cbind(locus, he, fst, meanAlleleFreq, qvals, pv, outlier)
write.csv(dataframe, file="geKOR_b8_verif_outflank_outliers_s2.csv", quote=FALSE,  row.names=FALSE)



# Plotting results #

# plots the actual (yellow) and theoretical (smoothed blue curve) distribution of Fst
OutFLANKResultsPlotter(geKOR)

# plots Fst against expected Heterozygosity
plot(geKOR$results$FST, geKOR$results$He, xlab = "Per Locus FST", ylab = "Per Locus He")






# Outflank, South v. East -----------------------------------------------------


# Load input file #

loci <- read.table("batch_8_verif_SNPmat_se_locusnames.txt", header=F)
pops <- read.table("batch_8_verif_SNPmat_se_popnames.txt", header=F)
data = read.csv("batch_8_verif_final_filtered_se_SNPmat.txt", header = FALSE, sep = "\t")

datamat = as.matrix(data)

FstDataFrame <- MakeDiploidFSTMat(SNPmat = data, locusNames = loci, popNames = pops)



# Identify Outliers #


seKOR <- OutFLANK(FstDataFrame, LeftTrimFraction=0.05, RightTrimFraction=0.05, Hmin=0.1, NumberOfSamples=7, qthreshold=0.05)


# take a look at the output! 
dim(seKOR$results[which(seKOR$results$OutlierFlag==T),]) # how many outliers do you have? 1st num


# Write output to a text file #

head(seKOR$results)
outlier_indices <- which(seKOR$results$OutlierFlag == "TRUE")

locus <- c()
he <- c()
fst <-c ()
meanAlleleFreq <- c()
qvals <- c()
pv <- c()
outlier <- c()


for(i in outlier_indices){
  locus <- c(locus, seKOR$results$LocusName[i])
  he <- c(he, seKOR$results$He[i])
  fst <- c(fst, seKOR$results$FST[i])
  meanAlleleFreq <- c(meanAlleleFreq, seKOR$results$meanAlleleFreq[i])
  qvals <- c(qvals, seKOR$results$qvalues[i])
  pv <- c(pv, seKOR$results$pvalues[i])
  outlier <- c(outlier, seKOR$results$OutlierFlag[i])
}

#it's not great, but it works
dataframe <- cbind(locus, he, fst, meanAlleleFreq, qvals, pv, outlier)
write.csv(dataframe, file="seKOR_b8_verif_outflank_outliers_bypop_s7.csv", quote=FALSE,  row.names=FALSE)



# Plotting results #

# plots the actual (yellow) and theoretical (smoothed blue curve) distribution of Fst
OutFLANKResultsPlotter(seKOR)

# plots Fst against expected Heterozygosity
plot(seKOR$results$FST, seKOR$results$He, xlab = "Per Locus FST", ylab = "Per Locus He")






# Outflank, South v. West -----------------------------------------------------


# Load input file #

loci <- read.table("batch_8_verif_SNPmat_sw_locusnames.txt", header=F)
pops <- read.table("batch_8_verif_SNPmat_sw_popnames.txt", header=F)
data = read.csv("batch_8_verif_final_filtered_sw_SNPmat.txt", header = FALSE, sep = "\t")

datamat = as.matrix(data)

FstDataFrame <- MakeDiploidFSTMat(SNPmat = data, locusNames = loci, popNames = pops)



# Identify Outliers #


swKOR <- OutFLANK(FstDataFrame, LeftTrimFraction=0.05, RightTrimFraction=0.05, Hmin=0.1, NumberOfSamples=8, qthreshold=0.05)


# take a look at the output! 
dim(swKOR$results[which(swKOR$results$OutlierFlag==T),]) # how many outliers do you have? 1st num


# Write output to a text file #

head(swKOR$results)
outlier_indices <- which(swKOR$results$OutlierFlag == "TRUE")

locus <- c()
he <- c()
fst <-c ()
meanAlleleFreq <- c()
qvals <- c()
pv <- c()
outlier <- c()


for(i in outlier_indices){
  locus <- c(locus, swKOR$results$LocusName[i])
  he <- c(he, swKOR$results$He[i])
  fst <- c(fst, swKOR$results$FST[i])
  meanAlleleFreq <- c(meanAlleleFreq, swKOR$results$meanAlleleFreq[i])
  qvals <- c(qvals, swKOR$results$qvalues[i])
  pv <- c(pv, swKOR$results$pvalues[i])
  outlier <- c(outlier, swKOR$results$OutlierFlag[i])
}

#it's not great, but it works
dataframe <- cbind(locus, he, fst, meanAlleleFreq, qvals, pv, outlier)
write.csv(dataframe, file="swKOR_b8_verif_outflank_outliers.csv", quote=FALSE,  row.names=FALSE)



# Plotting results #

# plots the actual (yellow) and theoretical (smoothed blue curve) distribution of Fst
OutFLANKResultsPlotter(swKOR)

# plots Fst against expected Heterozygosity
plot(swKOR$results$FST, swKOR$results$He, xlab = "Per Locus FST", ylab = "Per Locus He")






# Outflank, East v. West -----------------------------------------------------


# Load input file #

loci <- read.table("batch_8_verif_SNPmat_ew_locusnames.txt", header=F)
pops <- read.table("batch_8_verif_SNPmat_ew_popnames.txt", header=F)
data = read.csv("batch_8_verif_final_filtered_ew_SNPmat.txt", header = FALSE, sep = "\t")

datamat = as.matrix(data)

FstDataFrame <- MakeDiploidFSTMat(SNPmat = data, locusNames = loci, popNames = pops)



# Identify Outliers #


ewKOR <- OutFLANK(FstDataFrame, LeftTrimFraction=0.05, RightTrimFraction=0.05, Hmin=0.1, NumberOfSamples=3, qthreshold=0.05)


# take a look at the output! 
dim(ewKOR$results[which(ewKOR$results$OutlierFlag==T),]) # how many outliers do you have? 1st num


# Write output to a text file #

head(swKOR$results)
outlier_indices <- which(swKOR$results$OutlierFlag == "TRUE")

locus <- c()
he <- c()
fst <-c ()
meanAlleleFreq <- c()
qvals <- c()
pv <- c()
outlier <- c()


for(i in outlier_indices){
  locus <- c(locus, swKOR$results$LocusName[i])
  he <- c(he, swKOR$results$He[i])
  fst <- c(fst, swKOR$results$FST[i])
  meanAlleleFreq <- c(meanAlleleFreq, swKOR$results$meanAlleleFreq[i])
  qvals <- c(qvals, swKOR$results$qvalues[i])
  pv <- c(pv, swKOR$results$pvalues[i])
  outlier <- c(outlier, swKOR$results$OutlierFlag[i])
}

#it's not great, but it works
dataframe <- cbind(locus, he, fst, meanAlleleFreq, qvals, pv, outlier)
write.csv(dataframe, file="swKOR_b8_verif_outflank_outliers.csv", quote=FALSE,  row.names=FALSE)



# Plotting results #

# plots the actual (yellow) and theoretical (smoothed blue curve) distribution of Fst
OutFLANKResultsPlotter(ewKOR)

# plots Fst against expected Heterozygosity
plot(swKOR$results$FST, swKOR$results$He, xlab = "Per Locus FST", ylab = "Per Locus He")





