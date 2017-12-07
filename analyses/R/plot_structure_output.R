

## load in data ##

library(readr)
sdata_raw <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/results/Structure_3pops_50K100K_arr.txt", "\t", escape_double = FALSE, trim_ws = TRUE)
View(sdata_raw)

## transform the data for ggplot ##

# create list of sample names, each repeated 3x
sampleIDs <- sdata_raw$ID
sample_col = c()
for(sample in sampleIDs){
  sample_col <- c(sample_col, rep(sample,3))
}
head(sample_col)

# create list of clustering proportions, in order from cluster 1 --> 3 
cluster_col <- c()
for(i in seq(1,length(sampleIDs))){
  new_clusters <- c(sdata_raw$`Cluster 1`[i], sdata_raw$`Cluster 2`[i], sdata_raw$`Cluster 3`[i])
  cluster_col <- c(cluster_col, new_clusters)
}
head(cluster_col)

# create list of cluster numbers
cnum_col <- rep(c(1,2,3),length(sampleIDs))

# combine in dataframe
sdata_frame <- data.frame(sample_col, cnum_col, cluster_col)
head(sdata_frame)
View(sdata_frame)



## load ggplot2 ##
install.packages("ggplot2")
install.packages("ggthemes")
library(ggplot2)
library(ggthemes)


## plot ##

g <- ggplot() + geom_col(aes(y = cluster_col, x = sample_col, fill = as.factor(cnum_col)), data = sdata_frame, position = "stack") + 
  xlab("Sample") + 
  ylab("Population Membership") +
  scale_fill_manual(values=c("firebrick4", "deepskyblue2", "chartreuse"), name = "Populations", labels = c("West", "South", "East")) +
  theme(axis.text.y=element_text(size = 16), axis.title.y = element_text(size = 22, face = "bold"), axis.text.x = element_blank(), axis.title.x = element_text(size = 22, face = "bold"), axis.ticks.x = element_blank()) + 
  theme(legend.title=element_text(size = 16, face="bold"), legend.text=element_text(size = 16, face = "bold"))
g





values=c("firebrick4", "deepskyblue4", "chartreuse")








### troubleshooting

sdata_frame_sub <- sdata_frame[1:179,]
View(sdata_frame_sub)


g <- ggplot() + geom_col(aes(y = cluster_col, x = sample_col, fill = as.factor(cnum_col)), data = sdata_frame_sub, position = "stack") + 
  xlab("Sample") + 
  ylab("Population Membership") +
  scale_fill_manual(values=c("firebrick4", "deepskyblue2", "chartreuse"), name = "Populations") +
  theme(axis.text.y=element_text(size = 16), axis.title.y = element_text(size = 22, face = "bold"), axis.text.x = element_text(angle=90), axis.title.x = element_text(size = 22, face = "bold"), axis.ticks.x = element_blank()) + 
  theme(legend.title=element_text(size = 16, face="bold"), legend.text=element_text(size = 16, face = "bold"))
g



