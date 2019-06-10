
###
## using urbnmapr package from Urban Institute
###

library(tidyverse)
library(urbnmapr)
library(urbnthemes)
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

##########################

