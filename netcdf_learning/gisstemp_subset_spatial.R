## Name: gisstemp_subset_spatial
## Purpose: Learning how to spatially subset netcdf data
## Author: Micheline Campbell
## Date created: 20200929
  ## Last edited: 20200930
  ## Edited by: MC
## Contact info: michelineleecampbell@gmail.com
## Notes: 
 
# packages ----------------------------------------------------------------

library(rnaturalearth)
library(rnaturalearthdata)
library(ncdf4) # package for netcdf manipulation
library(raster) # package for raster manipulation
library(rgdal) # package for geospatial analysis
library(ggplot2)
library(rasterVis)
library(pals)

source("H:/General_R/update_theme.R")

# colorpalette ------------------------------------------------------------

## want to go from -4 to 4 at 0.5 degrees = 17 colours
palcoolwarm <- coolwarm(n = 17)



# data --------------------------------------------------------------------

nc_data <- nc_open("D:/CampbellM1/R_learning_space/gisstemp_2020/gistemp250_GHCNv4.nc")


lon <- ncvar_get(nc_data, "lon")
lat <- ncvar_get(nc_data, "lat")
t <- ncvar_get(nc_data, "time")
tdate <- as.Date(t, origin=c('1800-01-01')) ## convert time (days since 18000101 to date)

temp.array <- ncvar_get(nc_data, "tempanomaly") #extract temp anomaly data
fillvalue <- ncatt_get(nc_data, "tempanomaly", "_FillValue") 
nc_close(nc_data)

temp.array[temp.array == fillvalue$value] <- NA ## replace fill value with NA

r_brick <- brick(temp.array, xmn=min(lat), xmx=max(lat), ymn=min(lon), ymx=max(lon), crs=CRS("+proj=longlat +datum=WGS84 +no_defs"))
r_brickcorrect <- t(r_brick)
r_brickcorrect <- flip(r_brickcorrect, direction = "y")


print(r_brick)
plot(r_brickcorrect$layer.1688)
pr <- r_brickcorrect
pt <- cbind(c(100, 179), c(0, -55))
plot(pr[[1688]])
points(pt)

cropextent <- extent(c(100, 179, -55, 0))

cropped_gistemp <- crop(r_brickcorrect, cropextent)

plot(cropped_gistemp[[1688]])


tempCuts <- seq(-4, 4, length.out = 17)


aus <- ne_countries(country = "australia")
rasterVis::gplot(cropped_gistemp[[1688]]) + 
  geom_tile(aes(fill = cut(value, tempCuts))) +
  # geom_tile(aes(fill = value)) +
  geom_path(data = aus, aes(x = long, y = lat, group = group)) +
  # geom_contour(aes(x = long, y = lat))
  # geom_sf(data = world) +
  # scale_fill_brewer(palette = "RdBu",
  #                   drop = FALSE,
  #                   direction = -1) +
  scale_fill_manual(values = as.vector(palcoolwarm),
                    drop = FALSE,
                    na.value = "white") +
  coord_equal() +
  theme_MC_grid() +
  labs(x = "Longitude",
       y = "Latitude",
       fill = "Temperature anomaly \nrelative to 1951-1980",
       title = "August 2020 GISTEMP V4 \nSurface Air Temperature Anomaly",
       subtitle = "Surface Air Temperature (no ocean data): 250 km smoothing") +
  guides(fill = guide_legend(override.aes = list(size = 2),ncol = 2)) +
  theme(plot.title = element_text(size = 8),
        plot.subtitle = element_text(size = 6),
        legend.title = element_text(size = 6),
        legend.text = element_text(size = 5),
        axis.title = element_text(size = 7),
        axis.text = element_text(size = 6))





