## plot lat long onto maps
# tutorial from https://rpubs.com/JuanPabloHA/MapsVignetteJP

# Loads the required required packages
library(dplyr)
library(ggplot2)
library(rgdal)
library(tmap)
library(ggmap)

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
# note, this is from original polygon file NSWLGA, not the dataframe NSWLGA_df
sydmetro <- NSWLGA$LGA_PID %in% c("NSW335", "NSW283", "NSW268", "NSW264", "NSW272", "NSW282", "NSW332", 
                                  "NSW315", "NSW295", "NSW325", "NSW270", "NSW234", "NSW229", "NSW331", 
                                  "NSW258", "NSW117", "NSW275", "NSW232", "NSW329", "NSW213", "NSW314", 
                                  "NSW217", "NSW216", "NSW181", "NSW196", "NSW298", "NSW200", "NSW175", 
                                  "NSW294", "NSW180") 

# Plots a map of the LGAs that are part of the Sydney Metropolitan Area
plot(NSWLGA[sydmetro, ], col = "deepskyblue2", main = "Sydney Metro", sub = "GRS 80")

