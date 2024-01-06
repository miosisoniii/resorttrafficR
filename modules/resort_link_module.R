## resort_directions_module.R

resortLinkUI <- function(id) {
  ns <- NS(id)
  uiOutput(ns("resortLinkUI"))  # Dynamic UI output
}

resortLinkServer <- function(id, filtered_resorts, table_ready) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Dynamically render the dropdown and link based on table_ready
    output$resortLinkUI <- renderUI({
      if (table_ready()) {
        tagList(
          selectInput(ns("resortDropdown"), "Select a Resort:", choices = filtered_resorts()$NAME_RESORT),
          actionButton(ns("openMap"), "Open in Google Maps"),
          uiOutput(ns("linkOutput"))  # Output for the hyperlink
        )
      }
    })
    
    # Observe changes in the filtered list and update the dropdown choices
    observe({
      if (table_ready()) {
        updateSelectInput(session, "resortDropdown", choices = filtered_resorts()$NAME_RESORT)
      }
    })
    
    # Observe button click to render hyperlink
    observeEvent(input$openMap, {
      selected_resort <- input$resortDropdown
      if (!is.null(selected_resort)) {
        resort_link <- filtered_resorts() %>%
          filter(NAME_RESORT == selected_resort) %>%
          pull(GMAP_LINK_RESORT)
        if (!is.null(resort_link)) {
          output$linkOutput <- renderUI({
            tags$a(href = resort_link, "Open in Google Maps", target = "_blank")
          })
        }
      }
    })
  })
}