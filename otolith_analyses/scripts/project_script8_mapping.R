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
  filter(region=="Korea")



# Create data frame with just lat / long
location_data <- odata_combo %>%
  select(Sampling.Site, Approx.Lat, Approx.Long) %>%
  distinct(Sampling.Site, Approx.Lat, Approx.Long)

colnames(location_data) <- c("site", "latitude", "longitude")

# source mapping functions
source("scripts/mapping_functions.r")


# set the breaks for your color ramp
mybreaks=c(0, 30, 60, 90, 120, 150, 180)


# Make the first map
ggplot() +
  geom_polygon(data = SK, aes(x=long, y = lat, group = group), fill=" grey37", alpha=0.3) +
  geom_point(data=location_data, aes(x=longitude, y=latitude, color= site), size = 5, alpha = 0.7) +
  theme(panel.background = element_rect(fill = "aliceblue"), 
        panel.grid.major = element_line(colour = NA))






  scale_color_viridis(option="plasma", 
                      name="Date of sampling\n(Julian day)\n", 
                      breaks = mybreaks) + 
  coord_map(xlim= c(-119, -139),  ylim = c(46,60)) +
  labs(x = "Longitude", y = "Latitude") +
  geom_text_repel( data= location_data, aes(x=longitude, y=latitude, label=site), size=4) +
  scale_bar(lon = -136, lat = 47.3, 
            distance_lon = 100, distance_lat = 15, distance_legend = 40, 
            dist_unit = "km", orientation = FALSE)

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
