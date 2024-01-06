## get_traveltime.R

## function for using google distance from GoogleMaps API

## required deps
require(googleway)

## function code
## inputs: user address
## inputs: target resort
## inputs: googlemaps key
## output: googleway obj
get_traveltime <- function(start_address, 
                           resort_name, 
                           gmaps_key = "AIzaSyCejTDMFe0MXq_B5CDMCQ5hfiX3GVlbzqw") {
  
  ## get address from get_resort_address fn
  resort_address <- get_resort_address(resort_name = resort_name)
  
  gmaps_obj <- googleway::google_distance(origins = start_address,
                                          destinations = resort_address,
                                          mode = "driving",
                                          traffic_model = "pessimistic",
                                          departure_time = 'now',
                                          key = gmaps_key) 
  
  return(gmaps_obj)
}