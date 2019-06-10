# creates look-up table of CA counties with FIPS codes to match back to use if needed to
#  match SFSU or CA Ed data with county names where FIPS code isn't present
# manipulate with dplyr, county shape file and names from Urban Institute package
# shapefile data also in 

library(dplyr)
library(urbnmapr)


cafips <- counties %>%
  filter(state_name =="California") %>%
  distinct(county_fips, .keep_all = TRUE) %>%
  select(county_name, county_fips) %>%
  mutate(county_name = str_remove(county_name, " County"))

