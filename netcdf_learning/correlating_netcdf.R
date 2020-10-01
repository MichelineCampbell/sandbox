## Name: correlating_netcdf
## Purpose: Trying to figure out how to do correlations!
## Author: Micheline Campbell
## Date created: 20200930
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

cropextent <- extent(c(100, 179, -55, 0))
cropped_gistemp <- crop(r_brickcorrect, cropextent)
plot(cropped_gistemp[[1688]]) # check


fakedata <- data.frame(t = seq(1:1688), fakey = rnorm(1688, mean = 20, sd = 1)* t^(0.2))

fun <- function(x) {
  cor(x, fakedata$fakey)
}
x2 <- raster::calc(cropped_gistemp, fun)

cropped_gistemp_e <- extract(cropped_gistemp, matrix(c(145, -30), ncol =2))
dim(cropped_gistemp_e)
cropped_gistemp_e <- t(data.frame(y = cropped_gistemp_e))

test <- cor(cropped_gistemp_e, fakedata$fakey)
test
x2cor <- extract(x2, matrix(c(145, -30), ncol =2))
x2cor


tempCuts <- seq(-4, 4, length.out = 17)
aus <- ne_countries(country = "australia")
rasterVis::gplot(x2) + 
  geom_tile(aes(fill = cut(value, tempCuts))) +
  geom_path(data = aus, aes(x = long, y = lat, group = group)) +
  geom_point(aes(x = 145, y = -30)) +
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



