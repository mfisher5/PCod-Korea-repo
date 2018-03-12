############# Produce tanglegram to compare two cluster dendrograms #################
#
# MF 3/2/2018
# SEFS Final Project
#
####################################################################################

## set working directory
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/otolith_analyses")

# Load packages -----------------------------------------------------------
install.packages("vegan")
install.packages("dplyr")
install.packages("colorspace")
install.packages("ggplot2")
library(vegan)
library(ggplot2)
library(dendextend)
library(colorspace)
library(dplyr)


# Clustering  -------------------------------------
core.hclust <- hclust(d = core.mrel_dist, method = "ward.D2")
edge.hclust <- hclust(d = edge.mrel_dist, method = "ward.D2")



# Create Dendrograms ------------------------------------------------------
odata_dendlist <- dendlist(as.dendrogram(edge.hclust), as.dendrogram(core.hclust))
names(odata_dendlist) <- c("edge", "core")
dend_edge <- as.dendrogram(edge.hclust)



# Create Tanglegram -------------------------------------------------------
## without coloring inner lines
odata_dendlist %>% dendlist(which = c(1,2)) %>% ladderize %>% 
  set("branches_k_color", k=3) %>% 
  tanglegram(faster = TRUE)

## with color on inner lines, all
sites_ordered <- as.character(as.factor(odata_combo$Sampling.Site))[order.dendrogram(dend_edge)]
color_vec <- c()
for(i in sites_ordered){
  if( i == "Pohang"){
    color_vec <- c(color_vec, "#b3de69")
  } else if ( i == "Geoje"){
    color_vec <- c(color_vec, "gold2")
  } else if ( i == "Namhae"){
    color_vec <- c(color_vec, "#bebada")
  } else if ( i == "YSBlock"){
    color_vec <- c(color_vec, "#fb8072")
  } else if ( i == "JinhaeBay"){
    color_vec <- c(color_vec, "#8dd3c7")
  } 
}
color_vec
odata_dendlist %>% dendlist(which = c(1,2)) %>%
  tanglegram(faster = TRUE, color_lines=color_vec) # (common_subtrees_color_branches = TRUE)

## with color on inner lines, Jinhae Bay
siteyear_ordered <- as.character(as.factor(odata_combo$SiteYear))[order.dendrogram(dend_edge)]
color_vec_jb <- c()
for(i in siteyear_ordered){
  if( i == "JinhaeBay_2007"){
    color_vec_jb <- c(color_vec_jb, "#8dd3c7")
  } else if ( i == "JinhaeBay_2008"){
    color_vec_jb <- c(color_vec_jb, "#80b1d3")
  }  else {
    color_vec_jb <- c(color_vec_jb, "gray95")
  } 
}
color_vec_jb
odata_dendlist %>% dendlist(which = c(1,2)) %>%
  tanglegram(faster = TRUE, color_lines=color_vec_jb) # (common_subtrees_color_branches = TRUE)

## with color on inner lines, Yellow Sea
sites_ordered <- as.character(as.factor(odata_combo$Sampling.Site))[order.dendrogram(dend_edge)]
color_vec_ys <- c()
for(i in sites_ordered){
  if( i == "YSBlock"){
    color_vec_ys <- c(color_vec_ys, "#fb8072")
  } else {
    color_vec_ys <- c(color_vec_ys, "gray94")
  } 
}
odata_dendlist %>% dendlist(which = c(1,2)) %>% ladderize %>%
  tanglegram(faster = TRUE, color_lines=color_vec_ys) # (common_subtrees_color_branches = TRUE)


## with color on inner lines, Pohang
sites_ordered <- as.character(as.factor(odata_combo$Sampling.Site))[order.dendrogram(dend_edge)]
color_vec_po <- c()
for(i in sites_ordered){
  if( i == "Pohang"){
    color_vec_po <- c(color_vec_po, "#b3de69")
  } else {
    color_vec_po <- c(color_vec_po, "gray94")
  } 
}
odata_dendlist %>% dendlist(which = c(1,2)) %>%
  tanglegram(faster = TRUE, color_lines=color_vec_po) # (common_subtrees_color_branches = TRUE)


## with color on inner lines, Geoje
sites_ordered <- as.character(as.factor(odata_combo$Sampling.Site))[order.dendrogram(dend_edge)]
color_vec_ge <- c()
for(i in siteyear_ordered){
  if( i == "Geoje_2014"){
    color_vec_ge <- c(color_vec_ge, "darkorange")
  } else if ( i == "Geoje_2015"){
    color_vec_ge <- c(color_vec_ge, "gold2")
  }  else {
    color_vec_ge <- c(color_vec_ge, "gray94")
  } 
}
odata_dendlist %>% dendlist(which = c(1,2)) %>% ladderize %>%
  tanglegram(faster = TRUE, color_lines=color_vec_ge) # (common_subtrees_color_branches = TRUE)
