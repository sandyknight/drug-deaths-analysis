library(openxlsx)
library(data.table)

source("src/get_drug_poisoning_deaths.R")

df  <-
  get_drug_poisoning_deaths()

