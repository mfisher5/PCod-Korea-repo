############################# Overlay Genetic Assignment on NMDS #####################
#
# MF 3/2/2018
# SEFS 502 Final Project
#
##############################################################################################################

## set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/otolith_analyses")



# Load genetic data -------------------------------------------------------
structure <- read.csv("data/PCod_Korea_Structure_assignment.txt", header=TRUE, sep="\t")


# Manipulate data frames --------------------------------------------------
## need to make sure only keep genetic data for samples that were filtered through analyses
gendata <- left_join(x=odata_combo, y=structure)



# Create gen assignment vector --------------------------------------------------
gen_list <- c()
# if western assignment is greater than 0.10; classify as western sample. otherwise, classify as southern sample
for(i in gendata$Cluster1){
  if(i > 0.25){
    gen_list <- c(gen_list,1)
  } else {gen_list <- c(gen_list,2)}
}
length(gendata$Cluster1)
length(gen_list)

gendata <- mutate(gendata, Assign=gen_list)
View(gendata)



# Plot Genetic Data over NMDS Edge ---------------------------------------------------
## k = 3, for best visualization
odata_edge.nmds3 <- metaMDS(comm = edge.mrel_dist, autotransform = FALSE,
                            distance = "euc", engine = "monoMDS", k = 3, weakties = TRUE,
                            model = "global", maxit = 400, try = 40, trymax = 200,
                            wascores = TRUE)
## plot
plot(odata_edge.nmds3, xaxt = "n", yaxt = "n", xlab = "", ylab = "", type="n",
     main = "NMDS of Edge\nwith Genetic Assignment")

## add ordihull for genetic clusters
ordispider(odata_edge.nmds3, gendata$Assign, col=c("#8dd3c7","gold2"), draw = "polygon")


points(odata_edge.nmds3$points[odata_combo$SiteYear == "Pohang_2015" & gendata$Assign==1,], 
       pch = 17, col = "#b3de69", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "Pohang_2015" & gendata$Assign==2,], 
       pch = 1, col = "#b3de69", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "Geoje_2015"& gendata$Assign==1,], 
       pch = 17, col = "gold2", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "Geoje_2015"& gendata$Assign==2,], 
       pch = 1, col = "gold2", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "Namhae_2015" & gendata$Assign==1,], 
       pch = 17, col = "#bebada", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "Namhae_2015" & gendata$Assign==2,], 
       pch = 1, col = "#bebada", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "YSBlock_2016" & gendata$Assign==1,], 
       pch = 17, col = "#fb8072", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "JinhaeBay_2007" & gendata$Assign==2,], 
       pch = 1, col = "#8dd3c7", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "JinhaeBay_2008" & gendata$Assign==1,], 
       pch = 17, col = "#80b1d3", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "JinhaeBay_2008" & gendata$Assign==2,], 
       pch = 1, col = "#80b1d3", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "Geoje_2014" & gendata$Assign==1,], 
       pch = 17, col = "darkorange", cex = 1.2)
points(odata_edge.nmds3$points[odata_combo$SiteYear == "Geoje_2014" & gendata$Assign==2,], 
       pch = 1, col = "darkorange", cex = 1.2)
## add legend
legend(x="bottomright", pch = c(19,19,19,19,19,19,19,17,1), cex = 1, pt.cex = 1.2,
       col = c("#fb8072", "#bebada", "darkorange", "gold2", "#8dd3c7", "#80b1d3", "#b3de69", "darkgrey", "darkgrey"), 
       legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "JinhaeBay '07e", "JinhaeBay '07l", "Pohang '15","West", "South"), 
       title = "Sampling Site")








# Plot Genetic Data over NMDS Core ----------------------------------------
## k = 3, for best visualization
odata_core.nmds3 <- metaMDS(comm = core.mrel_dist, autotransform = FALSE,
                            distance = "euc", engine = "monoMDS", k = 3, weakties = TRUE,
                            model = "global", maxit = 400, try = 40, trymax = 200,
                            wascores = TRUE)
## plot
plot(odata_core.nmds3, xaxt = "n", yaxt = "n", xlab = "", ylab = "", type="n",
     main = "NMDS of Core\nwith Genetic Assignment")


points(odata_core.nmds3$points[odata_combo$SiteYear == "Pohang_2015" & gendata$Assign==1,], 
       pch = 17, col = "#b3de69", cex = 1.2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "Pohang_2015" & gendata$Assign==2,], 
       pch = 1, col = "#b3de69", cex = 1.2, lwd = 2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "Geoje_2015"& gendata$Assign==1,], 
       pch = 17, col = "gold2", cex = 1.2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "Geoje_2015"& gendata$Assign==2,], 
       pch = 1, col = "gold2", cex = 1.2, lwd = 2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "Namhae_2015" & gendata$Assign==1,], 
       pch = 17, col = "#bebada", cex = 1.2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "Namhae_2015" & gendata$Assign==2,], 
       pch = 1, col = "#bebada", cex = 1.2, lwd = 2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "YSBlock_2016" & gendata$Assign==1,], 
       pch = 17, col = "#fb8072", cex = 1.2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "JinhaeBay_2007" & gendata$Assign==2,], 
       pch = 1, col = "#8dd3c7", cex = 1.2, lwd = 2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "JinhaeBay_2008" & gendata$Assign==1,], 
       pch = 17, col = "#80b1d3", cex = 1.2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "JinhaeBay_2008" & gendata$Assign==2,], 
       pch = 1, col = "#80b1d3", cex = 1.2, lwd = 2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "Geoje_2014" & gendata$Assign==1,], 
       pch = 17, col = "darkorange", cex = 1.2)
points(odata_core.nmds3$points[odata_combo$SiteYear == "Geoje_2014" & gendata$Assign==2,], 
       pch = 1, col = "darkorange", cex = 1.2, lwd = 2)
## add legend
legend(x="bottomleft", pch = c(19,19,19,19,19,19,19,17,1), cex = 1, pt.cex = 1.2,
       col = c("#fb8072", "#bebada", "darkorange", "gold2", "#8dd3c7", "#80b1d3", "#b3de69", "darkgrey", "darkgrey"), 
       legend = c("YSBlock '16", "Namhae '15", "Geoje '14", "Geoje '15", "JinhaeBay '07e", "JinhaeBay '07l", "Pohang '15","West", "South"), 
       title = "Sampling Site")


