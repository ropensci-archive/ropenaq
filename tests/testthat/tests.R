library("Ropenaq")
#################################################################################################
context("measurements")
#################################################################################################

test_that("measurements returns a data table", {
  measurementsTable <- measurements(country="IN", limit=9, city="Chennai")
  expect_that(measurementsTable, is_a("tbl_df"))

})

test_that("if has_geo is TRUE then we get a table with coordinates", {
  measurementsTable <- measurements(has_geo=TRUE, limit=10, country="US")
  expect_true("latitude" %in% names(measurementsTable))
  expect_true("longitude" %in% names(measurementsTable))
})

test_that("if the country is not available the function outputs an error", {
  expect_error(measurements(country="PANEM"), "This country is not available within the platform.")
})

#################################################################################################
context("cities")
#################################################################################################
test_that("cities returns a data table", {
  expect_that(cities(country="IN"), is_a("tbl_df"))

})


#################################################################################################
context("locations")
#################################################################################################

test_that("if the country is not available the function outputs an error", {
  expect_error(locations(country="PANEM"), " This country is not available within the platform.")
})

test_that("bad value_from and value_to provoke errors", {
  expect_error(locations(value_from=-3), "No negative values please!")
  expect_error(locations(value_to=-3), "No negative values please!")
  expect_error(locations(value_from=3, value_to=1), "The max value must be bigger than the min value.")
})

#################################################################################################
context("countries")
#################################################################################################
test_that("countries returns a data table", {
  expect_that(countries(), is_a("tbl_df"))

})

#################################################################################################
context("latest")
#################################################################################################
test_that("latest returns a data table", {
  expect_that(latest(), is_a("tbl_df"))

})
