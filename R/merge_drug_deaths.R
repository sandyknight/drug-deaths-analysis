source("R/get_drug_poisoning_deaths.R")
source("R/process_drug_poisoning_data.R")
source("R/get_non_poisoning_deaths.R")
source("R/process_non_poisoning_data.R")


poisoning_deaths <-
  process_drug_poisoning_data(data = get_drug_poisoning_deaths(), misuse = FALSE)

poisoning_deaths[, category := "ONS drug misuse deaths"]


non_poisoning_deaths <-
  process_non_poisoning_data()

non_poisoning_deaths
