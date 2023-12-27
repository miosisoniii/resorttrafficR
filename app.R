## app.R

## load dependencies
require(shiny)
require(googleway)

## source inputVars to get input selection vals
source("./helpers/helper02_inputvars.R")
source("./R/get_resort_address.R")


## UI --------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Ski Resort Travel Time Calculator"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("resort",
                  "Choose a Ski Resort:",
                  choices = inputvar_resort),
      textInput("address", "Enter Your Starting Address:", 
                value = "101 14th Ave, Denver, CO 80204") # address of city hall
    ),
    mainPanel(
      textOutput("travelTime"),
      textOutput("travelTime_traffic")
    )
  )
)

## server ----------------------------------------------------------------------
server <- function(input, output) {
  
  ## googleMaps API key
  gmap_key <- "AIzaSyCejTDMFe0MXq_B5CDMCQ5hfiX3GVlbzqw"
  ## Set Google API key
  googleway::set_key(gmap_key)
  
  output$travelTime <- renderText({
    
    ## using get_resort_address fn
    resorts <- get_resort_address(resort_name = input$resort)
    
    # Get travel time
    if (input$address != "") {
      
      ## input using fn
      resort_address <- get_resort_address(resort_name = input$resort)
      
      result <- googleway::google_distance(origins = input$address,
                                           destinations = resort_address,
                                           mode = "driving",
                                           traffic_model = "pessimistic", 
                                           departure_time = 'now',
                                           key = gmap_key)
      
      if (result$status == "OK") {
        # travel_time <- result$rows$elements[[1]]$duration$text
        travel_time_traffic <- result$rows$elements[[1]]$duration_in_traffic$text
        # paste("Estimated travel time to", input$resort, "is", travel_time)
        paste("Estimated travel time (with traffic) to", input$resort, "is", travel_time_traffic)
        
      } else {
        paste("Error:", result$status)
      }
    } else {
      "Please enter your starting address."
    }
  })
}

shinyApp(ui, server)
