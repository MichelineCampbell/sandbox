###########################################

## Title: GLS1_IsoPlotR
## Description: Attempting to reproduce age correction from Treble et al. 2022
## Date: 20240202
  ## Last edited: 20240202
## Contributors: M. Campbell
## Contacts: michelineleecampbell@gmail.com
## Notes: Thanks to Peter Vermeesch for solving my uncertainty problem! And writing the IsoPlotR package...

###########################################

# library(dplyr)
library(IsoplotR)

# data --------------------------------------------------------------------

test3 <- read.data(
  "CalculateUThCorrections/test2.csv",
  method = "Th-U", # method
  format = 2, # format of input data. 
  Th02i = c(0.33, 0.25), ## the initial 230/232 activity ratio
  ierr = 2 ## tells isoplotR the analytical uncertainty is 2-sigma. IsoplotR defaults to storing uncertainty at 1-sigma, if this is wrong you age uncertainty will be double what it should!
)


out <- age(
  test3,
  isochron = FALSE,
  Th0i = 3, #Th0i = 3 says to use assumed initial 230/232 activity ratio
  exterr = FALSE, # don't propagate the external error
  oerr = 2, #caculate output uncertainty as 2sigma absolute uncertainties
  sigdig = 2 # number of significant digits fir the uncertainty estimate
  )
out ## note that values presented in Treble et al. 2022 are ka BP 1950, while these are just ka BP.




