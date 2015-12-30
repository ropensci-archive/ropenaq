library("Ropenaq")
#################################################################################################
context("measurements")
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

test_that("if there is no result the function outputs an error", {
  expect_error(cities(country="PANEM"), "No results for this query")
})


#################################################################################################
context("countries")
#################################################################################################
test_that("countries returns a data table", {
  expect_that(locations(), is_a("tbl_df"))

})
