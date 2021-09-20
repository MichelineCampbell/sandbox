# sandbox
Fun and random bits of useful code

combine_excel_workbook file provides code to combine csvs into xlsx (matching indexed filenames)
  in prep to run this over >1000 csvs so expecting to funtion-ise at some point
  help from https://stackoverflow.com/questions/27713310/easy-way-to-export-multiple-data-frame-to-multiple-excel-worksheets

spatial_density plots world map + counts of gridded mock data  
used https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html as guide for map
![map](spatial_density/test_map2.png?raw=true)

netcdf_learning includes some code for basic manipulation of netcdf files (specifically spatio-temporal data). Initial how-to from https://rpubs.com/boyerag/297592.
![temp-anom](netcdf_learning/Gisstemp_Aug_anom.png?raw=true)

aus_centred_robinson has some nightmare code to make an Aus-centred Robinson-projected map in ggplot. Help from https://stackoverflow.com/questions/56146735/visual-bug-when-changing-robinson-projections-central-meridian-with-ggplot2 and https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/Pacific%20centered%20world%20map%20with%20ggplot.R. ![robmap](aus_centred_robinson/world_map.png?raw=true)

NOAA_NCEI has code to convert a dataframe of data and metadata to the NOAA NCEI Paleo text format. Code is not clever, but may save someone some time in future. This was developed to support a forthcoming database paper which I'll link here when it is published. 