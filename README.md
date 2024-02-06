# sandbox
Fun and random bits of useful code

*combine_excel_workbook* file provides code to combine csvs into xlsx (matching indexed filenames)
  in prep to run this over >1000 csvs so expecting to funtion-ise at some point
  help from https://stackoverflow.com/questions/27713310/easy-way-to-export-multiple-data-frame-to-multiple-excel-worksheets

*spatial_density* plots world map + counts of gridded mock data  
used https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html as guide for map
![map](spatial_density/test_map2.png?raw=true)

*netcdf_learning* includes some code for basic manipulation of netcdf files (specifically spatio-temporal data). Initial how-to from https://rpubs.com/boyerag/297592.
![temp-anom](netcdf_learning/Gisstemp_Aug_anom.png?raw=true)

*aus_centred_robinson* has some nightmare code to make an Aus-centred Robinson-projected map in ggplot. Help from https://stackoverflow.com/questions/56146735/visual-bug-when-changing-robinson-projections-central-meridian-with-ggplot2 and https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/Pacific%20centered%20world%20map%20with%20ggplot.R. ![robmap](aus_centred_robinson/world_map.png?raw=true)

*NOAA_NCEI* has code to convert a dataframe of data and metadata to the NOAA NCEI Paleo text format. Code is not clever, but may save someone some time in future. This was developed to support a forthcoming database paper which I'll link here when it is published. 

*ConcatenateCsv* is for, if some reason, you need to concatenate a shed-load of csvs.

*FillUnderLine* is if you want to make some pretty timeseries squiggly lines which are shaded.  ![fill](FillUnderLine/fillUnderLine.png?raw=true)

*fireHistories* is to extract fire frequency data from the DBCA-060 database - developed for this [preprint](https://www.authorea.com/users/721011/articles/705978-combustion-completeness-and-sample-location-determine-wildfire-ash-leachate-chemistry?commit=9924c83fb4c457b0ab70ccbdac1fc4530b3721c6)

*CalculateUThCorrections* does just that, using Pieter Vermeesch's great [IsoplotR](https://github.com/pvermees/IsoplotR) package. Shared here, because I found it quite complicated to figure out, and then had a stumble at the very end with uncertainties that were double what I expected - thanks Pieter for explaining the intricacies of the read.data function! 

Here, we are replicating the calculations presented in Treble, P.C., Baker, A., Abram, N.J., Hellstrom, J.C., Crawford, J., Gagan, M.K., Borsato, A., Griffiths, A.D., Bajo, P., Markowska, M., Priestley, S.C., Hankin, S., Paterson, D., 2022. Ubiquitous karst hydrological control on speleothem oxygen isotope variability in a global study. Commun Earth Environ 3, 1–10. https://doi.org/10.1038/s43247-022-00347-3 (see Supllementary Table 5). 



