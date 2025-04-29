library(tibble)
library(dplyr)

# Set seed for reproducibility
set.seed(41225)

# List of all opioid medications
medications <- med_list$med_name

# Define realistic dose ranges
dose_ranges <- list(
  "Buprenorphine buccal film (mcg) buccal" = c(75, 900),
  "Buprenorphine patch (mcg/hr) transdermal" = c(5, 20),
  "Buprenorphine tablet/film (mg) sublingual" = c(2, 24),
  "butorphanol (mg)" = c(1, 4),
  "Codeine (mg)" = c(15, 60),
  "Dihydrocodeine (mg)" = c(30, 120),
  "Fentanyl buccal (mcg)" = c(100, 800),
  "Fentanyl nasal (mcg)" = c(100, 800),
  "Fentanyl oral (mcg)" = c(100, 1600),
  "Fentanyl patch (mcg/hr)" = c(12.5, 100),
  "Hydrocodone (mg)" = c(5, 10),
  "Hydrocodone LA (mg)" = c(10, 30),
  "Hydromorphone (mg)" = c(2, 8),
  "Hydromorphone (mg) LA" = c(8, 32),
  "Levorphanol tartrate (mg)" = c(2, 6),
  "Meperidine HCL (mg)" = c(50, 100),
  "Methadone (mg)" = c(5, 40),
  "Morphine (mg)" = c(15, 30),
  "Morphine (mg) LA" = c(15, 200),
  "Opium (mg)" = c(30, 60),
  "Oxycodone (mg)" = c(5, 30),
  "Oxycodone (mg) LA" = c(10, 80),
  "Oxymorphone (mg)" = c(5, 10),
  "Oxymorphone (mg) LA" = c(10, 40),
  "Pentazocine (mg)" = c(25, 50),
  "tapentadol (mg)" = c(50, 100),
  "tapentadol (mg) LA" = c(50, 250),
  "tramadol (mg)" = c(50, 100),
  "tramadol (mg) LA" = c(100, 300)
)

# Create an empty dataframe with all required columns
opioid_trial <- tibble(
  patient_id = character(),
  medication_name = character(),
  dose = numeric(),
  doses_per_24_hours = numeric(),
  days_of_medication = numeric(),
  therapy_days = numeric(),
  observation_window_days = numeric(),
  therapy_days_without = numeric(),
  observation_window_days_without = numeric()
)

# Common opioids that should appear more frequently
common_opioids <- c(
  "Hydrocodone (mg)",
  "Oxycodone (mg)",
  "Morphine (mg)",
  "tramadol (mg)",
  "Codeine (mg)"
)

# Generate 1000 patients
n_patients <- 1000

for (pid in 1:n_patients) {
  # Determine number of medications for this patient (1-5)
  n_meds <- sample(1:5, 1, prob = c(0.3, 0.3, 0.2, 0.1, 0.1))

  # Weight common opioids to appear more frequently
  weights <- rep(1, length(medications))
  common_indices <- match(common_opioids, medications)
  common_indices <- common_indices[!is.na(common_indices)]
  weights[common_indices] <- 5

  # Sample medications for this patient
  med_indices <- sample(
    1:length(medications),
    n_meds,
    prob = weights,
    replace = FALSE
  )
  patient_meds <- medications[med_indices]

  # Generate data for each medication
  for (med in patient_meds) {
    # Get appropriate dose range
    range <- dose_ranges[[med]]

    # Generate dose based on medication type
    if (grepl("mcg", med) && !grepl("patch", med)) {
      # For mcg medications that aren't patches, use multiples of 50 or 100
      possible_doses <- seq(range[1], range[2], by = 50)
      dose <- sample(possible_doses, 1)
    } else if (grepl("patch", med)) {
      # For patches, use standard increments
      possible_doses <- c(5, 7.5, 10, 12.5, 15, 20, 25, 30, 37.5, 50, 75, 100)
      possible_doses <- possible_doses[
        possible_doses >= range[1] & possible_doses <= range[2]
      ]
      dose <- sample(possible_doses, 1)
    } else {
      # For mg medications, use appropriate increments
      by_val <- if (max(range) <= 10) 2.5 else if (max(range) <= 30) 5 else if (
        max(range) <= 100
      )
        10 else 25
      possible_doses <- seq(range[1], range[2], by = by_val)
      dose <- sample(possible_doses, 1)
    }

    # Generate doses per day (frequency)
    doses_per_day <- if (grepl("LA|patch", med)) {
      sample(c(1, 2), 1, prob = c(0.7, 0.3)) # LA meds usually once or twice daily
    } else {
      sample(1:4, 1, prob = c(0.1, 0.3, 0.4, 0.2)) # Regular meds 1-4 times daily
    }

    # Generate days of medication
    days <- if (grepl("LA|patch", med)) {
      sample(
        c(7, 14, 28, 30, 60, 90),
        1,
        prob = c(0.1, 0.2, 0.3, 0.2, 0.1, 0.1)
      )
    } else {
      sample(c(3, 5, 7, 10, 14, 30), 1, prob = c(0.1, 0.1, 0.3, 0.2, 0.2, 0.1))
    }

    # Calculate observation and therapy days
    observation_window_days <- max(30, round(days * 1.5))
    therapy_days <- days

    # For patients with buprenorphine, create separate without_buprenorphine values
    has_buprenorphine <- any(grepl("Buprenorphine", patient_meds))

    if (has_buprenorphine) {
      therapy_days_without <- max(1, therapy_days - sample(1:5, 1))
      observation_window_days_without <- max(
        therapy_days_without,
        observation_window_days - sample(1:10, 1)
      )
    } else {
      therapy_days_without <- therapy_days
      observation_window_days_without <- observation_window_days
    }

    # Add a row to the result
    opioid_trial <- opioid_trial %>%
      add_row(
        patient_id = paste0("P", sprintf("%03d", pid)),
        medication_name = med,
        dose = dose,
        doses_per_24_hours = doses_per_day,
        days_of_medication = days,
        therapy_days = therapy_days,
        observation_window_days = observation_window_days,
        therapy_days_without = therapy_days_without,
        observation_window_days_without = observation_window_days_without
      )
  }
}

# View the first few rows
# head(opioid_trial)

# Count rows per medication type
# med_counts <- opioid_trial %>%
#   count(medication_name) %>%
#   arrange(desc(n))
# print(med_counts)

# Get basic stats
# summary_stats <- opioid_trial %>%
#   summarize(
#     total_records = n(),
#     unique_patients = n_distinct(patient_id),
#     avg_meds_per_patient = n() / n_distinct(patient_id),
#     min_dose = min(dose),
#     max_dose = max(dose)
#   )
# print(summary_stats)

usethis::use_data(opioid_trial, overwrite = TRUE)
