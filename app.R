## app.R

## load dependencies
library(shiny)
library(googleway)

## googleMaps API key
gmap_key <- "AIzaSyCejTDMFe0MXq_B5CDMCQ5hfiX3GVlbzqw"

## Set your Google API key
set_key(gmap_key)

## source inputVars to get input selection vals
source("./helpers/helper02_inputvars.R")


## UI --------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Ski Resort Travel Time Calculator"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("resort",
                  "Choose a Ski Resort:",
                  choices = inputvar_resort),
      textInput("address", "Enter Your Starting Address:", value = "Your address here")
    ),
    mainPanel(
      textOutput("travelTime")
    )
  )
)

## server ----------------------------------------------------------------------
server <- function(input, output) {
  
  output$travelTime <- renderText({
    # Define resort addresses (these should be accurate)
    resorts <- c("Winter Park" = , 
                 "Copper" = "address_of_copper", 
                 "Eldora" = "address_of_eldora")
    
    # Get travel time
    if (input$address != "") {
      result <- google_distance(origins = input$address,
                                destinations = resorts[input$resort],
                                mode = "driving",
                                traffic_model = "pessimistic")
      
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
