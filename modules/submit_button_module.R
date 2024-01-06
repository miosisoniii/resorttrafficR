##### UI

submitButtonUI <- function(id) {
  ns <- NS(id)
  actionButton(ns("submit"), "Check Traffic Times!")
}

##### SERVER

submitButtonServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # This module might not need a reactive expression but is triggered by an observeEvent in the main server
  })
}


# AIzaSyCejTDMFe0MXq_B5CDMCQ5hfiX3GVlbzqw