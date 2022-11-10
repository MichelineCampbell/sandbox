###########################################

## Title: 01_FireHistoryMargs
## Description: Fire history for lat-long
## Date: 20221109
## Last edited: 20221109
## Contributors: M. Campbell
## Contacts: michelineleecampbell@gmail.com
## Notes: USING DBCA Fire history database https://catalogue.data.wa.gov.au/dataset/dbca-fire-history

###########################################

library(rgdal)
library(ggplot2)
library(dplyr)
library(readr)
library(sf)

fires <- st_read("fireHistories/DBCA_Fire_History_DBCA_060_WA_GDA2020_Public_ShapefileMARGS/DBCA_Fire_History_DBCA_060.shp") # read in DBCA_060



sampCoords <- read_csv("fireHistories/SampleCoords.csv") # example coordinates




coordinates(sampCoords) <- ~Longitude+Latitude ## tell R it has a coordinate system
sampCoords <- st_as_sf(sampCoords) # convert to sf

st_crs(sampCoords) <- st_crs(fires) ## give the points the same CRS as the map. GDA2020

# details -----------------------------------------------------------------

q <- list()
# i <- 1
for(i in 1:length(sampCoords$Site)){
  obj <- st_intersects(sampCoords[i,], fires, sparse = TRUE) # gets the intersect between the fire map and the ith row in sampCoords
  obj <- data.frame(row = obj[[1]]) # select row numbers
  
  q[[i]] <- fires[obj$row,] # Filter the fire map for those row numbers and write to the ith level of list q
  
  
  q[[i]]$location <- sampCoords[i,]$Site # tell q what site
  q[[i]]$geometry <- sampCoords[i,]$geometry # tell q the sample location
  
}

results <- purrr::map_df(.x = q, .f = data.frame) # collapse into dataframe
resultsum <- results %>%
  select(fih_fire_s: fih_season, fih_fire_t, location,geometry) %>% # select interesting bits
  group_by(location) %>% 
  mutate(firehistory = paste0(fih_year1, collapse = ", "))  # get all years of fire for each site. 
  # View(resultsum)


