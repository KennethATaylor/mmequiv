with_mock_dir("search_meds", {
  test_that("Returns data.frame", {
    oxy_list <- search_meds("oxy")
    expect_true(is.data.frame(oxy_list))
  })
  
  test_that("Able to retrieve all 6 medications with 'mcg' in the name", {
    mcg <- search_meds("mcg")
    expect_length(mcg$med_name, 6)
    expect_length(mcg$cf, 6)
  })
  
})

test_that("Provides error message when med_name is NULL", {
  expect_snapshot(
    error = TRUE,
    search_meds(med_name = NULL)
  )
})
