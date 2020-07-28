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

ggplot(data = world) +
  geom_sf() +
  geom_bin2d(data = dat, aes(x=longitude, y = latitude), binwidth = 5, alpha = 0.8) + # gridded, where binwidth is 5*5 degrees
  theme_classic() #is there any other theme?


