## Name: 01_extract_plot_gisstemp_ncdf
## Purpose: learning to use netcdf files
## Author: Micheline Campbell
## Date created: 20200922
  ## Last edited: 20200922
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

source("H:/General_R/update_theme.R")

# data --------------------------------------------------------------------

nc_data <- nc_open("D:/CampbellM1/R_learning_space/gisstemp_2020/gistemp250_GHCNv4.nc")


# data cleaning -----------------------------------------------------------

{ # for looking at the data
  sink("gisstemp.txt")
  print(nc_data)
  sink()
}

lon <- ncvar_get(nc_data, "lon")
lat <- ncvar_get(nc_data, "lat")
t <- ncvar_get(nc_data, "time")
tdate <- as.Date(t, origin=c('1800-01-01')) ## convert time (days since 18000101 to date)


temp.array <- ncvar_get(nc_data, "tempanomaly") #extract temp anomaly data
fillvalue <- ncatt_get(nc_data, "tempanomaly", "_FillValue") 
nc_close(nc_data)

temp.array[temp.array == fillvalue$value] <- NA ## replace fill value with NA
temp.slice <- temp.array[, , 1688] ## pulls one month(?) of data out. 
dim(temp.slice)
dim(temp.array)

r <- raster(t(temp.slice), xmn = min(lon), xmx = max(lon), ymn = min(lat), ymx = max(lat), crs = CRS("+proj=longlat +datum=WGS84 +no_defs"))
plot(r)

r <- flip(r, direction = 'y')

plot(r)



### bricking collapses all layers into one object. 
r_brick <- brick(temp.array, xmn=min(lat), xmx=max(lat), ymn=min(lon), ymx=max(lon), crs=CRS("+proj=longlat +datum=WGS84 +no_defs"))
r_brick <- t(r_brick)
r_brick <- flip(r_brick, direction = "y")
plot(r_brick)



## Plot august 2020 anomaly

tempCuts <- seq(-7.5, 7.5, length.out = 11)


world <- ne_countries()
rasterVis::gplot(r) + 
  geom_tile(aes(fill = cut(value, tempCuts))) +
  geom_path(data = world, aes(x = long, y = lat, group = group)) +
  # geom_contour(aes(x = long, y = lat))
  # geom_sf(data = world) +
  scale_fill_brewer(palette = "RdBu", 
                    drop = FALSE,
                    direction = -1) +
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

ggsave(filename = "Gisstemp_Aug_anom.png", width = 10, scale = 1)




