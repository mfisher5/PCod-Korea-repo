#script to calculate Ne using LD methods Hill 1981, Waples 2006
#Wes Larson, wlarson1@uw.edu
#4/28/2014

rm(list = ls())
install.packages("plyr")
library(plyr)
library(dplyr)

#################
#functions to calculate Ne

#calc weighted mean (table 5 Dl in MER 2013 paper)
###It weights the r-squared drift value at each locus by the sample size squared and then takes the mean

calc_weighted_mean_r2=function(sample_sizes,r2_values)
{
  samp_sizes_sq=sample_sizes^2
  sum_samp_sizes=sum(samp_sizes_sq)
  sum_weighted_r2_vals=sum(samp_sizes_sq*r2_values)
  weighted_mean_r2=round(sum_weighted_r2_vals/sum_samp_sizes,15)
  return(weighted_mean_r2)
}


#calculate Ne
##Uses the formula in Waples 2006 for random mating and when sample size is greater than 30

calc_ne=function(mean_r2_drift)
{ 
  Ne=round((1/3+sqrt(1/9-(2.76*mean_r2_drift)))/(2*mean_r2_drift),6)
  return(Ne)
}

#calculate 95% parametric CI
#calc CI based on overall R2
calc_95_ci=function(sample_size_col,weighted_mean_r2_drift,num_compars)
{
  #calc expected R2 for each sample; this is based on Waples 2006 to further correct for bias in estimated E(r2)
  expected_r2_all_compars=(1/sample_size_col)+(3.19/(sample_size_col^2))
  #calc weighted mean of expected R2 across all samples
  weighted_mean_expected_R2=calc_weighted_mean_r2(sample_size_col,expected_r2_all_compars)
  #find overall R2 that, after subtracting expected r2, would result in Ne
  #overall R2=R2 drift+expected R2
  (overall_r2_for_ci=weighted_mean_r2_drift+weighted_mean_expected_R2)
  #calc CI 
  chisq_val_up=qchisq(.975,df=num_compars)
  chisq_val_low=qchisq(.025,df=num_compars)
  top_ci=(overall_r2_for_ci*num_compars)/chisq_val_up
  top_ci_drift=top_ci-weighted_mean_expected_R2
  ne_top=calc_ne(top_ci_drift)
  low_ci=(overall_r2_for_ci*num_compars)/chisq_val_low
  low_ci_drift=low_ci-weighted_mean_expected_R2
  ne_low=calc_ne(low_ci_drift)
  return(cbind(ne_low,ne_top))
}

#################### end functions



# PCod: Load data ---------------------------------------------------------
###Set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses/Ne/NeEstimator/Correction")


###Import cleaned burrows files from NeEstimator and cleaned by Wes's python script
bur_1998<-read.table("clean_batch_8_final_filtered_aligned_nomigrants_south_byyear3Bur.txt",header=TRUE,sep="\t")

head(bur_1998)


##Import map data which gives the chromosome for each locus
align_data<-read.table("batch_8_verif_bowtie2_Acod_filteredMQ_locilist.txt",header=TRUE,sep="\t")
head(align_data)
align_data$newlocus <- seq(1,length(align_data$locus),by=1)
head(align_data)


map_info_locus1 = align_data[,2:3]
head(map_info_locus1)

colnames(map_info_locus1) <- c("Chrom_locus1", "locus1")
map_info_locus2 <- map_info_locus1
colnames(map_info_locus2) <- c("Chrom_locus2", "locus2")


# PCod: Run filtering code ------------------------------------------------

###Join Burrow's files with the map info which says the chromosome on which each locus is located
bur_1998_join1<-join(bur_1998,map_info_locus1,by="locus1")
head(bur_1998_join1)
bur_1998_chroms<-join(bur_1998_join1,map_info_locus2,by="locus2")
head(bur_1998_chroms)


########Test filtering Code
#test_bur<-bur_1998_chroms[1:1000,]
#test_bur_filtered<-test_bur[test_bur$Chrom_locus1 != test_bur$Chrom_locus2,]


bur1998_diffchroms<-filter(bur_1998_chroms, Chrom_locus1 != Chroms_locus2)
head(bur1998_diffchroms)
dim(bur_1998_chroms)
dim(bur1998_diffchroms)



# PCod: Calculate Ne and 95% confidence intervals -------------------------
weighted_mean_drift1998<-calc_weighted_mean_r2(bur1998_diffchroms[,3],bur1998_diffchroms[,5])
ne_diffchroms1998<-calc_ne(weighted_mean_drift1998)
ne_diffchroms1998
ne_diffchroms1998_CI <- calc_95_ci(bur1998_diffchroms[,3],weighted_mean_drift1998,length(bur1998_diffchroms[,3]))
ne_diffchroms1998_CI





#################################################################################### 
#Examples from Wes

#read in data
#ne_input_data=as.matrix(read.csv("example_ne_input_lynxct.csv",header=TRUE))

#calculate weighted mean drift, arguments are sample size col and r2 drift col
#weighted_mean_drift=calc_weighted_mean_r2(ne_input_data[,3],ne_input_data[,5])
#weighted_mean_drift

#calc ne using weighted mean drift
#ne=calc_ne(weighted_mean_drift)
#ne

#calc 95% CI, arguments are sample size col, weighted mean drift, number of comparisons (length of any column)
#ne_95_ci=calc_95_ci(ne_input_data[,3],weighted_mean_drift,length(ne_input_data[,3]))
#ne_95_ci
#########################################################################################################

###################Calculate Ne and 95% CI's using Wes's formula

####1998
weighted_mean_drift1998<-calc_weighted_mean_r2(bur1998_diffchroms[,3],bur1998_diffchroms[,5])
ne_diffchroms1998<-calc_ne(weighted_mean_drift1998)
ne_diffchroms1998
ne_diffchroms1998_CI <- calc_95_ci(bur1998_diffchroms[,3],weighted_mean_drift1998,length(bur1998_diffchroms[,3]))
ne_diffchroms1998_CI

####2002INT
weighted_mean_drift2002INT<-calc_weighted_mean_r2(bur2002INT_diffchroms[,3],bur2002INT_diffchroms[,5])
ne_diffchroms2002INT<-calc_ne(weighted_mean_drift2002INT)
ne_diffchroms2002INT
ne_diffchroms2002INT_CI <- calc_95_ci(bur2002INT_diffchroms[,3],weighted_mean_drift2002INT,length(bur2002INT_diffchroms[,3]))
ne_diffchroms2002INT_CI

####2002SEG
weighted_mean_drift2002SEG<-calc_weighted_mean_r2(bur2002SEG_diffchroms[,3],bur2002SEG_diffchroms[,5])
ne_diffchroms2002SEG<-calc_ne(weighted_mean_drift2002SEG)
ne_diffchroms2002SEG
ne_diffchroms2002SEG_CI <- calc_95_ci(bur2002SEG_diffchroms[,3],weighted_mean_drift2002SEG,length(bur2002SEG_diffchroms[,3]))
ne_diffchroms2002SEG_CI

####2006INT
weighted_mean_drift2006INT<-calc_weighted_mean_r2(bur2006INT_diffchroms[,3],bur2006INT_diffchroms[,5])
ne_diffchroms2006INT<-calc_ne(weighted_mean_drift2006INT)
ne_diffchroms2006INT
ne_diffchroms2006INT_CI <- calc_95_ci(bur2006INT_diffchroms[,3],weighted_mean_drift2006INT,length(bur2006INT_diffchroms[,3]))
ne_diffchroms2006INT_CI

####2006SEG
weighted_mean_drift2006SEG<-calc_weighted_mean_r2(bur2006SEG_diffchroms[,3],bur2006SEG_diffchroms[,5])
ne_diffchroms2006SEG<-calc_ne(weighted_mean_drift2006SEG)
ne_diffchroms2006SEG
ne_diffchroms2006SEG_CI <- calc_95_ci(bur2006SEG_diffchroms[,3],weighted_mean_drift2006SEG,length(bur2006SEG_diffchroms[,3]))
ne_diffchroms2006SEG_CI


####2010INT
weighted_mean_drift2010INT<-calc_weighted_mean_r2(bur2010INT_diffchroms[,3],bur2010INT_diffchroms[,5])
ne_diffchroms2010INT<-calc_ne(weighted_mean_drift2010INT)
ne_diffchroms2010INT
ne_diffchroms2010INT_CI <- calc_95_ci(bur2010INT_diffchroms[,3],weighted_mean_drift2010INT,length(bur2010INT_diffchroms[,3]))
ne_diffchroms2010INT_CI

####2010SEG
weighted_mean_drift2010SEG<-calc_weighted_mean_r2(bur2010SEG_diffchroms[,3],bur2010SEG_diffchroms[,5])
ne_diffchroms2010SEG<-calc_ne(weighted_mean_drift2010SEG)
ne_diffchroms2010SEG
ne_diffchroms2010SEG_CI <- calc_95_ci(bur2010SEG_diffchroms[,3],weighted_mean_drift2010SEG,length(bur2010SEG_diffchroms[,3]))
ne_diffchroms2010SEG_CI






#################################################################################################################
##Now calculate Ne using non outlier loci but only one locus per map position instead of all loci (reduced number 
# of loci from 4194 to 1628)

###Import cleaned burrows files from NeEstimator and cleaned by Wes's python script
bur_1998<-read.table("One_per_position/clean_One_position1998Bur.txt",header=TRUE,sep="")
bur_2002INT<-read.table("One_per_position/clean_One_position2002INTBur.txt",header=TRUE,sep="")
bur_2002SEG<-read.table("One_per_position/clean_One_position2002SEGBur.txt",header=TRUE,sep="")
bur_2006INT<-read.table("One_per_position/clean_One_position2006INTBur.txt",header=TRUE,sep="")
bur_2006SEG<-read.table("One_per_position/clean_One_position2006SEGBur.txt",header=TRUE,sep="")
bur_2010INT<-read.table("One_per_position/clean_One_position2010INTBur.txt",header=TRUE,sep="")
bur_2010SEG<-read.table("One_per_position/clean_One_position2010SEGBur.txt",header=TRUE,sep="")

##Import map data which gives the chromosome for each locus
map_info_locus1<-read.csv("Locus1_map_info.csv",header=TRUE)
map_info_locus2<-read.csv("Locus2_map_info.csv",header=TRUE)

###Join Burrow's files with the map info which says the chromosome on which each locus is located
bur_1998_join1<-join(bur_1998,map_info_locus1,by="locus1")
bur_1998_chroms<-join(bur_1998_join1,map_info_locus2,by="locus2")

bur_2002INT_join1<-join(bur_2002INT,map_info_locus1,by="locus1")
bur_2002INT_chroms<-join(bur_2002INT_join1,map_info_locus2,by="locus2")

bur_2002SEG_join1<-join(bur_2002SEG,map_info_locus1,by="locus1")
bur_2002SEG_chroms<-join(bur_2002SEG_join1,map_info_locus2,by="locus2")

bur_2006INT_join1<-join(bur_2006INT,map_info_locus1,by="locus1")
bur_2006INT_chroms<-join(bur_2006INT_join1,map_info_locus2,by="locus2")

bur_2006SEG_join1<-join(bur_2006SEG,map_info_locus1,by="locus1")
bur_2006SEG_chroms<-join(bur_2006SEG_join1,map_info_locus2,by="locus2")

bur_2010INT_join1<-join(bur_2010INT,map_info_locus1,by="locus1")
bur_2010INT_chroms<-join(bur_2010INT_join1,map_info_locus2,by="locus2")

bur_2010SEG_join1<-join(bur_2010SEG,map_info_locus1,by="locus1")
bur_2010SEG_chroms<-join(bur_2010SEG_join1,map_info_locus2,by="locus2")


#### Filter files for just comparisons between loci on different chromosomes

bur1998_diffchroms<-bur_1998_chroms[bur_1998_chroms$Chrom_locus1 != bur_1998_chroms$Chrom_locus2,]

bur2002INT_diffchroms<-bur_2002INT_chroms[bur_2002INT_chroms$Chrom_locus1 != bur_2002INT_chroms$Chrom_locus2,]

bur2002SEG_diffchroms<-bur_2002SEG_chroms[bur_2002SEG_chroms$Chrom_locus1 != bur_2002SEG_chroms$Chrom_locus2,]

bur2006INT_diffchroms<-bur_2006INT_chroms[bur_2006INT_chroms$Chrom_locus1 != bur_2006INT_chroms$Chrom_locus2,]

bur2006SEG_diffchroms<-bur_2006SEG_chroms[bur_2006SEG_chroms$Chrom_locus1 != bur_2006SEG_chroms$Chrom_locus2,]

bur2010INT_diffchroms<-bur_2010INT_chroms[bur_2010INT_chroms$Chrom_locus1 != bur_2010INT_chroms$Chrom_locus2,]

bur2010SEG_diffchroms<-bur_2010SEG_chroms[bur_2010SEG_chroms$Chrom_locus1 != bur_2010SEG_chroms$Chrom_locus2,]


###################Calculate Ne and 95% CI's using Wes's formula

####1998
weighted_mean_drift1998<-calc_weighted_mean_r2(bur1998_diffchroms[,3],bur1998_diffchroms[,5])
ne_diffchroms1998<-calc_ne(weighted_mean_drift1998)
ne_diffchroms1998
ne_diffchroms1998_CI <- calc_95_ci(bur1998_diffchroms[,3],weighted_mean_drift1998,length(bur1998_diffchroms[,3]))
ne_diffchroms1998_CI

####2002INT
weighted_mean_drift2002INT<-calc_weighted_mean_r2(bur2002INT_diffchroms[,3],bur2002INT_diffchroms[,5])
ne_diffchroms2002INT<-calc_ne(weighted_mean_drift2002INT)
ne_diffchroms2002INT
ne_diffchroms2002INT_CI <- calc_95_ci(bur2002INT_diffchroms[,3],weighted_mean_drift2002INT,length(bur2002INT_diffchroms[,3]))
ne_diffchroms2002INT_CI

####2002SEG
weighted_mean_drift2002SEG<-calc_weighted_mean_r2(bur2002SEG_diffchroms[,3],bur2002SEG_diffchroms[,5])
ne_diffchroms2002SEG<-calc_ne(weighted_mean_drift2002SEG)
ne_diffchroms2002SEG
ne_diffchroms2002SEG_CI <- calc_95_ci(bur2002SEG_diffchroms[,3],weighted_mean_drift2002SEG,length(bur2002SEG_diffchroms[,3]))
ne_diffchroms2002SEG_CI

####2006INT
weighted_mean_drift2006INT<-calc_weighted_mean_r2(bur2006INT_diffchroms[,3],bur2006INT_diffchroms[,5])
ne_diffchroms2006INT<-calc_ne(weighted_mean_drift2006INT)
ne_diffchroms2006INT
ne_diffchroms2006INT_CI <- calc_95_ci(bur2006INT_diffchroms[,3],weighted_mean_drift2006INT,length(bur2006INT_diffchroms[,3]))
ne_diffchroms2006INT_CI

####2006SEG
weighted_mean_drift2006SEG<-calc_weighted_mean_r2(bur2006SEG_diffchroms[,3],bur2006SEG_diffchroms[,5])
ne_diffchroms2006SEG<-calc_ne(weighted_mean_drift2006SEG)
ne_diffchroms2006SEG
ne_diffchroms2006SEG_CI <- calc_95_ci(bur2006SEG_diffchroms[,3],weighted_mean_drift2006SEG,length(bur2006SEG_diffchroms[,3]))
ne_diffchroms2006SEG_CI


####2010INT
weighted_mean_drift2010INT<-calc_weighted_mean_r2(bur2010INT_diffchroms[,3],bur2010INT_diffchroms[,5])
ne_diffchroms2010INT<-calc_ne(weighted_mean_drift2010INT)
ne_diffchroms2010INT
ne_diffchroms2010INT_CI <- calc_95_ci(bur2010INT_diffchroms[,3],weighted_mean_drift2010INT,length(bur2010INT_diffchroms[,3]))
ne_diffchroms2010INT_CI

####2010SEG
weighted_mean_drift2010SEG<-calc_weighted_mean_r2(bur2010SEG_diffchroms[,3],bur2010SEG_diffchroms[,5])
ne_diffchroms2010SEG<-calc_ne(weighted_mean_drift2010SEG)
ne_diffchroms2010SEG
ne_diffchroms2010SEG_CI <- calc_95_ci(bur2010SEG_diffchroms[,3],weighted_mean_drift2010SEG,length(bur2010SEG_diffchroms[,3]))
ne_diffchroms2010SEG_CI



###Import cleaned burrows files from NeEstimator and cleaned by Wes's python script
bur_1998<-read.table("clean_Founders_no_outliersBur.txt",header=TRUE,sep="")
bur_2002INT<-read.table("clean_2002INT_no_outliersBur.txt",header=TRUE,sep="")
bur_2002SEG<-read.table("clean_2002SEG_no_outliersBur.txt",header=TRUE,sep="")
bur_2006INT<-read.table("clean_2006INT_no_outliersBur.txt",header=TRUE,sep="")
bur_2006SEG<-read.table("clean_2006SEG_no_outliersBur.txt",header=TRUE,sep="")
bur_2010INT<-read.table("clean_2010INT_no_outliersBur.txt",header=TRUE,sep="")
bur_2010SEG<-read.table("clean_2010SEG_no_outliersBur.txt",header=TRUE,sep="")

##Import map data which gives the chromosome for each locus
map_info_locus1<-read.csv("Locus1_map_info.csv",header=TRUE)
map_info_locus2<-read.csv("Locus2_map_info.csv",header=TRUE)

###Join Burrow's files with the map info which says the chromosome on which each locus is located
bur_1998_join1<-join(bur_1998,map_info_locus1,by="locus1")
bur_1998_chroms<-join(bur_1998_join1,map_info_locus2,by="locus2")

bur_2002INT_join1<-join(bur_2002INT,map_info_locus1,by="locus1")
bur_2002INT_chroms<-join(bur_2002INT_join1,map_info_locus2,by="locus2")

bur_2002SEG_join1<-join(bur_2002SEG,map_info_locus1,by="locus1")
bur_2002SEG_chroms<-join(bur_2002SEG_join1,map_info_locus2,by="locus2")

bur_2006INT_join1<-join(bur_2006INT,map_info_locus1,by="locus1")
bur_2006INT_chroms<-join(bur_2006INT_join1,map_info_locus2,by="locus2")

bur_2006SEG_join1<-join(bur_2006SEG,map_info_locus1,by="locus1")
bur_2006SEG_chroms<-join(bur_2006SEG_join1,map_info_locus2,by="locus2")

bur_2010INT_join1<-join(bur_2010INT,map_info_locus1,by="locus1")
bur_2010INT_chroms<-join(bur_2010INT_join1,map_info_locus2,by="locus2")

bur_2010SEG_join1<-join(bur_2010SEG,map_info_locus1,by="locus1")
bur_2010SEG_chroms<-join(bur_2010SEG_join1,map_info_locus2,by="locus2")

########Test filtering Code
#test_bur<-bur_1998_chroms[1:1000,]
#test_bur_filtered<-test_bur[test_bur$Chrom_locus1 != test_bur$Chrom_locus2,]


bur1998_diffchroms<-bur_1998_chroms[bur_1998_chroms$Chrom_locus1 != bur_1998_chroms$Chrom_locus2,]

bur2002INT_diffchroms<-bur_2002INT_chroms[bur_2002INT_chroms$Chrom_locus1 != bur_2002INT_chroms$Chrom_locus2,]

bur2002SEG_diffchroms<-bur_2002SEG_chroms[bur_2002SEG_chroms$Chrom_locus1 != bur_2002SEG_chroms$Chrom_locus2,]

bur2006INT_diffchroms<-bur_2006INT_chroms[bur_2006INT_chroms$Chrom_locus1 != bur_2006INT_chroms$Chrom_locus2,]

bur2006SEG_diffchroms<-bur_2006SEG_chroms[bur_2006SEG_chroms$Chrom_locus1 != bur_2006SEG_chroms$Chrom_locus2,]

bur2010INT_diffchroms<-bur_2010INT_chroms[bur_2010INT_chroms$Chrom_locus1 != bur_2010INT_chroms$Chrom_locus2,]

bur2010SEG_diffchroms<-bur_2010SEG_chroms[bur_2010SEG_chroms$Chrom_locus1 != bur_2010SEG_chroms$Chrom_locus2,]


#################################################################################### 
#Examples from Wes

#read in data
#ne_input_data=as.matrix(read.csv("example_ne_input_lynxct.csv",header=TRUE))

#calculate weighted mean drift, arguments are sample size col and r2 drift col
#weighted_mean_drift=calc_weighted_mean_r2(ne_input_data[,3],ne_input_data[,5])
#weighted_mean_drift

#calc ne using weighted mean drift
#ne=calc_ne(weighted_mean_drift)
#ne

#calc 95% CI, arguments are sample size col, weighted mean drift, number of comparisons (length of any column)
#ne_95_ci=calc_95_ci(ne_input_data[,3],weighted_mean_drift,length(ne_input_data[,3]))
#ne_95_ci
#########################################################################################################

###################Calculate Ne and 95% CI's using Wes's formula

####1998
weighted_mean_drift1998<-calc_weighted_mean_r2(bur1998_diffchroms[,3],bur1998_diffchroms[,5])
ne_diffchroms1998<-calc_ne(weighted_mean_drift1998)
ne_diffchroms1998
ne_diffchroms1998_CI <- calc_95_ci(bur1998_diffchroms[,3],weighted_mean_drift1998,length(bur1998_diffchroms[,3]))
ne_diffchroms1998_CI

####2002INT
weighted_mean_drift2002INT<-calc_weighted_mean_r2(bur2002INT_diffchroms[,3],bur2002INT_diffchroms[,5])
ne_diffchroms2002INT<-calc_ne(weighted_mean_drift2002INT)
ne_diffchroms2002INT
ne_diffchroms2002INT_CI <- calc_95_ci(bur2002INT_diffchroms[,3],weighted_mean_drift2002INT,length(bur2002INT_diffchroms[,3]))
ne_diffchroms2002INT_CI

####2002SEG
weighted_mean_drift2002SEG<-calc_weighted_mean_r2(bur2002SEG_diffchroms[,3],bur2002SEG_diffchroms[,5])
ne_diffchroms2002SEG<-calc_ne(weighted_mean_drift2002SEG)
ne_diffchroms2002SEG
ne_diffchroms2002SEG_CI <- calc_95_ci(bur2002SEG_diffchroms[,3],weighted_mean_drift2002SEG,length(bur2002SEG_diffchroms[,3]))
ne_diffchroms2002SEG_CI

####2006INT
weighted_mean_drift2006INT<-calc_weighted_mean_r2(bur2006INT_diffchroms[,3],bur2006INT_diffchroms[,5])
ne_diffchroms2006INT<-calc_ne(weighted_mean_drift2006INT)
ne_diffchroms2006INT
ne_diffchroms2006INT_CI <- calc_95_ci(bur2006INT_diffchroms[,3],weighted_mean_drift2006INT,length(bur2006INT_diffchroms[,3]))
ne_diffchroms2006INT_CI

####2006SEG
weighted_mean_drift2006SEG<-calc_weighted_mean_r2(bur2006SEG_diffchroms[,3],bur2006SEG_diffchroms[,5])
ne_diffchroms2006SEG<-calc_ne(weighted_mean_drift2006SEG)
ne_diffchroms2006SEG
ne_diffchroms2006SEG_CI <- calc_95_ci(bur2006SEG_diffchroms[,3],weighted_mean_drift2006SEG,length(bur2006SEG_diffchroms[,3]))
ne_diffchroms2006SEG_CI


####2010INT
weighted_mean_drift2010INT<-calc_weighted_mean_r2(bur2010INT_diffchroms[,3],bur2010INT_diffchroms[,5])
ne_diffchroms2010INT<-calc_ne(weighted_mean_drift2010INT)
ne_diffchroms2010INT
ne_diffchroms2010INT_CI <- calc_95_ci(bur2010INT_diffchroms[,3],weighted_mean_drift2010INT,length(bur2010INT_diffchroms[,3]))
ne_diffchroms2010INT_CI

####2010SEG
weighted_mean_drift2010SEG<-calc_weighted_mean_r2(bur2010SEG_diffchroms[,3],bur2010SEG_diffchroms[,5])
ne_diffchroms2010SEG<-calc_ne(weighted_mean_drift2010SEG)
ne_diffchroms2010SEG
ne_diffchroms2010SEG_CI <- calc_95_ci(bur2010SEG_diffchroms[,3],weighted_mean_drift2010SEG,length(bur2010SEG_diffchroms[,3]))
ne_diffchroms2010SEG_CI















