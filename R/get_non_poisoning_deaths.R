#' Load NDTMS-ONS mortality linked dataset

get_non_poisoning_deaths <-
  function() {
    require(data.table)
    if (file.exists("inst/extdata/processed/non_poisoning_deaths_data.csv")) {
      df <- data.table::fread("inst/extdata/processed/non_poisoning_deaths_data.csv")
    } else {
      require(openxlsx)

      df <-
        openxlsx::read.xlsx("inst/extdata/raw/non_poisoning_deaths_data.xlsx",
                            sheet = "NDTMS_ONS",
                            detectDates = TRUE) |>
        janitor::clean_names()

      data.table::setDT(df)

      df[, period := base::as.Date(period, origin = "1899-12-30"), ]

      df <- df[death_cause != "Drug poisoning", ]

      data.table::fwrite(df, "inst/extdata/processed/non_poisoning_deaths_data.csv")

      df <- data.table::fread("inst/extdata/processed/non_poisoning_deaths_data.csv")
    }

    # Remove country-level df
    df <- df[geography == "LA", ]

    # Re-format periods
    df[
      , year := stringr::str_extract(period_range, "\\d{4}")
    ][
      , year := as.integer(year)
    ]

    # Select columns
    df <-
      df[, .(year,
             area_code,
             area_name,
             death_cause,
             age,
             agegrp,
             sex,
             drug_group,
             treatment_status,
             count
      )]

    # Rename age group column
    data.table::setnames(df, "agegrp", "age_group")


    return(df)

  }
