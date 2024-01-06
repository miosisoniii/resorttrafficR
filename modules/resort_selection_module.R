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
                          "Crested Butte" = "Crested Butte",
                          "Vail" = "Vail",
                          "Beaver Creek" = "Beaver Creek",
                          "Wolf Creek" = "Wolf Creek"))
}

##### SERVER

resortSelectionServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # This can be expanded based on the requirements
    selected_resort <- reactive({ input$resort })
    
    return(selected_resort)
  })
}