library("Ropenaq")

#################################################################################################
context("measurements")
#################################################################################################

test_that("The value_from and value_to arguments work as they should", {
  skip_on_cran()
  expect_true(all(aq_measurements(city="Hyderabad", value_from=10, limit=10)$value>=10))
  expect_true(all(aq_measurements(city="Hyderabad", value_to=10, limit=10)$value<=10))
})

test_that("measurements returns a data.frame (tbl_df)", {
  skip_on_cran()
  measurementsTable <- aq_measurements(limit=10, city="Sao+Paulo")
  expect_that(measurementsTable, is_a("tbl_df"))

})

test_that("measurements has the right columns", {
  skip_on_cran()
  tableRes <- aq_measurements(limit=10, city="Sao+Paulo")
  expect_true(class(tableRes$location) == "character")
  expect_true(class(tableRes$parameter) == "character")
  expect_true(class(tableRes$value) == "numeric" |
                class(tableRes$value) == "integer")
  expect_true(class(tableRes$unit) == "character")
  expect_true(class(tableRes$country) == "character")
  expect_true(class(tableRes$city) == "character")
  expect_true(class(tableRes$cityURL) == "character")
  expect_true(class(tableRes$locationURL) == "character")
  expect_true(class(tableRes$dateUTC)[1] == "POSIXct")
  expect_true(class(tableRes$dateLocal)[1] == "POSIXct")
  expect_true(class(tableRes$longitude) == "numeric" |
                class(tableRes$longitude) == "logical")
  expect_true(class(tableRes$latitude) == "numeric" |
                class(tableRes$latitude) == "logical")
})
