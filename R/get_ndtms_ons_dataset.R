#' Load NDTMS-ONS mortality linked dataset

get_ndtms_ons_dataset <-
  function() {
    if (file.exists("data/processed/ndtms_ons_dataset.csv")) {
      data.table::fread("data/processed/ndtms_ons_dataset.csv")
    } else {
      require(openxlsx)

      df <- openxlsx::read.xlsx("data/raw/ndtms_ons_data.xlsx", sheet = "NDTMS_ONS") |>
        janitor::clean_names()

      data.table::fwrite(df, "data/processed/ndtms_ons_dataset.csv")


      data.table::fread("data/processed/ndtms_ons_dataset.csv")
    }
  }
