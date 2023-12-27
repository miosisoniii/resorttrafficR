## extract input vars 

## get input vars from resort address data
resort_data <- readRDS("./data/resort_address.rda")

## extract values from resort data
inputvar_pass <- unique(resort_data$NAME_PASS)
inputvar_resort <- unique(resort_data$NAME_RESORT)

## get index of target value (address)
# address_ind <- which(resort_data$NAME_RESORT == "Winter Park")
# address_selection <- resort_data$ADDRESS_RESORT[address_ind]

