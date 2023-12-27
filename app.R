
# googleMaps API key
gmap_key <- "AIzaSyCejTDMFe0MXq_B5CDMCQ5hfiX3GVlbzqw"


library(shiny)
library(googleway)

# Set your Google API key
set_key(gmap_key)

ui <- fluidPage(
  titlePanel("Ski Resort Travel Time Calculator"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("resort",
                  "Choose a Ski Resort:",
                  choices = c("Winter Park", "Copper", "Eldora")),
      textInput("address", "Enter Your Starting Address:", value = "Your address here")
    ),
    mainPanel(
      textOutput("travelTime")
    )
  )
)

server <- function(input, output) {
  
  output$travelTime <- renderText({
    # Define resort addresses (these should be accurate)
    resorts <- c("Winter Park" = "address_of_winter_park", 
                 "Copper" = "address_of_copper", 
                 "Eldora" = "address_of_eldora")
    
    # Get travel time
    if (input$address != "") {
      result <- google_distance(origins = input$address,
                                destinations = resorts[input$resort],
                                mode = "driving")
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
