data <-
    clean_ndtms_ons_data(get_ndtms_ons_dataset())

#' Summarise NDTMS-ONS linked dataset
#'
#' @param data the output of clean_ndtms_ons_dataset()
#' @param years numeric vector of years to select
#' @param group_by area, death_cause, age, age_group, sex
summarise_ndtms_ons_data <-
    function(data, years, group_by) {
        require(data.table)
        require(testthat)
       data <- data[year %in% years, ]
    }

# Test that the input data is has been cleaned

nrow(data[area_name == "England"]) == 0
"year" %in% colnames(data)
"agegrp" %notin% colnames(data)

testthat::test_that(
              testthat::expect_true(nrow(data[area_name == "England"]) == 0,
                                    "agegrp" %notin% colnames(data))
          )
