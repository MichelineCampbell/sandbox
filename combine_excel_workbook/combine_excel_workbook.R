## Name: combine_excel_workbook
## Purpose: combine .csvs into .xlsx workbook
## Author: Micheline Campbell
## Date created: 20200722
  ## Last edited: 20200722  
  ## Edited by: MC
## Contact info: michelineleecampbell@gmail.com
## Notes: notes

# packages ----------------------------------------------------------------

library(openxlsx)

# dummy data --------------------------------------------------------------
lists <- seq(1:3) # number of dummy data files
x <- data.frame(seq(1:100)) #dummy data

#dummy set 1 (3 files with metax1-3.csv)
for(i in lists){
  export_name <- paste0("combine_excel_workbook/data/", "meta","x", i, ".csv")
  write.csv(x, export_name)
}

#dummy set 2 (3 files with datax1-3.csv)
for(i in lists){
  export_name <- paste0("combine_excel_workbook/data/", "data","x", i, ".csv")
  write.csv(x, export_name)
}

#dummy set 2 (3 files with data2x1-3.csv)
for(i in lists){
  export_name <- paste0("combine_excel_workbook/data/", "data2","x", i, ".csv")
  write.csv(x, export_name)
}


y <- list.files("combine_excel_workbook/data/") # get list of the files we just found

## for files appended x1
ylistx1 <- which(endsWith(y, "x1.csv") == TRUE)

datx1_1 <- read.csv(paste0("combine_excel_workbook/data/",y[ylistx1[1]])) # read in csvs
datx1_2 <- read.csv(paste0("combine_excel_workbook/data/",y[ylistx1[2]]))
datx1_3 <- read.csv(paste0("combine_excel_workbook/data/",y[ylistx1[3]]))

list_of_datasetsx1 <- list("page 1" = datx1_1, "page 2" = datx1_2, "page 3" = datx1_3) # replace "page 1" etc. with name of pages
write.xlsx(list_of_datasetsx1, file = "combine_excel_workbook/combined_workbook_x1.xlsx") # write to xlsx

## for files appended x2
ylistx2 <- which(endsWith(y, "x2.csv") == TRUE)

datx2_1 <- read.csv(paste0("combine_excel_workbook/data/",y[ylistx2[1]])) 
datx2_2 <- read.csv(paste0("combine_excel_workbook/data/",y[ylistx2[2]]))
datx2_3 <- read.csv(paste0("combine_excel_workbook/data/",y[ylistx2[3]]))

list_of_datasetsx2 <- list("page 1" = datx2_1, "page 2" = datx2_2, "page 3" = datx2_3) # replace "page 1" etc. with name of pages
write.xlsx(list_of_datasetsx2, file = "combine_excel_workbook/combined_workbook_x2.xlsx")

## for files appended x3
ylistx3 <- which(endsWith(y, "x3.csv") == TRUE)

datx3_1 <- read.csv(paste0("combine_excel_workbook/data/",y[ylistx3[1]])) 
datx3_2 <- read.csv(paste0("combine_excel_workbook/data/",y[ylistx3[2]]))
datx3_3 <- read.csv(paste0("combine_excel_workbook/data/",y[ylistx3[3]]))

list_of_datasetsx3 <- list("page 1" = datx3_1, "page 2" = datx3_2, "page 3" = datx3_3) # replace "page 1" etc. with name of pages
write.xlsx(list_of_datasetsx3, file = "combine_excel_workbook/combined_workbook_x2.xlsx")

