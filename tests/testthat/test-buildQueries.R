# library("Ropenaq")
#
# #################################################################################################
# context("buildQueries")
# #################################################################################################
# query <- paste0(base_url(), "measurements?page=1")
# test_that("Country, city and location are checked for consistency", {
#   skip_on_cran()
#   expect_error(aq_measurements(country="PANEM"), "This country is not available within the platform.")
#   expect_error(aq_measurements(country="IN", city="Barcelona"), "This city is not available within the platform for this country.")
#   expect_error(aq_measurements(city="Capitole"), "This city is not available within the platform.")
#
#   expect_error(aq_measurements(location="Nirgendwo"), "This location is not available within the platform.")
#   expect_error(aq_measurements(country="IN", location="Nirgendwo"), "This location is not available within the platform for this country.")
#   expect_error(aq_measurements(country="IN", city="Chennai", location="Nirgendwo"), "This location is not available within the platform for this country and this city.")
#   expect_error(aq_measurements(city="Chennai", location="Nirgendwo"), "This location is not available within the platform for this city.")
# })
#
#
# test_that("Parameter has to be available", {
#   skip_on_cran()
#   expect_error(aq_measurements(city="Chennai", parameter="pm10"), "This parameter is not available for any location corresponding to your query.")
#   expect_error(aq_measurements(city="Hyderabad", parameter="lalala"), "You asked for an invalid parameter: see list of valid parameters in the Arguments section of the function help")
# })
#
# test_that("bad value_from and value_to provoke errors", {
#   skip_on_cran()
#   expect_error(aq_measurements(value_from=-3), "No negative value for value_from please!")
#   expect_error(aq_measurements(value_to=-3), "No negative value for value_to please!")
#   expect_error(aq_measurements(value_from=3, value_to=1), "The max value must be bigger than the min value.")
# })
#
#
#
# test_that("The format of date_from and date_to are checked", {
#   skip_on_cran()
#   expect_error(aq_measurements(date_from="2014-29-12"), "date_from and date_to have to be inputed as year-month-day.")
#   expect_error(aq_measurements(date_to="2014-29-12"), "date_from and date_to have to be inputed as year-month-day.")
#   expect_error(aq_measurements(date_to="2014-12-29", date_from="2015-12-29"), "The start date must be smaller than the end date.")
# })
#
# test_that("An error is thrown is limit>1000",{
#   expect_error(aq_measurements(has_geo=TRUE, limit=9999999, country="US"), "limit cannot be more than 1000")
# })
