library(adegenet)
install.packages("strataG")
library(strataG)



# First, read in your data as a genepop file.The file
# can be delimited by tabs or spaces but there must abe a comma after each individual. 
# Specify how many characters code each allele with ncode. 
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/results/verif")

Adata <-read.genepop("../../stacks_b8_verif/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredCR.gen")

# convert file to gtypes object

g_obj <- genind2gtypes(Adata)


# At the heart of STRATAG are the tests of population
#structure. Included in the package are functions to
#calculate FST, F'ST, GST, G'ST, G''ST, hST, v2 and Jost's
#D. Each function takes a gtypes object, and returns
#the test statistic based on the current stratification of
#samples as well as the permutation test P-value, and
#optionally the null distribution of the statistic from
#the random permutations. Each statistic can be run
#independently or multiple statistics can be run at
#once with either the overallTest or pairwiseTest
#functions


# Please do not break on my giant dataset!! This takes approximately 3 days to run.
my_pwt <- pairwiseTest(g_obj, sats = c("Fst"))

my_results <- as.data.frame(my_pwt$result)
View(my_results)
class(my_results)
write.table(my_results, file = "PairwiseFstPVals_statag.txt", sep= "\t")

#Make histograms
hist(my_results$Chi2.p.val,breaks = 378,
     ylab = "Number of occurences",
     xlab = "p value of Chi2 permutation test",
     main = "Histogram of number of Chi2 p value")

hist(my_results$Fst.p.val,breaks = 378,
     ylab = "Number of occurences",
     xlab = "p value of Fst permutation test",
     main = "Histogram of number of Fst p value")

hist(my_results$Fst,breaks = 100,
     ylab = "Number of occurences",
     xlab = "pairwise Fst",
     main = "Histogram of pairwise Fst")

hist(my_results$Chi2,breaks = 100,
     ylab = "Number of occurences",
     xlab = "pairwise Chi2",
     main = "Histogram of pairwise Chi2")



write.table(my_results, file = "StrataG_fst_perm_results.txt", sep = "\t")


