## app.R

## load dependencies
require(shiny)
require(googleway)

## source inputVars to get input selection vals
source("./helpers/helper02_inputvars.R")
source("./R/get_resort_address.R")


## Modules Code ----------------------------------------------------------------

##### UI
source("modules/resort_selection_module.R")
source("modules/address_input_module.R")
source("modules/submit_button_module.R")

ui <- fluidPage(
  
  resortSelectionUI("resortSelect"),
  addressInputUI("addressInput"),
  submitButtonUI("submitButton"),
  
  # Add UI elements for displaying the travel times and map
  textOutput("travelTimeWithoutTraffic"),
  textOutput("travelTimeWithTraffic"),
  google_mapOutput("mapOutput", height = "400px") # Adjust size as needed
  
)


##### SERVER
server <- function(input, output, session) {
  
  # Calling module server functions and storing the returned reactive expressions
  selected_resort_reactive <- resortSelectionServer("resortSelect")
  user_address_reactive <- addressInputServer("addressInput")
  
  observeEvent(input$submitButton, {
    # Accessing the reactive values
    selected_resort <- selected_resort_reactive()
    user_address <- user_address_reactive()
    
    if (!is.null(user_address) && !is.null(selected_resort)) {
      print(paste("Address:", user_address, "Resort:", selected_resort)) # Debugging statement
      
      # Assuming get_resort_address returns the address of the resort
      resort_address <- get_resort_address(resort_name = selected_resort)
      result <- googleway::google_distance(origins = user_address,
                                           destinations = resort_address,
                                           mode = "driving",
                                           traffic_model = "pessimistic", 
                                           departure_time = 'now',
                                           key = "AIzaSyCejTDMFe0MXq_B5CDMCQ5hfiX3GVlbzqw") # Replace with your actual API key
      
      if (result$status == "OK") {
        travel_time_without_traffic <- result$rows$elements[[1]]$duration$text
        travel_time_with_traffic <- result$rows$elements[[1]]$duration_in_traffic$text
        
        output$travelTimeWithoutTraffic <- renderText({ travel_time_without_traffic })
        output$travelTimeWithTraffic <- renderText({ travel_time_with_traffic })
        
        output$mapOutput <- renderGoogle_map({
          google_map(data = result, key = "AIzaSyCejTDMFe0MXq_B5CDMCQ5hfiX3GVlbzqw") # Replace with your actual API key
        })
      } else {
        print(paste("API Error:", result$status)) # Debugging statement
        output$travelTimeWithTraffic <- renderText({ paste("Error:", result$status) })
        output$travelTimeWithoutTraffic <- renderText({ "" })
      }
    }
  })
}

shinyApp(ui, server)




# ## UI --------------------------------------------------------------------------
# ui <- fluidPage(
#   titlePanel("Ski Resort Travel Time Calculator"),
#   
#   sidebarLayout(
#     sidebarPanel(
#       selectInput("resort",
#                   "Choose a Ski Resort:",
#                   choices = inputvar_resort),
#       textInput("address", "Enter Your Starting Address:", 
#                 value = "101 14th Ave, Denver, CO 80204") # address of city hall
#     ),
#     mainPanel(
#       textOutput("travelTime"),
#       textOutput("travelTime_traffic")
#     )
#   )
# )
# 
# ## server ----------------------------------------------------------------------
# server <- function(input, output) {
#   
#   ## googleMaps API key
#   # gmap_key <- "KEY"
#   ## Set Google API key
#   googleway::set_key(gmap_key)
#   
#   output$travelTime <- renderText({
#     
#     ## using get_resort_address fn
#     resorts <- get_resort_address(resort_name = input$resort)
#     
#     # Get travel time
#     if (input$address != "") {
#       
#       ## input using fn
#       resort_address <- get_resort_address(resort_name = input$resort)
#       
#       result <- googleway::google_distance(origins = input$address,
#                                            destinations = resort_address,
#                                            mode = "driving",
#                                            traffic_model = "pessimistic", 
#                                            departure_time = 'now',
#                                            key = gmap_key)
#       
#       if (result$status == "OK") {
#         # travel_time <- result$rows$elements[[1]]$duration$text
#         travel_time_traffic <- result$rows$elements[[1]]$duration_in_traffic$text
#         # paste("Estimated travel time to", input$resort, "is", travel_time)
#         paste("Estimated travel time (with traffic) to", input$resort, "is", travel_time_traffic)
#         
#       } else {
#         paste("Error:", result$status)
#       }
#     } else {
#       "Please enter your starting address."
#     }
#   })
# }
# 
# shinyApp(ui, server)
