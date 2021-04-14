## Name: 06_mapping_reconstructions
## Purpose: Map reconstructions in database
## Author: Micheline Campbell
## Date created: 20210223
## Last edited: 20210223
## Edited by: MC
## Contact info: michelineleecampbell@gmail.com
## Notes: 
# https://stackoverflow.com/questions/56146735/visual-bug-when-changing-robinson-projections-central-meridian-with-ggplot2
# https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/Pacific%20centered%20world%20map%20with%20ggplot.R




# packages ----------------------------------------------------------------

library(tidyverse)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(rgdal)
library(data.table)

# world base map  --------------------------------------------------------------------

world <- ne_countries(scale = 110, returnclass = 'sf')
# world <- ne_coastline(scale = 110, returnclass = 'sf')

polygon <- st_polygon(x = list(rbind(c(-0.0001, 90),
                                     c(0, 90),
                                     c(0, -90),
                                     c(-0.0001, -90),
                                     c(-0.0001, 90)))) %>%
  st_sfc() %>%
  st_set_crs(4326)
PROJ <-  '+proj=robin +lon_0=180 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs'

# modify world dataset to remove overlapping portions with world's polygons
world2 <- world %>% st_difference(polygon)
world_robinson <- st_transform(world2, 
                               crs = '+proj=robin +lon_0=180 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs')
bbox = st_bbox(world_robinson)
bbox[c(1,3)] = c(-1e-5,1e-5)
polygon2 <- st_as_sfc(bbox)

crosses = world_robinson %>%
  st_intersects(polygon2) %>%
  sapply(length) %>%
  as.logical %>%
  which

library(magrittr)
world_robinson[crosses,] %<>%
  st_buffer(0) 

# 
# # 
# sites <- st_as_sf(dat, coords = c("SourceLon1", "SourceLat1"),
#                    crs = 4326, agr = "constant")
# 
# 
# ggplot(data = world_robinson) +
#   geom_sf(data = st_graticule(world_robinson,
#                               lon = c(0.3,60,120,180,240,300,359.1),
#                               lat = c(90.1,75,60,45,30,15,0,-15,-30,-45,-60,-75,-90.1)), linetype = "dashed") +
#   geom_sf(fill = "grey50", colour = "black" ) + 
#   # coord_sf(label_graticule = "SW", e) +
#   # coord_sf(expand = FALSE) +
#   theme(panel.background = element_rect(fill = "white"))  +
#   # geom_sf(data = sites, 
#   #         aes(fill = Corrected_Rec_params,
#   #             shape = ResolutionQualitativeClass),
#   #         size = 2,
#   #         stroke = 0.5,
#   #         alpha = 0.5) +
#   scale_fill_viridis_d() +
#   scale_shape_manual(values = c(21,22,24)) +
#   theme(legend.position = "bottom",
#         legend.box = "vertical") +
#   guides(fill = guide_legend(nrow = 5, override.aes=list(shape=21, alpha = 1)),
#          shape = guide_legend(override.aes = list(alpha = 1))) +
#   labs(shape = "Resolution",
#        fill = "Reconstructed Variable")
# 
#   
#   
#   
#   
  
  
  

  # create a bounding box - world extent

  b.box <- as(raster::extent(-180, 180, -90, 90), "SpatialPolygons")

  # assign CRS to box
  proj4string(b.box) <- PROJ
  # create graticules/grid lines from box
  grid <- gridlines(b.box, 
                    easts  = c(0,60,120,180,-120,-60,0),
                    norths = c(80,60,40,20,0,-20,-40,-60,-80))
  grid.lbl <- labels(grid, side = 1:2)
  
  # transform labels from SpatialPointsDataFrame to a data table that ggplot can use
  grid.lbl.DT <- data.table(grid.lbl@coords, grid.lbl@data)
  grid.lbl.DT[, long := ifelse(coords.x1 %in% c(-180), coords.x1*0, coords.x1)]
  grid.lbl.DT[, lat  := coords.x2]#ifelse(coords.x2 %in% c(-90,0,90), coords.x2*82/90, coords.x2)]
  grid.lbl.DT[, c("X","Y") := data.table(project(cbind(long, lat), proj=PROJ))]



  
xlabs <- grid.lbl.DT %>% 
  filter(pos == 1) %>% 
  mutate(labels = as.numeric(labels),
         labels2 = ifelse(labels < 0,
                          paste0(abs(labels), "°W"),
                          paste0(labels, "°E")),
         labels2 = ifelse(labels == 0,
                          paste0(labels, "°"),
                          labels2), 
         labels = labels2)
  
ylabs <- grid.lbl.DT %>% 
  filter(pos == 2) %>% 
  mutate(labels = as.numeric(labels),
         labels2 = ifelse(labels < 0,
                          paste0(abs(labels), "°S"),
                          paste0(labels, "°N")),
         labels2 = ifelse(labels == 0,
                          paste0(labels, "°"),
                          labels2), 
         labels = labels2)



  
map <- ggplot(data = world_robinson) +
    geom_sf(data = st_graticule(world_robinson,
                                lon = c(0.3,60,120,180,240,300,359.1),
                                lat = c(80,60,40,20,0,-20,-40,-60,-80)), linetype = "dashed", size = 0.1, colour = "grey60") +
    geom_sf(fill = "grey50", colour = "grey50") + 
    theme(panel.background = element_rect(fill = "white")) + 
    coord_sf(expand = TRUE, crs =  PROJ, label_axes = "SW", clip = "off") +
    geom_text(data = xlabs, # longitude
      aes(x = X, y = Y, label = labels),
      colour = "black", size = 4, vjust = 1.2) +
    geom_text(data = ylabs, # latitude
              aes(x = X, y = Y, label = labels),
              colour = "black", size = 4, hjust = 1.6) +
  # theme(axis.title.x = element_text(vjust = 0)) +
    labs(x = NULL,
         y = NULL)

ggsave(filename = "aus_centred_robinson/world_map.png",
       plot = map,
       width = 20, 
       height = 10,
       units = "cm")

