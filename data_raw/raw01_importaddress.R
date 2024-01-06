## import GoogleMaps resort data

## load deps
require("readr")

## read data
dat_path <- "./data_raw/resort_address.csv"
resort_dat <- readr::read_csv(file = dat_path)

## write RDA to /data
saveRDS(resort_dat, "./data/resort_address.rda")


