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
      textOutput("travelTime")
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
    # Define resort addresses (these should be accurate)
    # resorts <- c("Winter Park" = "address_of_winterpark", 
    #              "Copper" = "address_of_copper", 
    #              "Eldora" = "address_of_eldora")
    
    ## using get_resort_address fn
    resorts <- get_resort_address(resort_name = input$resort)
    
    # Get travel time
    if (input$address != "") {
      
      ## input using fn
      resort_address <- get_resort_address(resort_name = input$resort)
      
      result <- googleway::google_distance(origins = input$address,
                                           # destinations = resorts[input$resort], # original
                                           # using function
                                           destinations = resort_address,
                                           mode = "driving",
                                           traffic_model = "pessimistic", 
                                           departure_time = 'now',
                                           key = gmap_key)
      
      if (result$status == "OK") {
        travel_time <- result$rows$elements$duration$text
        paste("Estimated travel time to", input$resort, "is", travel_time)
      } else {
        paste("Error:", result$status)
      }
    } else {
      "Please enter your starting address."
    }
  })
}

shinyApp(ui, server)
