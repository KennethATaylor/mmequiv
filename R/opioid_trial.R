#' Opioid Trial Data
#'
#' Example (synthetic) data provided as an example of long format data to use
#'     with `calculate_mme_df()`.
#'
#' @format ## `opioid_trial`
#' A data frame with 2,371 rows and 9 columns:
#' \describe{
#'   \item{patient_id}{Patient identifier; includes 1000 separate patients}
#'   \item{medication_name}{Medication names of prescription opioids used by the patient}
#'   \item{dose}{Dosage of the medication}
#'   \item{doses_per_24_hours}{Number of daily doses for the medication}
#'   \item{days_of_medication}{Duration of medication in days}
#'   \item{therapy_days}{Sum of prescription duration (days) for across all of the patient's medications, but with each calendar day counted only ONCE}
#'   \item{observation_window_days}{study-defined fixed observation window of time, applied to all of the patient's medications}
#'   \item{therapy_days_without}{Sum of prescription duration (days) for across all of the patient's medications (excluding buprenorphine), but with each calendar day counted only ONCE}
#'   \item{observation_window_days_without}{study-defined fixed observation window of time, applied to all of the patient's medications (excluding buprenorphine)}
#' }
"opioid_trial"
