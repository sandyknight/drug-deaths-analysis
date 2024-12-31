# require(data.table)
# require(lubridate)

df <-
  data.table::fread("inst/extdata/raw/drug_deaths_data.csv")

df <- df[drug_group == "Total Deaths", ]

df <- df[, .(count = .N), by = .(dodyrmonth, dod_year, REGDATRS_NM)]

df[, dodyrmonth := base::paste0(dodyrmonth, "01")]

df[, dodyrmonth := base::as.Date(df$dodyrmonth, "%Y%m%d")]

df[, dodyrmonth := lubridate::rollforward(dodyrmonth)]

df <- df[dod_year < 2022, ]

# Mean monthly deaths
mmd <-
  base::mean(df$count)

# Standard deviation monthly deaths
sdmd <-
  stats::sd(df$count)

data.table::setorder(df, dodyrmonth)

df <- df[, .(dodyrmonth, count, REGDATRS_NM)]

## dfxts <- xts::as.xts(df, order.by = df$dodyrmonth)

## plot(dfxts)

## lines(TTR::EMA(x = dfxts[, "count"], n = 12), on = 1, col = "red")

## lines(TTR::SMA(x = dfxts[, "count"], n = 12), on = 1, col = "blue")

## addLegend("topleft",
##   on = 1,
##   legend.names = c("Deaths (n)","EMA (12)", "SMA(12)"),
##   lty = c(1,1,1),
##   lwd = c(2,1,1),
##   col = c("black", "red", "blue")
## )

df[, year := lubridate::year(dodyrmonth), ]

library(ggplot2)

df |>
  ggplot(aes(x = dodyrmonth)) +
  geom_point(aes(y = count)) +
  geom_line(aes(y = count)) +
  geom_line(aes(y = count)) +
  geom_line(aes(y = count)) +
  facet_wrap(~ REGDATRS_NM)
