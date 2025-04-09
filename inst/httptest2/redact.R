function (response) {
  response |>
    # shorten URL
    gsub_response("https://research-mme.wakehealth.edu/", "", fixed = TRUE)
}