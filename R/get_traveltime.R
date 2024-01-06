## get_traveltime.R

## function for using google distance from GoogleMaps API

## required deps
require(googleway)

## get_traveltime function code
## inputs: user address
## inputs: target resort
## inputs: googlemaps key
## output: googleway obj
get_traveltime <- function(start_address = "101 14th Ave, Denver, CO 80204", # denver city hall
                           resort_name = "Winter Park", 
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


## extract_traveltime function
## input: gmaps_obj
## input: traffic
extract_traveltime <- function(gmaps_obj, traffic = FALSE) {
  
  if (traffic == FALSE) {
    gmaps_obj$rows$elements[[1]]$duration$text
  } else {
    gmaps_obj$rows$elements[[1]]$duration_in_traffic$text
  }
  
}

## extract_timeval function, to order without converting time
## input: gmaps_obj
## input: traffic
extract_timeval <- function(gmaps_obj, traffic = FALSE) {
  
  if (traffic == FALSE) {
    gmaps_obj$rows$elements[[1]]$duration$value
  } else {
    gmaps_obj$rows$elements[[1]]$duration_in_traffic$value
  }
  
}

## get_traveltime_table (wrapper) 
## input: user_address
## input: resort_df
## output: travel times dataframe
get_traveltime_df <- function(user_address, resort_df = resort_data) {
  resort_df %>%
    dplyr::mutate(
      gmaps_obj = map(NAME_RESORT, ~ get_traveltime(start_address = user_address, resort_name = .x)),
      TIME_NO_TRAFFIC = map_chr(gmaps_obj, ~ extract_traveltime(.x, traffic = FALSE)),
      TIME_TRAFFIC = map_chr(gmaps_obj, ~ extract_traveltime(.x, traffic = TRUE)),
      TIME_VAL_TRAFFIC = map_dbl(gmaps_obj, ~ extract_timeval(.x, traffic = TRUE))
    ) %>%
    dplyr::arrange(TIME_VAL_TRAFFIC)
}


