

setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses")
source("BAYESCAN_plot_R.r")

setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses/Outliers")


# produce a list of outlier loci, and a plot of fst v. log10(qvalue)
plot_bayescan("batch_8_BAYESCAN_output_fst.txt", FDR = 0.05)



# produce a plot of posterior distribution of any parameter
mydata = read.table("batch_8_BAYESCAN_output.sel", colClasses = "numeric")
parameter = "Fst1"
plot(density(mydata[[parameter]]), xlab=parameter, main=paste(parameter,"posterior distribution"))
