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
search_meds <- function(med_name) {
  # Base URL for the API
  base_url <- "https://research-mme.wakehealth.edu/api"

  httr2::request(glue::glue("{base_url}/by_name")) |>
    httr2::req_url_query(med_name = med_name) |>
    httr2::req_headers(accept = "application/json") |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}
