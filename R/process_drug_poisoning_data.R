#' Process drug poisoning data
#'
#' Filters and groups the data and aggregates based on user-defined parameters: 'date of' years, and grouping columns (age, sex, area, and drug group, and misuse).
#'
#'' Date of' (`date_of`)
#' The data has both the year-month of death ("occurrence") and of registration of the death. Registration is preferable when looking for trends that include the latest dates available due to registration lag, In most other contexts occurrence is preferable.
#'
#' Misuse
#' Each observation is flagged as being recorded by the ONS as "related to drug misuse" or not. Set `misuse = TRUE` to filter out deaths that the ONS did not record as related to drug misuse.
#'
#' @param data a data frame, the output of get_drug_poisoning_deaths()
#' @param date_of Either "occurrence" (year of death) or "registration" (year of registration).
#' @param years An integer vector of years to include in the analysis.
#' @param group_by Grouping variable, any of: "area", "age", "sex", "drug", "misuse"
#' @return A data frame with a count of drug death occurrences or registrations, aggergated by the grouping variables and filtered by the selected years.
process_drug_poisoning_data <-
  function(data, date_of = "occurrence", years, group_by = "occurrence") {
    require(data.table)
    # Decide which date variable to use
    date_of_var <- switch(date_of,
      "occurrence" = "dod_year",
      "registration" = "reg_year",
      stop("Only 'occurrence' or 'registration' are valid options")
    )

    # Handle grouping variable(s)
    by_var <- dplyr::case_match(
      group_by,
      "occurrence" ~ "dod_year",
      "registration" ~ "reg_year",
      "area" ~ "dat_nm",
      "age" ~ "ageinyrs",
      "sex" ~ "sex",
      "drug" ~ "drug_group",
      "misuse" ~ "drug_misuse_combined"
    )

    by_var <- c(by_var, date_of_var)

    # Filter years
    data <- data[get(date_of_var) %in% years, ]
    # Count by groups
    data <- data[, .(count = .N), by = c(by_var)]

    return(data)
  }
