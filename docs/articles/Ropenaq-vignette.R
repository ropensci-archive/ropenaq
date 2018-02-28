## ---- echo = FALSE, warning=FALSE, message=FALSE-------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = NOT_CRAN,
  eval = NOT_CRAN
)

## ---- warning=FALSE, message=FALSE---------------------------------------
library("ropenaq")
countries_table <- aq_countries()
library("knitr")
kable(countries_table)
attr(countries_table, "meta")
attr(countries_table, "timestamp")

## ---- cache=FALSE--------------------------------------------------------
cities_table <- aq_cities()
kable(head(cities_table))

## ---- cache=FALSE--------------------------------------------------------
cities_tableIndia <- aq_cities(country="IN", limit = 10, page = 1)
kable(cities_tableIndia)

## ---- error=TRUE---------------------------------------------------------
#aq_cities(country="PANEM")

## ---- cache=FALSE--------------------------------------------------------
locations_chennai <- aq_locations(country = "IN", city = "Chennai", parameter = "pm25")
kable(locations_chennai)

## ---- cache=FALSE--------------------------------------------------------
results_table <- aq_measurements(country = "IN", city = "Delhi", parameter = "pm25", limit = 10, page = 1)
kable(results_table)

## ---- cache=FALSE--------------------------------------------------------
tableLatest <- aq_latest(country="IN", city="Hyderabad")
kable(head(tableLatest))

## ---- eval = FALSE-------------------------------------------------------
#  aq_measurements(city = "Delhi", parameter = "pm25")

