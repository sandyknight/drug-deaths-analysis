#  This file is NDTMS-ONS data linkage. received by email from Stefan and
#  named: 'table1_all deaths_Cocaine version 1.xlsx'

get_drug_poisoning_deaths <- function() {
  if (!file.exists("inst/extdata/raw/drug_deaths_data.csv")) {
    # Load deaths data from Excel
    df <-
      openxlsx::read.xlsx("inst/extdata/raw/drugs_deaths_data.xlsx",
                          sheet = "table1_all deaths")

    # Write data to csv
    data.table::fwrite(df, "inst/extdata/raw/drug_deaths_data.csv")
  }

  # Return raw data
  data.table::fread("inst/extdata/raw/drug_deaths_data.csv")
}
