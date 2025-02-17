merge_alcohol_deaths <- function() {
  # Download the ONS alcohol-specific death data
  ons_alcohol_specifc_deaths <-
    get_ons_alcohol_specific_deaths()

  # Give the rows a cause of death
  ons_alcohol_specifc_deaths[, death_cause := "Alcohol-specific death"]

  # Get the alcohol related deaths from NDTMS data
  df <-
    process_non_poisoning_data(
      data = get_non_poisoning_deaths(),
      substance_group = "alcohol",
      by = c("age", "sex", "death_cause")
    )

  # We want to exlcude alcohol-specific deaths
  # because those will have been counted in the
  # ONS figures; and deaths one or more years
  # after discharge.
  df <-
    df[death_cause != "Alcohol-specific death", ][treatment_status != "Died one or more years following discharge"]



  ## Make a lookup table for the ONS age groups
  age_group_lkp <- data.table(
    age_group = c(
      "<1",
      "01-04",
      "05-09",
      "10-14",
      "15-19",
      "20-24",
      "25-29",
      "30-34",
      "35-39",
      "40-44",
      "45-49",
      "50-54",
      "55-59",
      "60-64",
      "65-69",
      "70-74",
      "75-79",
      "80-84",
      "85-89",
      "90+"
    ),
    min_age = c(-Inf, 1, seq(5, 85, 5), 90),
    max_age = c(0, seq(4, 89, 5), Inf)
  )

  # Now we can use the lookup table to do a non-equi join
  df <-
    df[age_group_lkp,
      on = .(age >= min_age, age <= max_age),
      age_group := i.age_group
    ]

  # Aggregate
  df <-
    df[, .(count = sum(count)), by = .(sex, age_group, death_cause)]

  # Stack our two datasets
  df <-
    data.table::rbindlist(
      l = list(
        ons_alcohol_specifc_deaths,
        df
      ),
      use.names = TRUE
    )

  return(df)
}
library(ggplot2)


ggplot(df, aes(x = age_group, y = count)) +
  geom_col(aes(fill = death_cause)) +
  facet_wrap(~ sex)
