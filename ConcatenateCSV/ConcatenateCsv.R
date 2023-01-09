library(tidyverse)

listnames  <- list.files("ConcatenateCSV", full.names = TRUE) ## Where concatenate CSV is your file directory
  
df <- data.frame(wavenumber = NA,
                 absorbances = NA,
                 sample = NA)

for(i in 1:length(listnames)){
  dat <- read_csv(listnames[i])
  dat <- dat %>% 
    mutate(sample = listnames[i])
  
  df <- rbind(df, dat)
  
  
  
}

df[-1,]
