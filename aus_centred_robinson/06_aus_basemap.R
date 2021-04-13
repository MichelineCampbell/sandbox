# aus base map ------------------------------------------------------------


aus <- ne_countries(scale = 110, returnclass = 'sf')
aus <- st_crop(aus, xmin = 110, xmax = 180,
                 ymin = -50, ymax =0)
polygon <- st_polygon(x = list(rbind(c(-0.0001, 90),
                                     c(0, 90),
                                     c(0, -90),
                                     c(-0.0001, -90),
                                     c(-0.0001, 90)))) %>%
  st_sfc() %>%
  st_set_crs(4326)
PROJ <-  '+proj=robin +lon_0=180 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs'

# modify aus dataset to remove overlapping portions with aus's polygons
aus2 <- aus %>% st_difference(polygon)
aus_robinson <- st_transform(aus2, 
                               crs = '+proj=robin +lon_0=180 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs')
ausbbox = st_bbox(aus_robinson)
ausbbox[c(1,3)] = c(-1e-5,1e-5)
polygon2 <- st_as_sfc(ausbbox)

auscrosses = aus_robinson %>%
  st_intersects(polygon2) %>%
  sapply(length) %>%
  as.logical %>%
  which

library(magrittr)
aus_robinson[auscrosses,] %<>%
  st_buffer(0) 



# create a bounding box - aus extent

ausb.box <- as(raster::extent(110, 180, -50, 0), "SpatialPolygons")

# assign CRS to box
proj4string(ausb.box) <- PROJ
# create graticules/grid lines from box
ausgrid <- gridlines(ausb.box, 
                  easts  = c(110,120,130,140,150,160,170,180),
                  norths = c(0,-10,-20,-30,-40,-50))
ausgrid.lbl <- labels(ausgrid, side = 1:2)

# transform labels from SpatialPointsDataFrame to a data table that ggplot can use
ausgrid.lbl.DT <- data.table(ausgrid.lbl@coords, ausgrid.lbl@data)
ausgrid.lbl.DT[, long := ifelse(coords.x1 %in% c(-180), coords.x1*0, coords.x1)]
ausgrid.lbl.DT[, lat  := coords.x2]#ifelse(coords.x2 %in% c(-90,0,90), coords.x2*82/90, coords.x2)]
ausgrid.lbl.DT[, c("X","Y") := data.table(project(cbind(long, lat), proj=PROJ))]




ausxlabs <- ausgrid.lbl.DT %>% 
  filter(pos == 1) %>% 
  mutate(labels = as.numeric(labels),
         labels2 = ifelse(labels < 0,
                          paste0(abs(labels), "°W"),
                          paste0(labels, "°E")),
         labels2 = ifelse(labels == 0,
                          paste0(labels, "°"),
                          labels2), 
         labels = labels2)

ausylabs <- ausgrid.lbl.DT %>% 
  filter(pos == 2) %>% 
  mutate(labels = as.numeric(labels),
         labels2 = ifelse(labels < 0,
                          paste0(abs(labels), "°S"),
                          paste0(labels, "°N")),
         labels2 = ifelse(labels == 0,
                          paste0(labels, "°"),
                          labels2), 
         labels = labels2)



map_aus <- ggplot(data = aus_robinson) +
  geom_sf(data = st_graticule(aus_robinson,
                              lon = c(110,130,150,170),
                              lat = c(0,-10,-20,-30,-40,-50)), linetype = "dashed", size = 0.1, colour = "grey60") +
  geom_sf(fill = "grey50", colour = "grey50") + 
  theme(panel.background = element_rect(fill = "white")) + 
  coord_sf(expand = TRUE, crs =  PROJ, label_axes = "SW", clip = "off") +
  geom_text(data = ausxlabs, # longitude
            aes(x = X, y = Y, label = labels),
            colour = "black", size = 4, vjust = 1.2) +
  geom_text(data = ausylabs, # latitude
            aes(x = X, y = Y, label = labels),
            colour = "black", size = 4, hjust = 1.6) +
  # theme(axis.title.x = element_text(vjust = 0)) +
  labs(x = NULL,
       y = NULL)
