###########################################

## Title: write_r_to_noaa
## Description: Write a dataframe to NOAA NCEI Palaeo text format
## Date: 20210920
  ## Last edited: 20210920
## Contributors: M. Campbell
## Contacts: michelineleecampbell@gmail.com
## Notes: This is not clever script, but it may save some time in the future. Uses Lough's Coral luminescence dataset from https://www.ncdc.noaa.gov/paleo/study/10292 

###########################################


# packages ----------------------------------------------------------------

library(tidyverse)

# data --------------------------------------------------------------------

dat <- readRDS("NOAA_NCEI/testtdata.rds")
dat <- dat %>% 
  distinct(DatasetID, .keep_all = TRUE)
datall <-readRDS("NOAA_NCEI/testtdata.rds")

# text --------------------------------------------------------------------

line1 <- paste("# ", dat$AuthorLastName[1],".", dat$Region_SourceLocName[1], ".", dat$Year_pub[1], sep = "")
line2 <- "#----------------------------------------------------------------------- 
#                World Data Service for Paleoclimatology, Boulder 
#                                  and 
#                     NOAA Paleoclimatology Program 
#             National Centers for Environmental Information (NCEI)
#----------------------------------------------------------------------- 
# Template Version 4.0
# Encoding: UTF-8
# NOTE: Please cite original publication, NOAA Landing Page URL, dataset and publication DOIs (where available), and date accessed when using downloaded data. If there is no publication information, please cite investigator, study title, NOAA Landing Page URL, and date accessed. 
#
# Description/Documentation lines begin with #
# Data lines have no #
#"

line3 <- "# NOAA_Landing_Page:  https://www.ncdc.noaa.gov/paleo/study/34073
#   Landing_Page_Description: NOAA Landing Page of this file's parent study, which includes all study metadata.
#
# Study_Level_JSON_Metadata: https://www.ncei.noaa.gov/pub/data/metadata/published/paleo/json/  (assigned by WDS Paleo) 
#   Study_Level_JSON_Description: JSON metadata of this data file's parent study, which includes all study metadata.
#"

line4 <- paste("# Data_Type: ",dat$ProxyType[1], sep = "")
line5 <- "#
# Dataset_DOI: 
#
# Science_Keywords: "


line6.1 <- "#--------------------
# Resource_Links
#   
# Data_Download_Resource: https://www.ncei.noaa.gov/pub/data/paleo/reconstructions/croke2021/
#   Data_Download_Description: 
#
# Supplemental_Download_Resource: 
#   Supplemental_Description: 
#
# Related_Online_Resource: 
#   Related_Online_Description:
#"
line6 <- paste("# Original_Source_URL: ", dat$DataURL[1], 
"\n#   Original_Source_Description: ", sep = "")
# line6 <- paste("# Original_Source_URL: ", dat$DataURL[1], sep = "") 
line7 <- paste("
#--------------------
# Contribution_Date
#    Date: ", Sys.Date(), sep = "")
line8 <- "#--------------------
# File_Last_Modified_Date
#     Date: 
#--------------------"
line9 <- paste("# Title
#     Study_Name: ", dat$AuthorLastName[1],".", dat$Region_SourceLocName[1], ".", dat$Year_pub[1], sep = "")

line10 <- paste("#--------------------
# Investigators
#   Investigators: ", dat$All_authors[1],
"\n#--------------------
# Description_Notes_and_Keywords
#   Description:  
#--------------------", sep = "")

line11 <- paste("# Publication 
#   Authors: ", dat$All_authors[1],
"\n#   Published_Date_or_Year: ", dat$Year_pub[1], 
"\n#   Published_Title: ", dat$Title[1],
"\n#   Journal_Name: ", dat$Journal[1],
"\n#   Volume: 
#   Edition: 
#   Issue: 
#   Pages:
#   Report_Number: 
#   DOI: ", dat$DOI[1],
"\n#   Publication_Place: 
#   Publisher:
#   ISBN: 
#   Online_Resource: 
#   Other_Reference_Details: 
#   Full_Citation: ", dat$Citation[1],
"\n#   Abstract: ", sep = "")

line12 <- paste("#--------------------
# Funding_Agency 
#   Funding_Agency_Name: 
#   Grant: ", dat$FundingDetails[1], 
"\n#--------------------", sep = "")

line13 <- paste("# Site_Information 
#   Site_Name: ", dat$SourceLocName[1],
"\n#   Location: ", dat$Region[1],
"\n#   Northernmost_Latitude: ", dat$SourceLat1_BB[1],
"\n#   Southernmost_Latitude: ", dat$SourceLat2_BB[1],
"\n#   Easternmost_Longitude: ", dat$SourceLon2_BB[1],
"\n#   Westernmost_Longitude: ", dat$SourceLon2_BB[1],
"\n#   Elevation_m: ", dat$SouceElevation[1],
"\n#--------------------", sep = "")

line14 <- paste("# Data_Collection  
#   Collection_Name: 
#   Earliest_Year: ", dat$StartYear[1],
"\n#   Most_Recent_Year: ", dat$EndYear[1],
"\n#   Time_Unit: CE
#   Core_Length_m: 
#   Parameter_Keywords: 
#   Notes:
#--------------------")

line15 <- "# Species 
#   Species_Name:
#   Common_Name: 
#   Tree_Species_Code: 
#--------------------"
line15.1 <- "#--------------------
# Chronology_Information
#   Chronology:
#
#--------------------"
# 10 components: what, material, error, units, seasonality, archive, detail, method, C or N for Character or Numeric data, additional_information)
line16 <- paste("# Variables  
#
## depth  depth,  , , ", dat$Depth.Units[1],",  , ",dat$ArchiveType[1],", , , N,
## yearCE year, , , Common Era Year,  , ", dat$ArchiveType[1],",  , , N,
## age  Reported Age, , , ", dat$AgeReference[1], ",  , ", dat$ArchiveType[1], ", , , N,
## ", dat$ProxyType[1],"  ", dat$ProxyType[1]," , , , ", dat$Unit[1], ",  , ", dat$ArchiveType[1],",  , , N,
## Positive Data Error  Positive Data Error,  , , ", dat$Unit[1], ",  , ", dat$ArchiveType[1], ", , , N,
## Negative Data Error  Negative Data Error,  , , ", dat$Unit[1], ",  , ", dat$ArchiveType[1], ", , , N,
## Negative Age Uncertainty  Negative Age Uncertainty,  , , years,  , ", dat$ArchiveType[1], ", , , N,
## Positive Age Uncertainty  Positive Age Uncertainty,  , , years,  , ", dat$ArchiveType[1], ", , , N,
## Quality Code  QC codes for data. QC codes, , , , , , , , C,  1 = raw; 4 = reconstruction; 21 = outlier; 22 = outlier ID needs to be revisted; 23 = outlier test not applied; 40 = NA   
#
#--------------------", sep = "")

name <- dat$ProxyType[1]
table <- datall %>% 
  select(Year, Depth, Age, Value, DataErrorPos, DataErrorNeg, AgeUncertNeg, AgeUncertPos, QC) 

colnames(table)[4] <- `name`

line17<- "# Data:
# Data lines follow (have no #)
# Data line format - tab-delimited text, variable short name as header
# Missing_Values: NA
#"

join <- c(line1, line2, line3, line4, line5, line6.1, line6, line7,  line8, line9, line10, line11, line12, line13, line14, line15, line15.1, line16, line17)


# write to text -----------------------------------------------------------

write(join, file = "NOAA_NCEI/Text.txt",
      append = TRUE, sep = "\n")

write.table(table, file = "NOAA_NCEI/Text.txt",
      append = TRUE, sep = "  ", row.names = FALSE, quote = FALSE)  


