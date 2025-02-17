#' Process deaths in treatment data
#'
#' Reads and processes data about deaths in treatment. Filters, groups, and summarizes the data
#' based on various parameters.
#'
#' @param data A data frame produced by `get_non_poisoning_deaths`
#' @param years Vector of years to include in the analysis.
#' @param by Grouping variable: "area_name", "age", "sex", "death_cause", or NULL. Always grouped by year
#' @param by_treatment_status Whether to group by treatment status.
#' @param substance_group Drugs only ("drugs"), alcohol only ("alcohol"), or both ("both")
#' @return A data table with grouped and summarised treatment data.
process_non_poisoning_data <- function(data,
                                       years = c(2021, 2022),
                                       by = NULL,
                                       by_treatment_status = TRUE,
                                       substance_group = "drugs") {
  require(data.table)
  require(lubridate)

  # Always group by year
  grouping_vars <- c("year", by)


  # Add grouping for treatment status if requested, excluded by default
  if (isTRUE(by_treatment_status)) {
    grouping_vars <- c(grouping_vars, "treatment_status")
  }

  switch(substance_group,
    "drugs" = {
      # Exclude alcohol-only clients AND alcohol-specific deaths

      data <- data[
        death_cause != "Alcohol-specific death" &
          "drug_group" != "alcohol_only",
      ]

      message("> process_non_poisoning_data(): \033[1;32mAlcohol-specific deaths and alcohol only clients have been excluded\033[0m ")
    },
    "alcohol" = {
      # Exclude all those not alcohol-specific deaths or treated for alcohol only

      data <- data[death_cause == "Alcohol-specific death" | drug_group == "alcohol only", ]


      message("\033[1;32m > Non-alcohol-specific deaths and treated for substsances other than alcohol have been exlcuded\033[0m")
    },
    "both" = {
      data
    }
  )
  # Filter to chosen years
  data <- data[year %in% years, ]

  # Group and summarise data
  data[, .(count = .N), by = grouping_vars]

  # If grouped by sex column, standardise sex coding

  if ("sex" %in% colnames(data)) {
    data[, sex := tolower(sex)]
  }

  # Aggregate

  data <- data[, .(count = sum(count)), by = grouping_vars]

  return(data)
}
