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
  
  titlePanel("resorttrafficR"),
  
  sidebarLayout(
    sidebarPanel(
      
      ## original UI calls for modules
      resortSelectionUI("resortSelect"),
      addressInputUI("addressInput"),
      # submitButtonUI("submitButton"),
      actionButton("submit1", "Try this one!")
      
    ),
    
    mainPanel(
      
      # display output
      verbatimTextOutput("resortaddressOutput"),

      # Add UI elements for displaying the travel times and map
      textOutput("travelTimeWithoutTraffic"),
      textOutput("travelTimeWithTraffic"),
      google_mapOutput("mapOutput", height = "400px") # Adjust size as needed
      
    )
  )
)

##### SERVER
server <- function(input, output, session) {
  
  selected_resort_reactive <- resortSelectionServer("resortSelect")
  user_address_reactive <- addressInputServer("addressInput")

  # original code
  # submit_address <- eventReactive(input$submit1, {
  #   resort_address <- get_resort_address(resort_name = selected_resort_reactive())
  #   return(resort_address)
  # })
  
  # new eventreactive with gmaps
  submit_address <- eventReactive(input$submit1, {
    
    user_address <- user_address_reactive()
    selected_resort <- selected_resort_reactive()
    resort_address <- get_resort_address(resort_name = selected_resort)

    if (!is.null(user_address) && !is.null(selected_resort)) {

      googleway::google_distance(origins = user_address,
                                 destinations = resort_address,
                                 mode = "driving",
                                 traffic_model = "pessimistic",
                                 departure_time = 'now',
                                 key = "AIzaSyCejTDMFe0MXq_B5CDMCQ5hfiX3GVlbzqw") # Replace with your actual API key
    } else {
      NULL
    }
    
  })
  
  output$resortaddressOutput <- renderPrint({
    submit_address()
  })
  
  # # Using eventReactive to handle the submit button action
  # submit_response <- eventReactive(input$submitButton, {
  #   selected_resort <- selected_resort_reactive()
  #   user_address <- user_address_reactive()
  # 
  #   if (!is.null(user_address) && !is.null(selected_resort)) {
  #     resort_address <- get_resort_address(resort_name = selected_resort)
  #     googleway::google_distance(origins = user_address,
  #                                destinations = resort_address,
  #                                mode = "driving",
  #                                traffic_model = "pessimistic",
  #                                departure_time = 'now',
  #                                key = "AIzaSyCejTDMFe0MXq_B5CDMCQ5hfiX3GVlbzqw") # Replace with your actual API key
  #   } else {
  #     NULL
  #   }
  # })

  # Update the UI elements based on the response from submit_response
  output$travelTimeWithoutTraffic <- renderText({
    if (!is.null(submit_address())) {
      submit_address()$rows$elements[[1]]$duration$text
    }
  })

  output$travelTimeWithTraffic <- renderText({
    if (!is.null(submit_address())) {
      submit_address()$rows$elements[[1]]$duration_in_traffic$text
    }
  })

  output$mapOutput <- renderGoogle_map({
    if (!is.null(submit_address())) {
      google_map(data = submit_address(), key = "AIzaSyCejTDMFe0MXq_B5CDMCQ5hfiX3GVlbzqw") # Replace with your actual API key
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
