library("Ropenaq")
#################################################################################################
context("Measurements")
#################################################################################################

test_that("measurements returns a data table", {
  measurementsTable <- measurements(country="AU")
  expect_that(measurementsTable, is_a("tbl_df"))

})
