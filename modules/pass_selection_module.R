##### UI

passSelectionUI <- function(id) {
  ns <- NS(id)
  selectInput(ns("pass"), "Choose a Pass:", 
              choices = c("Ikon" = "Ikon",
                          "Epic" = "Epic"))
}

##### SERVER

passSelectionServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # This can be expanded based on the requirements
    selected_pass <- reactive({ input$pass })
    
    return(selected_pass)
  })
}