## Name: spatial_density
## Purpose: test density plot for 5 degree grids
## Author: Micheline Campbell
## Date created: 20200728
  ## Last edited: 20200728
  ## Edited by: MC
## Contact info: michelineleecampbell@gmail.com
## Notes: https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html, https://stackoverflow.com/questions/38822718/creating-2d-bins-in-r


# packages ----------------------------------------------------------------
library(tidyverse)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)


# data --------------------------------------------------------------------

dat <- read_csv("spatial_density/test_data.csv") # mock proxy data
world <- ne_countries(scale = "medium", returnclass = "sf") # world map data
# aes(fill = continent)

ggplot(data = world) +
  # scale_fill_viridis_d() +
  geom_sf(fill = "grey80") +
  # scale_fill_viridis_d() +
  coord_sf(expand = FALSE) +
  xlab("Longitude") +
  ylab("Latitude") +
  # coord_sf(crs = "+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ") + Want to figure out how to get geom_bin2d to work with a different projection
  geom_bin2d(data = dat, aes(x=longitude, y = latitude), binwidth = 5, alpha = 0.8, inherit.aes = FALSE) + #gridded, where binwidth is 5*5 degrees
  scale_fill_viridis_c() +
  theme_classic() #is there any other theme?

ggsave("spatial_density/test_map.png", width = 5, height = 2.5, units = "in")

