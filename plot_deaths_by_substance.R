R.utils::sourceDirectory("R")

df <-
  get_drug_poisoning_deaths()


df <-
  process_drug_poisoning_data(data = df,
                              date_of = "occurrence",
                              years = NULL, groups = c("sex", "ageinyrs"))





df1 <- df[order(-count), .SD[1:10], by = dod_year]

df1 |>:w 

