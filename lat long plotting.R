## plot lat long onto maps
# tutorial from https://rpubs.com/JuanPabloHA/MapsVignetteJP

# Loads the required required packages
library(dplyr)
library(ggplot2)
library(rgdal)
library(tmap)
library(ggmap)

## download data
# This link not working any longer,file at link below 
#download.file("https://data.gov.au/dataset/f6a00643-1842-48cd-9c2f-df23a3a1dc1e/resource/696e169d-5749-4a15-a0a9-79e637e7c391/download/nswlgapolygonshp.zip", destfile="NSWLGA.zip")

download.file("https://data.gov.au/dataset/f6a00643-1842-48cd-9c2f-df23a3a1dc1e/resource/acd0b143-3616-4144-9ef5-d83a67f84148/download/nsw_lga_polygon_shp.zip",
              destfile = "NSWLGA.zip")
unzip("NSWLGA.zip")

crime <- read.csv("https://data.nsw.gov.au/data/dataset/608147c1-354e-473f-a35c-8e05b8ed6f84/resource/8fa12ba1-bfba-42d5-bfc7-037604b75b7c/download/gstrategic-policyinformationdata-nsw2016-dataset-uploadsboscarselected-outdoor-crimes-in-sydney-lga-")
glimpse(crime)

# Reads the Shape file and loads it into R, then create dataframe
NSWLGA <- readOGR(dsn = "NSW_LGA_POLYGON_shp", layer = "NSW_LGA_POLYGON_shp")
NSWLGA_Df <- as.data.frame(NSWLGA@data)
glimpse(NSWLGA_Df)

# Plots a simple outline of the map 
## Plot already recognises the object as a map after having installed the rgdal package
plot(NSWLGA)

