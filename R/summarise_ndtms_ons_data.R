
#' Summarise NDTMS-ONS linked dataset
#'
#' @param data the output of clean_ndtms_ons_dataset()
#' @param years numeric vector of years to select
#' @param groups area, death_cause, age, age_group, sex, treatment_status
summarise_ndtms_ons_data <-
    function(data, years, groups = c("year")) {
        require(data.table)
        # Check that the input data is has been cleaned
        if(nrow(data[area_name == "England"]) > 0 | "agegrp" %in% colnames(data)) {
          message("Data contains national-level rows or incorrect column names: has the data been cleaned using `clean_ndtms_ons_data()`?")
        }

        if ("year" %notin% colnames(data)) {
          message(glue::glue("`years` value(s) not found in data, make sure they are numeric. Available years: {unique(data$year)}"))
}

        data <- data[year %in% years, ]

        data <- data[, .(count = .N), by = groups]

        return(data)
    }
