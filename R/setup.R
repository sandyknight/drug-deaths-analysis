library(openxlsx)
library(data.table)

source("R/get_drug_poisoning_deaths.R")

df <-
  get_drug_poisoning_deaths()
