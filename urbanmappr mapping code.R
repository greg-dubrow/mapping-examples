
###
## using urbnmapr package from Urban Institute
###
library(rsfsu)
library(tidyverse)
library(janitor)
library(urbnmapr)
library(urbnthemes)
library(rvest)
library(RCurl)
 #devtools::install_github("UI-Research/urbnthemes")
 # source('https://raw.githubusercontent.com/UrbanInstitute/urban_R_theme/master/urban_theme.R')

# creates map of US states
ggplot() + 
  geom_polygon(data = urbnmapr::states, mapping = aes(x = long, y = lat, group = group),
               fill = 'grey', color = 'white') +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45)

# join counties (shapefile) with countydata on fips code
household_data <- left_join(countydata, counties, by = "county_fips") 

# plot data onto map
household_data %>%
  ggplot(aes(long, lat, group = group, fill = medhhincome)) +
  geom_polygon(color = NA) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  labs(fill = "Median Household Income")

### map single state within piped flow
# first join county-level data with shapefile, then filter to just a specific state
# then format map
countydata %>% 
  left_join(counties, by = "county_fips") %>% 
  filter(state_name =="California") %>% 
  ggplot(mapping = aes(long, lat, group = group, fill = horate)) +
  geom_polygon(color = "#ffffff", size = .25) +
  scale_fill_gradientn(labels = scales::percent, #colors = , 
                       guide = guide_colorbar(title.position = "top", direction = "horizontal", barwidth = 10)) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  theme(legend.title = element_text(), 
        legend.key.width = unit(.5, "in")) +
  labs(fill = "Homeownership rate") +
  theme_urbn_map() +
  theme(legend.position = "top")

### map of SF Bay area, w/ county borders
# start with CA map in case we want to look at other regions
# remove County from county_name column
camap <- counties %>%
  filter(state_abbv == "CA") %>%
  mutate(county_name = str_remove(county_name, " County"))

# create county name object to apply labels to map
cacounty_labels <- get_urbn_labels(map = "counties")
cacounty_labels <- county_labels %>%
  select(county_name, state_name, lat, long) %>%
  mutate(county_name = str_remove(county_name, " County")) %>%
  filter(state_name == "California")

# take a look at the map. be careful about projection and lat/long limits
camap %>%
  ggplot(mapping = aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black", size = .25) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45)
  
# table of county names to more easilt copy/paste SF Bay counties
camap %>%
  tabyl(county_name)

# filter 6 counties to get Bay Area. do same for labels
sfbaymap <- camap %>% 
  filter(county_name %in% c("Alameda", "Contra Costa", "Marin", "San Francisco",
                                     "San Mateo", "Santa Clara"))

sfcounty_labels <- cacounty_labels %>%
  filter(county_name %in% c("Alameda", "Contra Costa", "Marin", "San Francisco",
                            "San Mateo", "Santa Clara"))

# plot of sfbay map adding county names
sfbaymap %>%
  ggplot() +
  geom_polygon(aes(long, lat, group = group),
               fill = "white", color = "black", size = .25) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  geom_text(data = sfcounty_labels, aes(long, lat, label = county_name), size = 3)

# plot some location data
# dowload CA dept of ed data with school lat & long

