test_that("Provides error messages for invalid therapy_days and observation_window_days arguments", {
  meds_list <- list(
    list(
      medication_name = "Buprenorphine buccal film (mcg) buccal",
      dose = 50,
      doses_per_24_hours = 2,
      days_of_medication = 5
    ),
    list(
      medication_name = "Hydrocodone (mg)",
      dose = 75,
      doses_per_24_hours = 3,
      days_of_medication = 10
    )
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme("invalid", 5, meds_list)
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme(0, 5, meds_list)
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme(-10, 5, meds_list)
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, "invalid", meds_list)
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, 0, meds_list)
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, -5, meds_list)
  )
  
  # New tests for vectors with 2 values
  expect_snapshot(
    error = TRUE,
    calculate_mme(c(10, 0), 5, meds_list)  # Second value is 0
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme(c(10, -5), 5, meds_list)  # Second value is negative
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme(c(0, 10), 5, meds_list)  # First value is 0
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme(c(-1, 10), 5, meds_list)  # First value is negative
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, c(5, 0), meds_list)  # Second value is 0
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, c(0, 5), meds_list)  # First value is 0
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, c(-5, 5), meds_list)  # First value is negative
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme(c(10, 20, 30), 5, meds_list)  # Three values instead of 1 or 2
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, c(5, 10, 15), meds_list)  # Three values instead of 1 or 2
  )
})

test_that("Accepts both single values and vectors of two values", {
  meds_list <- list(
    list(
      medication_name = "Buprenorphine buccal film (mcg) buccal",
      dose = 50,
      doses_per_24_hours = 2,
      days_of_medication = 5
    )
  )
  
  # Mock the API call to avoid actually making requests
  httptest2::with_mock_dir("calculate_mme", {
    # Test with single values for both parameters
    expect_no_error(
      calculate_mme(10, 5, meds_list)
    )
    
    # Test with vector for therapy_days and single value for observation_window_days
    expect_no_error(
      calculate_mme(c(10, 15), 5, meds_list)
    )
    
    # Test with single value for therapy_days and vector for observation_window_days
    expect_no_error(
      calculate_mme(10, c(5, 7), meds_list)
    )
    
    # Test with vectors for both parameters
    expect_no_error(
      calculate_mme(c(10, 15), c(5, 7), meds_list)
    )
  })
})

test_that("Provides error messages for invalid medications argument", {
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, 5, "not_a_list")
  )
  
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, 5, list())  # Empty list
  )
  
  # Test non-list element in medications
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, 5, list("not_a_medication_list"))
  )
  
  # Test missing required fields
  bad_meds_missing_field <- list(
    list(dose = 50, doses_per_24_hours = 2, days_of_medication = 5)  # Missing medication_name
  )
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, 5, bad_meds_missing_field)
  )
  
  # Test invalid medication_name type
  bad_meds_name <- list(
    list(
      medication_name = 123,  # Should be a string
      dose = 50,
      doses_per_24_hours = 2,
      days_of_medication = 5
    )
  )
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, 5, bad_meds_name)
  )
  
  # Test invalid dose type or value
  bad_meds_dose <- list(
    list(
      medication_name = "Test Med",
      dose = "50",  # Should be numeric
      doses_per_24_hours = 2,
      days_of_medication = 5
    )
  )
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, 5, bad_meds_dose)
  )
  
  bad_meds_dose_negative <- list(
    list(
      medication_name = "Test Med",
      dose = -50,  # Should be positive
      doses_per_24_hours = 2,
      days_of_medication = 5
    )
  )
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, 5, bad_meds_dose_negative)
  )
  
  # Test invalid doses_per_24_hours
  bad_meds_doses_per_day <- list(
    list(
      medication_name = "Test Med",
      dose = 50,
      doses_per_24_hours = "2",  # Should be numeric
      days_of_medication = 5
    )
  )
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, 5, bad_meds_doses_per_day)
  )
  
  # Test invalid days_of_medication
  bad_meds_days <- list(
    list(
      medication_name = "Test Med",
      dose = 50,
      doses_per_24_hours = 2,
      days_of_medication = 0  # Should be positive
    )
  )
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, 5, bad_meds_days)
  )
})

test_that("Validates medication names against known list", {
  # This will use the mocked data from httptest2
  valid_med_names <- httptest2::with_mock_dir("get_med_list", {
    get_med_list()$med_name
  })
  
  # Create a valid medication list using a known good name
  valid_medication <- list(
    list(
      medication_name = valid_med_names[1],  # Take the first valid name
      dose = 50,
      doses_per_24_hours = 2,
      days_of_medication = 5
    )
  )
  
  # Create an invalid medication name
  invalid_medication <- list(
    list(
      medication_name = "Not A Real Medication Name",
      dose = 50,
      doses_per_24_hours = 2,
      days_of_medication = 5
    )
  )
  
  # Test with valid medication - should not error
  httptest2::with_mock_dir("calculate_mme", {
    expect_no_error(calculate_mme(10, 5, valid_medication))
  })
  
  # Test with invalid medication - should error
  expect_snapshot(
    error = TRUE,
    calculate_mme(10, 5, invalid_medication)
  )
})