#' Retrieve full opioid medication list
#'
#' @returns
#' A `data.frame` with full list of opioid medication names (`med_name`) that are compatible with the MME calculator along with their conversion factors (`cf`).
#'
#' @export
#' 
#' @examples
#' get_med_list()
#' 
get_med_list <- function() {
  # Base URL for the API
  base_url <- "https://research-mme.wakehealth.edu/api"

  httr2::request(glue::glue("{base_url}/all")) |>
    httr2::req_headers(accept = "application/json") |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}
