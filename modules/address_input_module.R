##### UI

addressInputUI <- function(id) {
  ns <- NS(id)
  textInput(ns("address"), "Enter Your Address:", 
            value = "101 14th Ave, Denver, CO 80204") # address of Denver City Hall
}

##### SERVER

addressInputServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    user_address <- reactive({ input$address })
    
    return(user_address)
  })
}