#' Search opioid medication list
#'
#' @param med_name A single string specifying the medication name to search for.
#'
#' @returns 
#' A `data.frame` containing medications matching the `med_name` argument and 
#'     their associated conversion factor(s) (`cf`).
#'
#' @export
#' 
#' @examples
#' search_meds("oxy")
#' 
search_meds <- function(med_name = NULL) {
  
  # Check if med_name argument is specified
  if (is.null(med_name)) {
    cli::cli_abort("{.arg med_name} must be specified to use {.fn search_meds}")
  }
  
  # Base URL for the API
  base_url <- "https://research-mme.wakehealth.edu/api"

  httr2::request(glue::glue("{base_url}/by_name")) |>
    httr2::req_url_query(med_name = med_name) |>
    httr2::req_headers(accept = "application/json") |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}
