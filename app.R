## app.R

## load dependencies
require(shiny)
require(googleway)

## source inputVars to get input selection vals
source("R/get_traveltime.R")
source("./helpers/helper02_inputvars.R")
source("./R/get_resort_address.R")

## source modules code
source("modules/pass_selection_module.R")
source("modules/resort_selection_module.R")
source("modules/address_input_module.R")

## Modules Code ----------------------------------------------------------------

##### UI

ui <- fluidPage(
  
  titlePanel("resorttrafficR"),
  
  sidebarLayout(
    sidebarPanel(
      
      ## original UI calls for modules
      passSelectionUI("passSelect"),
      resortSelectionUI("resortSelect"),
      addressInputUI("addressInput"),
      actionButton("submit1", "Try this one!")
      
    ),
    
    mainPanel(
      
      # display output
      verbatimTextOutput("resortaddressOutput"),

      # Add UI elements for displaying the travel times and map
      textOutput("travelTimeWithoutTraffic"),
      textOutput("travelTimeWithTraffic"),
      # google_mapOutput("mapOutput", height = "400px") # Adjust size as needed
      
      ## get table output to display all travel times
      tableOutput("travelTimeTable")
      
    )
  )
)

##### SERVER
server <- function(input, output, session) {
  
  selected_pass_reactive <- passSelectionServer("passSelect")
  selected_resort_reactive <- resortSelectionServer("resortSelect")
  user_address_reactive <- addressInputServer("addressInput")

  # new eventreactive with gmaps
  submit_address <- eventReactive(input$submit1, {
    
    user_address <- user_address_reactive()
    selected_resort <- selected_resort_reactive()

    if (!is.null(user_address) && !is.null(selected_resort)) {
      
      get_traveltime(start_address = user_address,
                     resort_name = selected_resort)
      
    } else {
      NULL
    }
    
  })
  
  
  
  
  
  
  #### UI OUTPUTS --------------------------------------------------------------
  
  output$resortaddressOutput <- renderPrint({
    submit_address()
  })
  
  output$travelTimeTable <- renderTable({
    submit_address()
  })
  
  # Update the UI elements based on the response from submit_address
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

  # this may be useful when showing directions to the fastest resort
  # output$mapOutput <- renderGoogle_map({
  #   if (!is.null(submit_address())) {
  #     google_map(data = submit_address(), key = "AIzaSyCejTDMFe0MXq_B5CDMCQ5hfiX3GVlbzqw") # Replace with your actual API key
  #   }
  # })
  # 
}

shinyApp(ui, server)




