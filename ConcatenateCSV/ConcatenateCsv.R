library(tidyverse)

listnames  <- list.files("ConcatenateCSV", full.names = TRUE, pattern = "csv") ## Where concatenate CSV is your file directory
  
df <- data.frame(wavenumber = NA,
                 absorbances = NA,
                 sample = NA)

for(i in 1:length(listnames)){
  dat <- read_csv(listnames[i], col_names = FALSE)
  dat <- dat %>% 
    mutate(sample = stringr::str_remove_all(listnames[i], "ConcatenateCSV/"))
  
  colnames(dat) <- c("wavenumber", "absorbances", "sample")
  
  df <- rbind(df, dat)
  
  
  
}

df[-1,]
