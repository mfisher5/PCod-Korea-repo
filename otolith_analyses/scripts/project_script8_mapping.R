############# Create Map of Sampling Site ##################
#
# MF 3/10/3018
# SEFS Final Project
#
############################################################



# Libraries
install.packages("tidyverse")
install.packages("maps")
install.packages("maptools")
install.packages("ggrepel")
install.packages("viridis")
install.packages("ggplot2")
install.packages("pals")
install.packages("grid")
install.packages("dplyr")
library(tidyverse)
library(maps)
library(maptools)
library(ggrepel)
library(viridis)
library(ggplot2)
library(pals)
library(grid)
library(dplyr)



# Get the world polygon and extract USA and Canada
SK <- map_data("world") %>% 
  filter(region=="South Korea")
NK <- map_data("world") %>% 
  filter(region=="North Korea")
View(map_data("world"))


# Create data frame with just lat / long
location_data <- odata_combo %>%
  select(Sampling.Site, Approx.Lat, Approx.Long) %>%
  distinct(Sampling.Site, Approx.Lat, Approx.Long)

colnames(location_data) <- c("Site", "latitude", "longitude")
location_data

# source mapping functions
source("scripts/mapping_functions.r")


# set the breaks for your color ramp
mybreaks=c(0, 30, 60, 90, 120, 150, 180)


# Make the first map
color_vec <- c("darkorange", "#8dd3c7", "#bebada", "#b3de69", "#fb8072")
ggplot() +
  geom_polygon(data = SK, aes(x=long, y = lat, group = group), fill="springgreen4", alpha=0.7) +
  geom_polygon(data = NK, aes(x=long, y = lat, group = group), fill=" grey37", alpha=0.3) +
  geom_point(data=location_data, aes(x=longitude, y=latitude, color=Site), size = 7, alpha = 1) +
  scale_color_manual(values=color_vec) +
  theme(panel.background = element_rect(fill = "slategray1"), 
        panel.grid.major = element_line(colour = NA),
        legend.text=element_text(size=12),
        legend.title=element_text(size=12)) +
  labs(x = "Longitude", y = "Latitude") +
  coord_map(ylim = c(33,39))


  


  
####### extra ggplot code ########
# order legend geographically
leg_labels <- c("Yellow Sea", "Namhae", "Geoje", "JinhaeBay", "Pohang")
color_vec_ordered <- c("#fb8072", "#bebada", "darkorange", "#8dd3c7", "#b3de69")
scale_fill_discrete(values = color_vec_ordered, name="Sampling Site", breaks=c("YSBlock", "Namhae", "Geoje", "JinhaeBay", "Pohang"), labels = leg_labels)

  
####### leaflet map #########
install.packages("leaflet")
library(leaflet)

leaflet() %>% 
  addTiles() %>% 
  setView( lng = 2.34, lat = 48.85, zoom = 3 ) %>% 
  addProviderTiles("Esri.WorldImagery")

leaflet(data = location_data) %>% addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addCircleMarkers(~longitude, ~latitude, label = ~as.character(site))


leaflet

data(quakes)
head(quakes)
