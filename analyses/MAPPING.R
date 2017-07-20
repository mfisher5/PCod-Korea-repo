
install.packages("maps")
install.packages("ggmap")
# Make sure that you have downloaded the following packages:
library(maps) #The maps package contains a lot of outlines of continents, countries, states, and counties that have been with R for a long time.
library(ggplot2) # Has function get_map, which is a smart wrapper that queries the Google Maps, OpenStreetMap, Stamen Maps or Naver Map servers for a map
library (ggmap)  

#Set working directory. Put your .csv file here. 
setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses")

# Read in your data 
my_data <- read.csv("../nb_pictures/MAPPING_SamplingLocations.csv")


# Compute a bounding box for a given longitude / latitude collection using ggmap function make_bbox. 
# The bounding box delimits the borders of your map.
my_data_bbox <- make_bbox(lat = latitude, lon = longitude, data = my_data)
my_data_bbox


# grab the maps from google
#option1
my_data_roadmap <- get_map(location = my_data_bbox, source = "google", maptype = "satellite", zoom = 7, color = "bw")

# sexy watercolor option. Choose thisif you want your map to look like it was made by hand.
#my_data_big <- get_map(location = my_data_bbox, source = "stamen", maptype = "watercolor")



########## First plotting attempt: color by sub-region code ############

# Plot #1 : A labeled map



ggmap(my_data_roadmap) + # specify the dataframe
  geom_point(data = my_data, mapping = aes(x = longitude, y = latitude, color = factor(location_code), size = 10, shape = factor(Subregion))) + #specify what kind of plot you want, and what part of your dataframe you are plotting
  scale_color_manual(values = c("#D55E00", "#EECC16", "#E69F00", "#56B4E9", "#CC79A7", "#d8d2d2", "#009E73")) + #set the colors of the points with a vector
  scale_shape_manual(values = c(15,19,19,17)) + #set the shape of the points with a vector
  labs(x = 'Longitude', y = 'Latitude') + # set custom labels for your axes
  geom_text(data = my_data, aes(x = longitude, y = latitude, label = abbreviation), size = 4, vjust = 1.2, hjust = 1.2, color = "white") # add text to label each of your sampling locations


### with larger points and labels ###


ggmap(my_data_roadmap) + # specify the dataframe
  geom_point(data = my_data, mapping = aes(x = longitude, y = latitude, color = factor(location_code), shape = factor(Subregion)), size = 7) + #specify what kind of plot you want, and what part of your dataframe you are plotting
  scale_color_manual(values = c("#D55E00", "#EECC16", "#E69F00", "#56B4E9", "#CC79A7", "#d8d2d2", "#18e2ab", "#009E73")) + #set the colors of the points with a vector
  scale_shape_manual(values = c(15,19,19,17)) + #set the shape of the points with a vector
  labs(x = 'Longitude', y = 'Latitude') + # set custom labels for your axes
  geom_text(data = my_data, aes(x = longitude, y = latitude, label = abbreviation), size = 5, vjust = 1.2, hjust = 1.2, color = "white") # add text to label each of your sampling locations


