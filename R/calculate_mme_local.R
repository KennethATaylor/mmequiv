#' @rdname calculate_mme
calculate_mme_local <- function(therapy_days, observation_window_days, medications) {
  # Process therapy_days and observation_window_days to handle both single
  # Validate inputs
  # ------ Input validation for therapy_days ------
  if (is.numeric(therapy_days) && length(therapy_days) == 1) {
    
    if (therapy_days <= 0) {
      cli::cli_abort("The {.arg therapy_days} argument must be a positive number")
    }
    
    # Single value provided - use for both with and without
    therapy_days_with <- therapy_days
    therapy_days_without <- therapy_days
    
  } else if (is.numeric(therapy_days) && length(therapy_days) == 2) {
    
    if (therapy_days[1] <= 0 || therapy_days[2] <= 0) {
      cli::cli_abort("All values in {.arg therapy_days} must be positive numbers")
    }
    
    # Two values provided - use first for with, second for without
    therapy_days_with <- therapy_days[1]
    therapy_days_without <- therapy_days[2]
    
  } else {
    cli::cli_abort(c(
      "The {.arg therapy_days} argument must be either a single positive number or a vector of 2 positive numbers",
      "i" = "Use a vector of 2 numbers to set different values for MME calculations 'with buprenorphine' and 'without buprenorphine'",
      "i" = "Use a single number to apply the same value to both scenarios"
    ))
  }
  
  # ------ Input validation for observation_window_days ------
  if (is.numeric(observation_window_days) && length(observation_window_days) == 1) {
    
    if (observation_window_days <= 0) {
      cli::cli_abort("The {.arg observation_window_days} argument must be a positive number")
    }
    
    # Single value provided - use for both with and without
    observation_window_days_with <- observation_window_days
    observation_window_days_without <- observation_window_days
    
  } else if (is.numeric(observation_window_days) && length(observation_window_days) == 2) {
    
    if (observation_window_days[1] <= 0 || observation_window_days[2] <= 0) {
      cli::cli_abort("All values in {.arg observation_window_days} must be positive numbers")
    }
    
    # Two values provided - use first for with, second for without
    observation_window_days_with <- observation_window_days[1]
    observation_window_days_without <- observation_window_days[2]
    
  } else {
    cli::cli_abort(c(
      "The {.arg observation_window_days} argument must be either a single positive number or a vector of 2 positive numbers",
      "i" = "Use a vector of 2 numbers to set different values for MME calculations 'with buprenorphine' and 'without buprenorphine'",
      "i" = "Use a single number to apply the same value to both scenarios"
    ))
  }
  
  if (length(medications) == 0) {
    cli::cli_abort("The {.arg medications} argument must be a non-empty {.cls list}")
  }
  if (!is.list(medications)) {
    cli::cli_abort(c(
      "The {.arg medications} argument must be a {.cls list}",
      "x" = "You've supplied a {.cls {class(medications)}}"
    ))
  }
  
  # Use the internal package data with saved med list
  valid_med_names <- med_list$med_name
  
  # Validate each medication in the list
  required_fields <- c("medication_name", "dose", "doses_per_24_hours", "days_of_medication")
  
  for (i in seq_along(medications)) {
    med <- medications[[i]]
    
    # Check if it's a list
    if (!is.list(med)) {
      cli::cli_abort(c(
        "Element {i} in {.arg medications} must be a {.cls list}",
        "x" = "You've supplied a {.cls {class(med)}}"
      ))
    }
    
    # Check for required fields
    missing_fields <- setdiff(required_fields, names(med))
    if (length(missing_fields) > 0) {
      cli::cli_abort("Element {i} in {.arg medications} is missing required fields: {.field {missing_fields}}")
    }
    
    # Validate field types
    if (!is.character(med$medication_name) || length(med$medication_name) != 1) {
      cli::cli_abort("Element {i} in {.arg medications}: {.field medication_name} must be a single {.cls character} string")
    }
    
    if (length(valid_med_names) > 0 && !med$medication_name %in% valid_med_names) {
      cli::cli_abort(c(
        "Element {i} in {.arg medications}: {.field medication_name} {.val {med$medication_name}} is not a medication name accepted by the API",
        "i" = "Run {.fn get_med_list} to see the list of {.field medication_name}s accepted by the API"
      ))
    }
    
    if (!is.numeric(med$dose) || length(med$dose) != 1 || med$dose <= 0) {
      cli::cli_abort("Element {i} in {.arg medications}: {.field dose} must be a positive number")
    }
    
    if (!is.numeric(med$doses_per_24_hours) || length(med$doses_per_24_hours) != 1 || med$doses_per_24_hours <= 0) {
      cli::cli_abort("Element {i} in {.arg medications}: {.field doses_per_24_hours} must be a positive number")
    }
    
    if (!is.numeric(med$days_of_medication) || length(med$days_of_medication) != 1 || med$days_of_medication <= 0) {
      cli::cli_abort("Element {i} in {.arg medications}: {.field days_of_medication} must be a positive number")
    }
  }
  
  # Get conversion factors from internal package data
  cf_lookup <- stats::setNames(med_list$cf, med_list$med_name)
  
  # Calculate per-medication stats
  processed_meds <- lapply(medications, function(med) {
    # Get conversion factor for this medication
    factor <- cf_lookup[med$medication_name]

    # Calculate MMEs
    single_day_mme <- med$dose * med$doses_per_24_hours * factor
    mme <- single_day_mme * med$days_of_medication
    
    # Add calculated fields to the medication
    med$factor <- as.numeric(factor)
    med$mme <- as.numeric(mme)
    med$single_day_mme <- as.numeric(single_day_mme)
    return(med)
  })
  
  # Convert medications list to data frame for easier processing
  meds_df <- do.call(rbind, lapply(processed_meds, function(x) {
    data.frame(
      medication_name = x$medication_name,
      dose = x$dose,
      doses_per_24_hours = x$doses_per_24_hours,
      days_of_medication = x$days_of_medication,
      factor = x$factor,
      mme = x$mme,
      single_day_mme = x$single_day_mme,
      stringsAsFactors = FALSE
    )
  }))
  
  # Identify buprenorphine medications
  is_bupr <- grepl("buprenorphine", tolower(meds_df$medication_name), ignore.case = TRUE)
  
  # Calculate aggregates with buprenorphine
  total_mme_with <- sum(meds_df$mme)
  total_days_with <- sum(meds_df$days_of_medication)
  
  # Calculate MME definitions with buprenorphine
  mme1_with <- total_mme_with / total_days_with
  mme2_with <- total_mme_with / therapy_days_with
  mme3_with <- total_mme_with / observation_window_days_with
  mme4_with <- sum(meds_df$single_day_mme)
  
  # Calculate aggregates without buprenorphine (exclude buprenorphine meds)
  if (any(is_bupr)) {
    meds_df_no_bupr <- meds_df[!is_bupr, ]
    total_mme_without <- sum(meds_df_no_bupr$mme)
    total_days_without <- sum(meds_df_no_bupr$days_of_medication)
    mme4_without <- sum(meds_df_no_bupr$single_day_mme)
  } else {
    # If no buprenorphine meds, results are the same
    total_mme_without <- total_mme_with
    total_days_without <- total_days_with
    mme4_without <- mme4_with
  }
  
  # Calculate MME definitions without buprenorphine
  mme1_without <- total_mme_without / total_days_without
  mme2_without <- total_mme_without / therapy_days_without
  mme3_without <- total_mme_without / observation_window_days_without
  
  # Create a response object that matches API response structure exactly
  result <- list(
    message = "Processed medications (local calculation)",
    therapy_obs_window_with = list(
      therapy_days = therapy_days_with,
      observation_window_days = observation_window_days_with
    ),
    therapy_obs_window_without = list(
      therapy_days = therapy_days_without,
      observation_window_days = observation_window_days_without
    ),
    medications = meds_df,
    mme_definitions = list(
      with_buprenorphine = data.frame(
        total_mme = total_mme_with,
        total_days = total_days_with,
        mme1 = mme1_with,
        mme2 = mme2_with,
        mme3 = mme3_with,
        mme4 = mme4_with
      ),
      without_buprenorphine = data.frame(
        total_mme = total_mme_without,
        total_days = total_days_without,
        mme1 = ifelse(is.nan(mme1_without), NA_real_, mme1_without),
        mme2 = mme2_without,
        mme3 = mme3_without,
        mme4 = mme4_without
      )
    )
  )
  
  return(result)
}