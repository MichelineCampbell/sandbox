
# https://rpubs.com/boyerag/297592

library(ncdf4) # package for netcdf manipulation
library(raster) # package for raster manipulation
library(rgdal) # package for geospatial analysis
library(ggplot2) # package for plotting

nc_data <- nc_open("D:/CampbellM1/R_learning_space/GIMMS3G_NDVI_TRENDS_1275/data/gimms3g_ndvi_1982-2012.nc4")

{ 
  sink("gimms3g_ndvi_1982-2012_metadata.txt")
  print(nc_data)
  sink()
}

lon <- ncvar_get(nc_data, "lon")
lat <- ncvar_get(nc_data, "lat")
t <- ncvar_get(nc_data, "time")


ndvi.array <- ncvar_get(nc_data, "NDVI")
fillvalue <- ncatt_get(nc_data, "NDVI", "_FillValue")
nc_close(nc_data)


ndvi.array[ndvi.array == fillvalue$value] <- NA

ndvi.slice <- ndvi.array[, , 1]

r <- raster(t(ndvi.slice), xmn = min(lon), xmx = max(lon), ymn = min(lat), ymx = max(lat), crs = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))

r <- flip(r, direction = 'y')

plot(r)

r_brick <- brick(ndvi.array, xmn=min(lat), xmx=max(lat), ymn=min(lon), ymx=max(lon), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))

r_brick <- flip(t(r_brick), direction='y')  ## may need to tweak to get right directions

toolik_lon <- -149.5975
toolik_lat <- 68.6275
toolik_series <- extract(r_brick, SpatialPoints(cbind(toolik_lon,toolik_lat)), method='simple')

toolik_df <- data.frame(year= seq(from=1982, to=2012, by=1), NDVI=t(toolik_series))
ggplot(data=toolik_df, aes(x=year, y=NDVI, group=1)) +
  geom_line() + # make this a line plot
  ggtitle("Growing season NDVI at Toolik Lake Station") +     # Set title
  theme_bw()



ndvi.slice.2012 <- ndvi.array[, , 31] 
ndvi.diff <- ndvi.slice.2012 - ndvi.slice
r_diff <- raster(t(ndvi.diff), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))
r_diff <- flip(r_diff, direction='y')
plot(r_diff)
