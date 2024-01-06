## app.R

## load dependencies
library(shiny)
library(dplyr)
library(googleway)
library(purrr)

## source inputVars to get input selection vals
source("R/get_traveltime.R")
source("R/get_resort_address.R")
source("helpers/helper02_inputvars.R")

## source modules code
source("modules/pass_selection_module.R")
source("modules/resort_selection_module.R")
source("modules/address_input_module.R")
source("modules/resort_link_module.R")

## Modules Code ----------------------------------------------------------------

##### UI

ui <- fluidPage(
  
  titlePanel("resorttrafficR"),
  
  sidebarLayout(
    sidebarPanel(
      passSelectionUI("passSelect"),
      # resortSelectionUI("resortSelect"),
      addressInputUI("addressInput"),
      actionButton("submit2", "Get travel times!"),
    ),
    mainPanel(
      tableOutput("travelTimeTable"),
      resortLinkUI("resortLinkModule")
    )
  )
)

##### SERVER
server <- function(input, output, session) {
  
  # Reactive value to indicate if the table is ready
  table_ready <- reactiveVal(FALSE)
  
  selected_pass_reactive <- passSelectionServer("passSelect")
  selected_resort_reactive <- resortSelectionServer("resortSelect")
  user_address_reactive <- addressInputServer("addressInput")
  
  submit_traveltime <- eventReactive(input$submit2, {
    
    user_address <- user_address_reactive()
    selected_pass <- selected_pass_reactive()
    
    if(!is.null(user_address) && !is.null(selected_pass)) {
      pass_resorts <- resort_data %>% filter(NAME_PASS == selected_pass)
      table_traveltime <- get_traveltime_df(user_address = user_address, resort_df = pass_resorts) 
      
      ## set reactiveValue to TRUE
      table_ready(TRUE)
      return(table_traveltime)
      
      
    } else {
      NULL
    }
    
  })
  
  #### UI OUTPUTS --------------------------------------------------------------
  
  output$travelTimeTable <- renderTable({
    table_ready(TRUE)
    submit_traveltime() %>%
      dplyr::select(-NAME_PASS, -gmaps_obj, -TIME_VAL_TRAFFIC, -GMAP_LINK_RESORT, -ADDRESS_RESORT)
  })
  
  # Call the resort link server function and pass the reactive value
  resortLinkServer("resortLinkModule", submit_traveltime, table_ready)
  
}

shinyApp(ui, server)
  
  
  
  

  ##### Not Used ---------------------------------------------------------------
  
  ## may be useful later when selecting individual resorts
  # selected_pass_reactive <- passSelectionServer("passSelect")
  # selected_resort_reactive <- resortSelectionServer("resortSelect")
  # user_address_reactive <- addressInputServer("addressInput")
  # 
  # # new eventreactive with gmaps
  # submit_address <- eventReactive(input$submit1, {
  #   
  #   user_address <- user_address_reactive()
  #   selected_resort <- selected_resort_reactive()
  #   
  #   if (!is.null(user_address) && !is.null(selected_resort)) {
  #     
  #     get_traveltime(start_address = user_address,
  #                    resort_name = selected_resort)
  #     
  #   } else {
  #     NULL
  #   }
  #   
  # })
  
  # this may be useful when showing directions to the fastest resort
  # output$mapOutput <- renderGoogle_map({
  #   if (!is.null(submit_address())) {
  #     google_map(data = submit_address(), key = "AIzaSyCejTDMFe0MXq_B5CDMCQ5hfiX3GVlbzqw") # Replace with your actual API key
  #   }
  # })
  # 





