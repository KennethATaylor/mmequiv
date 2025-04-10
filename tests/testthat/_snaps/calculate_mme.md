# Provides error messages for invalid therapy_days and observation_window_days arguments

    Code
      calculate_mme("invalid", 5, meds_list)
    Condition
      Error in `calculate_mme()`:
      ! The `therapy_days` argument must be either a single positive number or a vector of 2 positive numbers
      i Use a vector of 2 numbers to set different values for MME calculations 'with buprenorphine' and 'without buprenorphine'
      i Use a single number to apply the same value to both scenarios

---

    Code
      calculate_mme(0, 5, meds_list)
    Condition
      Error in `calculate_mme()`:
      ! The `therapy_days` argument must be a positive number

---

    Code
      calculate_mme(-10, 5, meds_list)
    Condition
      Error in `calculate_mme()`:
      ! The `therapy_days` argument must be a positive number

---

    Code
      calculate_mme(10, "invalid", meds_list)
    Condition
      Error in `calculate_mme()`:
      ! The `observation_window_days` argument must be either a single positive number or a vector of 2 positive numbers
      i Use a vector of 2 numbers to set different values for MME calculations 'with buprenorphine' and 'without buprenorphine'
      i Use a single number to apply the same value to both scenarios

---

    Code
      calculate_mme(10, 0, meds_list)
    Condition
      Error in `calculate_mme()`:
      ! The `observation_window_days` argument must be a positive number

---

    Code
      calculate_mme(10, -5, meds_list)
    Condition
      Error in `calculate_mme()`:
      ! The `observation_window_days` argument must be a positive number

---

    Code
      calculate_mme(c(10, 0), 5, meds_list)
    Condition
      Error in `calculate_mme()`:
      ! All values in `therapy_days` must be positive numbers

---

    Code
      calculate_mme(c(10, -5), 5, meds_list)
    Condition
      Error in `calculate_mme()`:
      ! All values in `therapy_days` must be positive numbers

---

    Code
      calculate_mme(c(0, 10), 5, meds_list)
    Condition
      Error in `calculate_mme()`:
      ! All values in `therapy_days` must be positive numbers

---

    Code
      calculate_mme(c(-1, 10), 5, meds_list)
    Condition
      Error in `calculate_mme()`:
      ! All values in `therapy_days` must be positive numbers

---

    Code
      calculate_mme(10, c(5, 0), meds_list)
    Condition
      Error in `calculate_mme()`:
      ! All values in `observation_window_days` must be positive numbers

---

    Code
      calculate_mme(10, c(0, 5), meds_list)
    Condition
      Error in `calculate_mme()`:
      ! All values in `observation_window_days` must be positive numbers

---

    Code
      calculate_mme(10, c(-5, 5), meds_list)
    Condition
      Error in `calculate_mme()`:
      ! All values in `observation_window_days` must be positive numbers

---

    Code
      calculate_mme(c(10, 20, 30), 5, meds_list)
    Condition
      Error in `calculate_mme()`:
      ! The `therapy_days` argument must be either a single positive number or a vector of 2 positive numbers
      i Use a vector of 2 numbers to set different values for MME calculations 'with buprenorphine' and 'without buprenorphine'
      i Use a single number to apply the same value to both scenarios

---

    Code
      calculate_mme(10, c(5, 10, 15), meds_list)
    Condition
      Error in `calculate_mme()`:
      ! The `observation_window_days` argument must be either a single positive number or a vector of 2 positive numbers
      i Use a vector of 2 numbers to set different values for MME calculations 'with buprenorphine' and 'without buprenorphine'
      i Use a single number to apply the same value to both scenarios

# Provides error messages for invalid medications argument

    Code
      calculate_mme(10, 5, "not_a_list")
    Condition
      Error in `calculate_mme()`:
      ! The `medications` argument must be a <list>
      x You've supplied a <character>

---

    Code
      calculate_mme(10, 5, list())
    Condition
      Error in `calculate_mme()`:
      ! The `medications` argument must be a non-empty <list>

---

    Code
      calculate_mme(10, 5, list("not_a_medication_list"))
    Condition
      Error in `calculate_mme()`:
      ! Element 1 in `medications` must be a <list>
      x You've supplied a <character>

---

    Code
      calculate_mme(10, 5, bad_meds_missing_field)
    Condition
      Error in `calculate_mme()`:
      ! Element 1 in `medications` is missing required fields: medication_name

---

    Code
      calculate_mme(10, 5, bad_meds_name)
    Condition
      Error in `calculate_mme()`:
      ! Element 1 in `medications`: medication_name must be a single <character> string

---

    Code
      calculate_mme(10, 5, bad_meds_dose)
    Condition
      Error in `calculate_mme()`:
      ! Element 1 in `medications`: medication_name "Test Med" is not a medication name accepted by the API
      i Run `get_med_list()` to see the list of medication_names accepted by the API

---

    Code
      calculate_mme(10, 5, bad_meds_dose_negative)
    Condition
      Error in `calculate_mme()`:
      ! Element 1 in `medications`: medication_name "Test Med" is not a medication name accepted by the API
      i Run `get_med_list()` to see the list of medication_names accepted by the API

---

    Code
      calculate_mme(10, 5, bad_meds_doses_per_day)
    Condition
      Error in `calculate_mme()`:
      ! Element 1 in `medications`: medication_name "Test Med" is not a medication name accepted by the API
      i Run `get_med_list()` to see the list of medication_names accepted by the API

---

    Code
      calculate_mme(10, 5, bad_meds_days)
    Condition
      Error in `calculate_mme()`:
      ! Element 1 in `medications`: medication_name "Test Med" is not a medication name accepted by the API
      i Run `get_med_list()` to see the list of medication_names accepted by the API

# Validates medication names against known list

    Code
      calculate_mme(10, 5, invalid_medication)
    Condition
      Error in `calculate_mme()`:
      ! Element 1 in `medications`: medication_name "Not A Real Medication Name" is not a medication name accepted by the API
      i Run `get_med_list()` to see the list of medication_names accepted by the API

