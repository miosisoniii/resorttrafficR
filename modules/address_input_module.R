##### UI

addressInputUI <- function(id) {
  ns <- NS(id)
  textInput(ns("address"), "Enter Your Address:", value = "")
}

##### SERVER

addressInputServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    user_address <- reactive({ input$address })
    
    return(user_address)
  })
}