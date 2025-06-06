% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calculate_mme_df.R
\name{calculate_mme_df}
\alias{calculate_mme_df}
\title{Calculate MME for medication data in long format}
\usage{
calculate_mme_df(
  data,
  id_col = "patient_id",
  medication_col = "medication_name",
  dose_col = "dose",
  doses_per_day_col = "doses_per_24_hours",
  days_col = "days_of_medication",
  therapy_days_col = "therapy_days",
  observation_days_col = "observation_window_days",
  therapy_days_without_col = NULL,
  observation_days_without_col = NULL
)
}
\arguments{
\item{data}{A \code{data.frame} or \code{tibble} in long format with one row per
medication per patient or participant (\code{id_col})}

\item{id_col}{Name of the column containing patient identifier; default is
\code{"patient_id"}}

\item{medication_col}{Name of the column containing medication names; default
is \code{"medication_name"}}

\item{dose_col}{Name of the column containing dose values; default is
\code{"dose"}}

\item{doses_per_day_col}{Name of the column containing doses per 24 hours;
\code{"doses_per_24_hours"}}

\item{days_col}{Name of the column containing days of medication; default is
\code{"days_of_medication"}}

\item{therapy_days_col}{Name of the column containing therapy days with
buprenorphine (up to one unique value per patient); default is
\code{"therapy_days"}}

\item{observation_days_col}{Name of the column containing observation window
days with buprenorphine (up to one unique value per patient); default is
\code{"observation_window_days"}}

\item{therapy_days_without_col}{Name of the column containing therapy days
without buprenorphine (up to one unique value per patient). If \code{NULL}
(default), uses the value from \code{therapy_days_col}.}

\item{observation_days_without_col}{Name of the column containing observation
window days without buprenorphine (up to one unique value per patient).
If \code{NULL} (default), uses the value from \code{observation_days_col}.}
}
\value{
A list containing three elements:
\itemize{
\item \code{medications}: The original \code{data.frame} with added prescription-level
MME columns
\item \code{patient_summary_with_buprenorphine}: Patient-level MME summary including
buprenorphine
\item \code{patient_summary_without_buprenorphine}: Patient-level MME summary
excluding buprenorphine
}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}

This function takes medication data in long format (multiple rows per patient
ID), calculates MME using the local calculation method
(\code{\link[=calculate_mme_local]{calculate_mme_local()}}), and adds prescription-level values as new columns.
It also returns two additional data frames with patient-level MME summaries
(one with buprenorphine included and one without).
}
\examples{
library(dplyr)
# Calculate MME using long-format data
# Subset of opioid_trial data used for speedier example
mme <- calculate_mme_df(
  data = opioid_trial |> dplyr::filter(patient_id \%in\% sprintf("P\%03d", 1:100)),
  therapy_days_without_col = "therapy_days_without",
  observation_days_without_col = "observation_window_days_without"
  )
# ->
mme <- calculate_mme(
  x = opioid_trial |> dplyr::filter(patient_id \%in\% sprintf("P\%03d", 1:100)),
  therapy_days_without_col = "therapy_days_without",
  observation_days_without_col = "observation_window_days_without"
  )

head(mme$medications)

head(mme$patient_summary_with_buprenorphine)

head(mme$patient_summary_without_buprenorphine)

# Cleanup
rm(mme)

}
\seealso{
\code{\link[=calculate_mme_local]{calculate_mme_local()}}
}
\keyword{internal}
