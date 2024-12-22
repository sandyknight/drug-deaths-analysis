#' Clean NDTMS-ONS linked dataset
#'
#' Remove national data, reformat periods, remove geography and period integer columns
#'
#' @param data output of get_ndtms_ons_data()
#' @return data table with count of deaths during or following contact with the treatment system.
clean_ndtms_ons_data <-
  function(data) {
    require(data.table)
    # Remove country-level data
    data <- data[geography == "LA", ]
    # Re-format periods
    data[, year := stringr::str_extract(period_range, "\\d{4}")][, year:= as.integer(year)]
   # Select columns
    data <-
        data[, .(year, area_code, area_name, death_cause, age, agegrp, sex, drug_group, treatment_status, count)]
    # Rename age group column
    data.table::setnames(data, "agegrp", "age_group")

    return(data)
  }
