#### -------------- ASSIGNER with GSIsim --------------####
#
# Use for PCod, Korea dataset
# MF 10/30/2017;; updated 4/13/2018 to reflect github issue:
#
# https://github.com/thierrygosselin/assigner
# https://github.com/eriqande/gsi_sim 
#
#
###############################################################################



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


##-- For visualization of results, load the following packages
library(reshape2)
library(ggplot2)
library(plyr)
library(dplyr) # load this package after plyr to work properly
library(tidyr)
library(readr)





# ------------------- Assignment Test: THL (Training, Hold-out, Leave One Out) Method w/ assignment_ngs ---------------------- #
#
##-- set working directory
setwd("/mnt/hgfs/PCod-Korea-repo/analyses/Assignment")


gen.file <-"../../stacks_b8_verif/batch_8_filteredMAF_filteredIndivids30_filteredLoci_filteredHWE_filteredCR_byreg_nomigrants10.gen"
strata.file <- "verif_Strata_byreg_nomigrants.txt"

system.time(
  assign.all.byreg.nomig <- assigner::assignment_ngs(
    data = gen.file,
    strata = strata.file,
    assignment.analysis = "gsi_sim", 
    sampling.method = "ranked",
    thl = 0.5, iteration.method = 10, #default = 10
    subsample = NULL,                 #randomly select X individs from each pop to use for entire simulation (can be used to smooth out sample sizes)
    iteration.subsample = 1,          #default = 1
    # marker.number = 5000, # first test
    marker.number = c(10,50,100,200,500,1000,2000,5000,"all"),
    common.markers = TRUE,
    verbose = TRUE,                    #default = false. get more info when f(x) is running
    folder = "verif_byreg_nomig4-18_thl0-5", 
    filename = "assignment_all_byreg_nomig4-18_thl0-5.txt",
    keep.gsi.files = TRUE,
    random.seed= NULL, 
    parallel.core = 4))





# --------------------------------------------- Visualize Results ------------------------------------------------------ #
# from https://github.com/laurabenestan/Lobster-assigner/wiki/ASSIGNER-tutorial-for-Benestan-et-al.-(2015)

## By Region ##
# load in and transform data
regdata <- read.table("verif_byreg_nomig_thl0-5/assignment.ranked.no.imputation.results.summary.stats.subsample.tsv", header=TRUE, sep="\t",stringsAsFactors=F)
regdata$MARKER_NUMBER <- as.character(regdata$MARKER_NUMBER)
regdata <- filter(regdata, MARKER_NUMBER %in% c("10","50","100","200","500","1000","5801"))

regdata$CURRENT <- as.character(regdata$CURRENT)
regdata$CURRENT[regdata$CURRENT == "OVERALL"] <- "Overall"
regdata$CURRENT <- as.factor(regdata$CURRENT)

neworder <- c("West", "South", "East", "Overall")
regdata <- arrange(transform(regdata,
                             CURRENT=factor(CURRENT,levels=neworder)),CURRENT)

View(regdata)

# plot
scaleFUN <- function(x){
  y = x / 100
  sprintf("%.2f", y)
}

plot <- ggplot(regdata, aes(x=MARKER_NUMBER,ymin=MIN,lower=QUANTILE25,middle=MEDIAN,upper=QUANTILE75,ymax=MAX))+
  geom_boxplot(stat="identity", aes(fill = CURRENT))+
  scale_x_discrete(limits=c("10","50","100","200","500","1000","5801")) +
  scale_y_continuous(breaks = c(25, 50, 75, 100), labels=scaleFUN) +
  scale_fill_manual(values=c("firebrick4","deepskyblue4", "chartreuse", "gray"))
x_title="Number of loci"
y_title="Assignment success (Proportion)"
plot + facet_grid(~CURRENT)+
  facet_wrap(~CURRENT, nrow=1,ncol=4)+
  labs(x=x_title)+
  labs(y=y_title)+
  guides(fill= FALSE, size= FALSE)+
  coord_cartesian(ylim=c(15,100))+
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.background = element_rect(fill="white"),
        axis.title.x=element_text(size=18, family="Helvetica",face="bold"),
        axis.text.x=element_text(size=14,family="Helvetica", angle=90, hjust=0, vjust=0.5,face="bold"),
        axis.title.y=element_text(size=18, family="Helvetica",face="bold"),
        axis.text.y=element_text(size=14,family="Helvetica",face="bold"),
        strip.text=element_text(size=16,face="bold"))
ggsave("Assignment_byregion_THL0-5_forFSBI.png",width=20,height=15,dpi=300,units="cm")
dev.off()

scale_y_discrete(limits=c("0","10","20", "30","40","50","60","70","80","90","100"))



## By Site ##
# load in and transform data
regdata <- read.table("verif_9pops_thl0-5/assignment.ranked.no.imputation.results.summary.stats.tsv", header=TRUE, sep="\t",stringsAsFactors=F)
regdata$MARKER_NUMBER <- as.character(regdata$MARKER_NUMBER)
View(regdata)
# rename populations for plotting
regdata$CURRENT <- gsub("YellowSea", "YS Block", regdata$CURRENT)
regdata$CURRENT <- gsub("Geoje_2014-15", "Geoje, 2014-15", regdata$CURRENT)
regdata$CURRENT <- gsub("Geoje_2013-14", "Geoje, 2013-14", regdata$CURRENT)
regdata$CURRENT <- gsub("JinhaeBay_Dec", "Jinhae Bay, Dec.", regdata$CURRENT)
regdata$CURRENT <- gsub("JinhaeBay_Feb", "Jinhae Bay, Feb.", regdata$CURRENT)
View(regdata)

# rearrange order 
neworder <- c("YS Block", "Boryeong", "Jukbyeon","OVERALL","Geoje, 2014-15", "Geoje, 2013-14", "Namhae", "Jinhae Bay, Dec.", "Jinhae Bay, Feb.", "Pohang")
regdata <- arrange(transform(regdata,
                             CURRENT=factor(CURRENT,levels=neworder)),CURRENT)
View(regdata)

# plot populations
regdata_pops <- filter(regdata, CURRENT != "OVERALL")
plot <- ggplot(regdata_pops, aes(x=MARKER_NUMBER,y=MEAN))+
  geom_point()+
  geom_errorbar(aes(ymin=MEAN-SE, ymax = MEAN+SE))+
  scale_x_discrete(limits=c("10","50","100","200","500","1000","2000","5000","5804"))
x_title="Number of loci"
y_title="Assignment success (%)"
png("Assignment_bysite_sites_thl0-5_adj_names.png", width=720, height = 960)
plot + facet_grid(~CURRENT)+
  facet_wrap(~CURRENT, nrow=3,ncol=3)+
  labs(x=x_title)+
  labs(y=y_title)+
  guides(fill= FALSE, size= FALSE)+
  coord_cartesian(ylim=c(0,100))+
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(colour="black", linetype="dashed"),
        axis.title.x=element_text(size=18, family="Helvetica",face="bold"),
        axis.text.x=element_text(size=16,family="Helvetica",face="bold", angle=90, hjust=0, vjust=0.5),
        axis.title.y=element_text(size=18, family="Helvetica",face="bold"),
        axis.text.y=element_text(size=16,family="Helvetica",face="bold"),
        strip.text=element_text(size=14))
#ggsave("Assignment_bysite_sites_THL0-5.pdf",width=20,height=30,dpi=300,units="cm",useDingbats=F)
dev.off()

# plot overall
regdata_overall <- filter(regdata, CURRENT == "OVERALL")
plot <- ggplot(regdata_overall, aes(x=MARKER_NUMBER,y=MEAN))+
  geom_point()+
  geom_errorbar(aes(ymin=MEAN-SE, ymax = MEAN+SE))+
  scale_x_discrete(limits=c("10","50","100","200","500","1000","2000","5000","5804"))
x_title="Number of loci"
y_title="Assignment success (%)"
plot + facet_grid(~CURRENT)+
  facet_wrap(~CURRENT, nrow=1,ncol=3)+
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
        axis.text.y=element_text(size=18,family="Helvetica",face="bold"),
        strip.text=element_text(size=18))





