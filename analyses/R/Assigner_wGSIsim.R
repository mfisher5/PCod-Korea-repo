#### -------------- ASSIGNER with GSIsim --------------####
#
# Use for PCod, Korea dataset
# MF 10/30/2017
#
# https://github.com/thierrygosselin/assigner
# https://github.com/eriqande/gsi_sim 
#
#
###############################################################################

# --------------------------- Installation -----------------------------#
##-- Dependencies
if (!require("reshape2")) install.packages("reshape2")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("stringr")) install.packages("stringr")
if (!require("stringi")) install.packages("stringi")
if (!require("stackr")) install.packages("stackr")
if (!require("plyr")) install.packages("plyr")
if (!require("dplyr")) install.packages("dplyr")
if (!require("tidyr")) install.packages("tidyr")
if (!require("readr")) install.packages("readr")
if (!require("purrr")) install.packages("purrr")
if (!require("data.table")) install.packages("data.table")
if (!require("lazyeval")) install.packages("lazyeval")
if (!require("adegenet")) install.packages("adegenet")
if (!require("parallel")) install.packages("parallel")



##-- Install the assigner package (according to theirrygosselin/assigner)
# if (!require("devtools")) install.packages("devtools") # to install
# devtools::install_github("thierrygosselin/assigner", build_vignettes = TRUE)  # to install WITH vignettes
# assigner::install_gsi_sim(fromSource = TRUE) # to install gsi_sim from source
# library(assigner)

##-- Install the assigner package (what actually worked)
install.packages("devtools")
library(devtools)
install.packages("NMF")
# install.packages("igraph") <- latest version (1.1.1) didn't work. 
#    manually downloaded the latest "stable" version 1.0.1 from https://cloud.r-project.org/ src/contrib/Archive/igraph
#    also see: https://github.com/igraph/rigraph/issues/191
install_github("thierrygosselin/assigner") # to install
library(assigner) # to load




##-- Install gsi-sim OPTION 1: if you have git installed
install_gsi_sim(fromSource = TRUE)
# switch to command line and navigate into the assigner directory: 

#$ cd /home/mfisher5/R/x86_64-pc-linux-gnu-library/3.4/assigner        #navigate to assigner in R folders
#$ cp bin/gsi_sim ./gsi_sim        #copy the gsi_sim folder into the assigner folder
#$ rm bin/gsi_sim                  #remove the gsi_sim folder from the assigner *bin* directory
#$ cp gsi_sim/gsi_sim-Linux bin/gsi_sim          #copy the gsi_sim-Linux executable into the assigner *bin* directory
#$ rm gsi_sim                      #remove the gsi_sim folder from assigner directory


##-- Install gsi-sim OPTION 2: if you do not have git installed
# go to command line of git bash terminal in your windows desktop:

#$ cd ~/PCod-Korea/analyses     #or any directory THAT IS SHARED WITH YOUR VIRTUAL MACHINE
#$ sudo git clone https://github.com/eriqande/gsi_sim.git
#$ cd gsi_sim/
#$ sudo git submodule init
#$ sudo git submodule update

# moving over to your virtual machine...
#$ sudo cp ~/mnt/hgfs/PCod-Korea-repo/analyses/gsi_sim/gsi_sim-Linux /usr/local/bin/gsi_sim





##-- Load all necesary libraries after installation:
library(devtools)
library(assigner)
library(stackr) # THIS DID NOT LOAD IN R
library(reshape2)
library(ggplot2)
library(stringr)
library(stringi)
library(plyr)
library(dplyr) # load this package after plyr to work properly
library(tidyr)
library(readr)
library(adegenet)
library(randomForestSRC)
library(doParallel)
library(foreach)
library(purrr)
library(utils)
library(iterators)

############################################################################

# ------------------- Assignment Test: THL (Training, Hold-out, Leave One Out) Method w/ assignment_ngs ALL 9 POPULATIONS ---------------------- #
#
##-- set working directory
setwd("/mnt/hgfs/PCod-Korea-repo/analyses")

##-- load in genepop file
all_9pops <- read.genepop("../stacks_b8_wgenome/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredRepsC.gen")
summary(all_9pops)

##-- load help file
?assignment_ngs

##-- if you want to, you can identify population levels
pop_groups <- c("POH15","GE15","NAM15","YS16","JUK","JBE","JBL","BOR07","GE14") # each pop is its own pop
#pop_groups <- c("SOUTH","SOUTH","SOUTH","WEST","EAST","SOUTH","SOUTH","WEST","SOUTH") # each pop is part of a region

##-- run assigner: ngs
system.time(assign.all.9pops <- assignment_ngs(data = all_9pops, 
                                               assignment.analysis = "gsi_sim", 
                                               sampling.method = "ranked",
                                               thl = 0.5, 
                                               iteration.method = 10,      #default = 10
                                               subsample = NULL,           #randomly select X individs from each pop to use for entire simulation (can be used to smooth out sample sizes)
                                               iteration.subsample = 1,    #default = 1
                                               marker.number = c(10,50,100,200,500,1000,2000,5000,"all"),
                                               common.markers = TRUE,
                                               #pop.levels = NULL,          #default = NULL, alphabetical / numerical. ordering of pops
                                               #pop.levels = NULL,          #default = NULL. to rename or combine your pops
                                               #pop.select = NULL,          #default = NULL. to select a subset of pops
                                               verbose = TRUE,             #default = false. get more info when f(x) is running
                                               folder = "all_9pops_thl0-5", 
                                               filename = "assignment_all_9pops_thl0-5.txt",
                                               keep.gsi.files = TRUE,
                                               random.seed= NULL, 
                                               parallel.core = 5))

##-- Visualize results 
# from https://github.com/laurabenestan/Lobster-assigner/wiki/ASSIGNER-tutorial-for-Benestan-et-al.-(2015)

# load in and transform data
data <- read.table("Assignment/all_9pops_thl0-5/assignment.ranked.no.imputation.results.summary.stats.tsv", header=TRUE, sep="\t",stringsAsFactors=F)
data$MARKER_NUMBER <- as.character(data$MARKER_NUMBER)
neworder <- c("YS_121316_07", "BOR07_21_2", "NA021015_30", "GE011215_11", "GEO020414_30_2", "JB121807_29", "JB021108_11_rep", "PO010715_07_rep", "JUK07_33", "Overall")
data <- arrange(transform(data,
                          CURRENT=factor(CURRENT,levels=neworder)),CURRENT)

# ggplot
install.packages("ggplot2")
library(ggplot2)

plot <- ggplot(data, aes(x=MARKER_NUMBER,y=MEAN))+
  geom_boxplot(aes(fill=CURRENT))+
  stat_summary(fun.y=mean, geom="point", shape=5, size=3,color="black")+
  scale_x_discrete(limits=c("10","50","100","200","500","1000","2000","5000","5405"))
x_title="Number of loci"
y_title="Assignment success (%)"
plot + facet_grid(~CURRENT)+
  facet_wrap(~CURRENT, nrow=4,ncol=3)+
  labs(x=x_title)+
  labs(y=y_title)+
  guides(fill= FALSE, size= FALSE)+
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(colour="black", linetype="dashed"),
        axis.title.x=element_text(size=14, family="Helvetica",face="bold"),
        axis.text.x=element_text(size=14,family="Helvetica",face="bold", angle=90, hjust=0, vjust=0.5),
        axis.title.y=element_text(size=14, family="Helvetica",face="bold"),
        axis.text.y=element_text(size=14,family="Helvetica",face="bold"))
ggsave("Assignment_pop_THL0-5_col_9pops.pdf",width=20,height=25,dpi=300,units="cm",useDingbats=F)
dev.off()




# ------------------- Assignment Test: THL (Training, Hold-out, Leave One Out) Method w/ assignment_ngs BY REGION---------------------- #
# ------------------- using the same genepop as above, with different pop.labels and pop.levels arguments ----------------------------- #
##-- set working directory
setwd("/mnt/hgfs/PCod-Korea-repo/analyses")

##-- load in genepop file
all_9pops <- read.genepop("../stacks_b8_wgenome/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredRepsC.gen")
summary(all_9pops)



##-- if you want to, you can identify population levels
pop_groups <- c("POH15","GE15","NAM15","YS16","JUK","JBE","JBL","BOR07","GE14") # each pop is its own pop
pop_regions <- c("SOUTH","SOUTH","SOUTH","WEST","EAST","SOUTH","SOUTH","WEST","SOUTH") # each pop is part of a region

##-- run assigner: ngs
system.time(assign.all.byregion <- assignment_ngs(data = all_9pops, 
                                               assignment.analysis = "gsi_sim", 
                                               sampling.method = "ranked",
                                               thl = 0.5, 
                                               iteration.method = 10,      #default = 10
                                               subsample = NULL,           #randomly select X individs from each pop to use for entire simulation (can be used to smooth out sample sizes)
                                               iteration.subsample = 1,    #default = 1
                                               marker.number = c(10,50,100,200,500,1000,2000,5000,"all"),
                                               common.markers = TRUE,
                                               pop.levels = pop_groups,          #default = NULL, alphabetical / numerical. ordering of pops
                                               pop.labels = pop_regions,          #default = NULL. to rename or combine your pops
                                               #pop.select = NULL,          #default = NULL. to select a subset of pops
                                               verbose = TRUE,             #default = false. get more info when f(x) is running
                                               folder = "all_byregion_thl0-5", 
                                               filename = "assignment_all_byregion_thl0-5.txt",
                                               keep.gsi.files = TRUE,
                                               random.seed= NULL, 
                                               parallel.core = 5))


#Error in radiator::change_pop_names(data = input, pop.levels = unique(pop.labels),  : 
#                                      The number of groups in your input file doesn't match the number of groups in pop.levels





# ------------------- Assignment Test: THL (Training, Hold-out, Leave One Out) Method w/ assignment_ngs BY REGION---------------------- #
# ------------------- using by region genepop ----------------------------------------------------------------------------------------- #
##-- set working directory
setwd("/mnt/hgfs/PCod-Korea-repo/analyses")

##-- load in genepop file
all_3region <- read.genepop("../stacks_b8_wgenome/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredRepsC_region.gen")
summary(all_3region)


##-- if you want to, you can identify population levels
pop_groups <- c("POH15","GE15","NAM15","YS16","JUK","JBE","JBL","BOR07","GE14") # each pop is its own pop
pop_regions <- c("SOUTH","SOUTH","SOUTH","WEST","EAST","SOUTH","SOUTH","WEST","SOUTH") # each pop is part of a region

##-- run assigner: ngs
system.time(assign.all.byregion <- assignment_ngs(data = all_3region, 
                                                  assignment.analysis = "gsi_sim", 
                                                  sampling.method = "ranked",
                                                  thl = 0.5, 
                                                  iteration.method = 10,      #default = 10
                                                  subsample = NULL,           #randomly select X individs from each pop to use for entire simulation (can be used to smooth out sample sizes)
                                                  iteration.subsample = 1,    #default = 1
                                                  marker.number = c(10,50,100,200,500,1000,2000,5000,"all"),
                                                  common.markers = TRUE,
                                                  #pop.levels = pop_groups,          #default = NULL, alphabetical / numerical. ordering of pops
                                                  #pop.labels = pop_regions,          #default = NULL. to rename or combine your pops
                                                  #pop.select = NULL,          #default = NULL. to select a subset of pops
                                                  verbose = TRUE,             #default = false. get more info when f(x) is running
                                                  folder = "all_byregion_thl0-5", 
                                                  filename = "assignment_all_byregion_thl0-5.txt",
                                                  keep.gsi.files = TRUE,
                                                  random.seed= NULL, 
                                                  parallel.core = 5))


##-- Visualize results 
# from https://github.com/laurabenestan/Lobster-assigner/wiki/ASSIGNER-tutorial-for-Benestan-et-al.-(2015)

# load in and transform data
regdata <- read.table("Assignment/all_byregion_thl0-5/assignment.ranked.no.imputation.results.summary.stats.tsv", header=TRUE, sep="\t",stringsAsFactors=F)
regdata$MARKER_NUMBER <- as.character(regdata$MARKER_NUMBER)
neworder <- c("BOR07_21_2", "GEO020414_30_2", "JUK07_33", "OVERALL")
regdata <- arrange(transform(regdata,
                          CURRENT=factor(CURRENT,levels=neworder)),CURRENT)
View(regdata)
regdata_partial=regdata[1:27,]
View(regdata_partial)


# ggplot
install.packages("ggplot2")
library(ggplot2)

# plot regions
plot <- ggplot(regdata_partial, aes(x=MARKER_NUMBER,y=MEAN))+
  geom_point()+
  geom_errorbar(aes(ymin=MEAN-SE, ymax = MEAN+SE))+
  scale_x_discrete(limits=c("10","50","100","200","500","1000","2000","5000","5405"))
x_title="Number of loci"
y_title="Assignment success (%)"
plot + facet_grid(~CURRENT)+
  facet_wrap(~CURRENT, nrow=2,ncol=3)+
  labs(x=x_title)+
  labs(y=y_title)+
  guides(fill= FALSE, size= FALSE)+
  coord_cartesian(ylim=c(0,100))+
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(colour="black", linetype="dashed"),
        axis.title.x=element_text(size=20, family="Helvetica",face="bold"),
        axis.text.x=element_text(size=18,family="Helvetica",face="bold", angle=90, hjust=0, vjust=0.5),
        axis.title.y=element_text(size=20, family="Helvetica",face="bold"),
        axis.text.y=element_text(size=18,family="Helvetica",face="bold"))
ggsave("Assignment_byregion_THL0-5_col.pdf",width=20,height=25,dpi=300,units="cm",useDingbats=F)
dev.off()

scale_y_discrete(limits=c("0","10","20", "30","40","50","60","70","80","90","100"))

# plot overall
regdata_overall=regdata[28:36,]

plot <- ggplot(regdata_overall, aes(x=MARKER_NUMBER,y=MEAN))+
  geom_point()+
  geom_errorbar(aes(ymin=MEAN-SE, ymax = MEAN+SE))+
  scale_x_discrete(limits=c("10","50","100","200","500","1000","2000","5000","5405"))
x_title="Number of loci"
y_title="Assignment success (%)"
plot + labs(x=x_title)+
  labs(y=y_title)+
  labs(title="Overall Assignment")+
  guides(fill= FALSE, size= FALSE)+
  coord_cartesian(ylim=c(0,100))+
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(colour="black", linetype="dashed"),
        plot.title=element_text(family= "Helvetica", face = "bold", hjust=0.5, size=20),
        axis.title.x=element_text(size=20, family="Helvetica",face="bold"),
        axis.text.x=element_text(size=18,family="Helvetica",face="bold", angle=90, hjust=0, vjust=0.5),
        axis.title.y=element_text(size=20, family="Helvetica",face="bold"),
        axis.text.y=element_text(size=18,family="Helvetica",face="bold"))
ggsave("Assignment_byregion_THL0-5_col_overall.pdf",width=20,height=25,dpi=300,units="cm",useDingbats=F)
dev.off()
