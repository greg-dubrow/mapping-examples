## plot lat long onto maps
# tutorial from https://rpubs.com/JuanPabloHA/MapsVignetteJP

# Loads the required required packages
library(tidyverse)
library(rgdal)
library(tmap)
library(ggmap)
library(tmaptools)
library(OpenStreetMap)
library(osmdata)

## download data
# Link in tutorial is dead, use this: 
# commented out as I have it on my machine and is unzipped. Uncomment to dl and/or unzip
# download.file("https://data.gov.au/dataset/f6a00643-1842-48cd-9c2f-df23a3a1dc1e/resource/acd0b143-3616-4144-9ef5-d83a67f84148/download/nsw_lga_polygon_shp.zip",
#               destfile = "NSWLGA.zip")
# unzip("NSWLGA.zip")

crime <- read.csv("https://data.nsw.gov.au/data/dataset/608147c1-354e-473f-a35c-8e05b8ed6f84/resource/8fa12ba1-bfba-42d5-bfc7-037604b75b7c/download/gstrategic-policyinformationdata-nsw2016-dataset-uploadsboscarselected-outdoor-crimes-in-sydney-lga-")
glimpse(crime)

# Reads the Shape file and loads it into R, then create dataframe
NSWLGA <- readOGR(dsn = "NSW_LGA_POLYGON_shp", layer = "NSW_LGA_POLYGON_shp")
NSWLGA_Df <- as.data.frame(NSWLGA@data)
glimpse(NSWLGA_Df)

# Plots a simple outline of the map 
## Plot already recognises the object as a map after having installed the rgdal package
plot(NSWLGA)


# The next step is to visualise specific LGAs of NSW. This may be useful in the case you want to 
# put special emphasis in one location or area of NSW, 
# for this particular case I am interested in plotting the polygons that correspond to the 
# LGAs in the Sydney metropolitan area.

# Create a logical object with TRUE values for the LGAs in the Sydney metropolitan area.
# note, this uses postcodes from original polygon file NSWLGA to pull shape data, not the dataframe NSWLGA_df
sydmetro <- NSWLGA$LGA_PID %in% c("NSW335", "NSW283", "NSW268", "NSW264", "NSW272", "NSW282", "NSW332", 
                                  "NSW315", "NSW295", "NSW325", "NSW270", "NSW234", "NSW229", "NSW331", 
                                  "NSW258", "NSW117", "NSW275", "NSW232", "NSW329", "NSW213", "NSW314", 
                                  "NSW217", "NSW216", "NSW181", "NSW196", "NSW298", "NSW200", "NSW175", 
                                  "NSW294", "NSW180") 

# Plots a map of the LGAs that are part of the Sydney Metropolitan Area
plot(NSWLGA[sydmetro, ], col = "deepskyblue2", main = "Sydney Metro", sub = "GRS 80")

### Filling in polygons with colors to represent a distribution. This example uses made-up data, but could be 
## things like income, rates of schooling, crime, disease, etc...

# First we create a new column in our NSWLGA data frame containing values from a normal distribution
set.seed(574)
NSWLGA_Df$Rnorm <- rnorm(nrow(NSWLGA_Df))

# Then we add the new column to the Spatial Polygon Data Frame 
NSWLGA@data <- left_join(NSWLGA@data, NSWLGA_Df, by = "LG_PLY_PID")

# Finally we plot the map
qtm(NSWLGA[sydmetro,], "Rnorm", title = "Sydney Metro", sub ="GRS 80")

# Plotting dots; 1st version base r, second in ggplot. 
# This only plots locations from crime file. Not yet overalyed on a map
plot(x = crime$bcsrgclng, y = crime$bcsrgclat, col = "coral1", main = "Sydney Outdoor Crimes")

crime %>% 
#  filter(incyear == 2015) %>%
  ggplot() +
  geom_point(aes(x = bcsrgclng, y = bcsrgclat), color = "purple4", alpha=.03, size=1.1) +
  labs(title = "Outdoor Crimes in Sydney LGA", x = "Longitude", y = "Latitude")

# different facets for each crime group
crime %>% 
#  filter(incyear == 2015) %>%
  ggplot() +
  geom_point(aes(x = bcsrgclng, y = bcsrgclat), color = "red", alpha  = .09, size=1.1) +
  facet_wrap(~bcsrgrp, ncol = 2) +
  labs(title = "Outdoor Crimes in Sydney LGA", subtitle = "by group", 
       x = "Longitude", y = "Latitude")

### adding plots to an actual map image
# first, bring in ggmap of Syndey

syd_map <- get_map(getbb("Sydney, Australia"),maptype = "roadmap")
ggmap(syd_map)

# to see min/max for map area...
getbb ("sydney australia")
# min       max
# x 150.26083 151.34274
# y -34.17324 -33.36415
# unfortunately this returns a large map area. need more focused on downtown sydney...

# this method uses get_map with bounded lat & long
# left & right are longitdue, top and bottom are latitude. 
# for negative numbers top or right should be higher (closer to 0)
# get ratio of lat::long apporpriate to image shape you want...square, rectangle
# for this example, to get idea of plot coordinates, run min and max of crime data lat & long
    # add padding if desired
min(crime$bcsrgclat) # -33.92344 (bottom)
max(crime$bcsrgclat) # -33.85237 (top)
min(crime$bcsrgclng) # 151.175 (left)
max(crime$bcsrgclng) # 151.233 (right)

sydmap2 <- get_map(c(left = 151.10, bottom = -33.92344, right = 151.25, top = -33.84), maptype = "roadmap")
ggmap(sydmap2)



maryland_bridges <- read_csv("https://github.com/rfordatascience/tidytuesday/blob/master/data/2018/2018-11-27/baltimore_bridges.csv") 