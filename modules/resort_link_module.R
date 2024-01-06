## resort_directions_module.R

resortLinkUI <- function(id) {
  ns <- NS(id)
  uiOutput(ns("resortLinkUI"))  # Dynamic UI output
}

resortLinkServer <- function(id, filtered_resorts, table_ready) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Dynamically render the dropdown and button based on table_ready
    output$resortLinkUI <- renderUI({
      if (table_ready()) {
        tagList(
          selectInput(ns("resortDropdown"), "Select a Resort:", choices = filtered_resorts()$NAME_RESORT),
          actionButton(ns("openMap"), "Open in Google Maps")
        )
      }
    })
    
    # Observe selection changes and update the dropdown choices
    observe({
      if (table_ready()) {
        updateSelectInput(session, "resortDropdown", choices = filtered_resorts()$NAME_RESORT)
      }
    })
    
    # Open the Google Maps link when the button is clicked
    observeEvent(input$openMap, {
      selected_resort <- input$resortDropdown
      if (!is.null(selected_resort)) {
        resort_link <- filtered_resorts() %>% 
          filter(NAME_RESORT == selected_resort) %>% 
          pull(GMAP_LINK_RESORT)
        if (!is.null(resort_link)) {
          utils::browseURL(resort_link)
        }
      }
    })
  })
}