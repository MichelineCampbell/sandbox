###########################################

## Title: RobinsonWorldMap
## Description: Reprojected and plotted as robinson
## Date: 20220128
## Last edited: 2021122
## Contributors: M. Campbell
## Contacts: michelineleecampbell@gmail.com
## Notes: 

###########################################

# packages ----------------------------------------------------------------

# library(RStoolbox)
library(raster)
library(sf)
library(tidyverse)
# library(extrafont)

# data --------------------------------------------------------------------

robinson <- CRS("+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")

## to clip map to robinson. This step takes a while to run
bb <- sf::st_union(sf::st_make_grid(
  st_bbox(c(xmin = -180,
            xmax = 180,
            ymax = 90,
            ymin = -90), crs = st_crs(4326)),
  n = 100))
## reproject bounding box
bb_robinson <- st_transform(bb, as.character(robinson))

## world map data
worldsf <- rnaturalearth::ne_countries(returnclass = "sf")

## reproject world map data
worldsfrob <- st_transform(worldsf,
                           crs = "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")

## plot
ggplot() +
  # world  map
  geom_sf(data = worldsfrob, fill = "grey20", colour = NA) + 
  # clip sf outside of bounds
  geom_sf(data=bb_robinson,
          colour='black',
          linetype='solid',
          fill = NA,
          size=0.1) +
theme_void() +
  theme(panel.background = element_rect(fill = NULL), 
        plot.background = element_rect(fill = NULL))



# 
# ggsave(filename = "C:/Users/miche/OneDrive - UNSW/conferencese/ICSHMO_2022/presentation/figures/FireMap.png",
#        plot = sisalFire,
#        # device = cairo_pdf,
#        height = 150,
#        width = 150,
#        units = "mm",
#        dpi = 900)
