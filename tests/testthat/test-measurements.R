library("Ropenaq")

#################################################################################################
context("measurements")
#################################################################################################

test_that("The value_from and value_to arguments work as they should", {
  skip_on_cran()
  expect_true(all(measurements(city="Hyderabad", value_from=10, limit=10)$value>=10))
  expect_true(all(measurements(city="Hyderabad", value_to=10, limit=10)$value<=10))
})

test_that("measurements returns a data.frame (tbl_df)", {
  skip_on_cran()
  measurementsTable <- measurements(limit=10, city="Sao+Paulo")
  expect_that(measurementsTable, is_a("tbl_df"))

})
