library("Ropenaq")
#################################################################################################
context("Measurements")
#################################################################################################

test_that("measurements returns a data table", {
  measurementsTable <- measurements(country="AU")
  expect_that(measurementsTable, is_a("tbl_df"))

})

test_that("if has_geo is TRUE then we get a table with coordinates", {
  measurementsTable <- measurements(has_geo=TRUE, limit=10)
  expect_true("latitude" %in% names(measurementsTable))
  expect_true("longitude" %in% names(measurementsTable))
})

test_that("if there is no result the function outputs an error", {
  expect_error(measurements(country="RIEN"), "No results for this query")
})

