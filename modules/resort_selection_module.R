##### UI

resortSelectionUI <- function(id) {
  ns <- NS(id)
  selectInput(ns("resort"), "Choose a Resort:", 
              choices = c("Eldora" = "Eldora", 
                          "Winter Park" = "Winter Park", 
                          "Copper" = "Copper", 
                          "Steamboat" = "Steamboat", 
                          "Aspen" = "Aspen", 
                          "Breckenridge" = "Breckenridge", 
                          "Keystone" = "Keystone", 
                          "Crested Butte" = "Crested Butte"))
}

##### SERVER

resortSelectionServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # This can be expanded based on the requirements
    selected_resort <- reactive({ input$resort })
    
    # use get_resort_address
    # selected_resort_address <- get_resort_address(resort_name = selected_resort())
    
    return(selected_resort)
  })
}