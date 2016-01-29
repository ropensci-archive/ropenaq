library("Ropenaq")

#################################################################################################
context("locations")
#################################################################################################

test_that("locations returns a data.frame (tbl_df)", {
  skip_on_cran()
  expect_that(locations(country="IN"), is_a("tbl_df"))
})

test_that("locations has the right columns", {
  skip_on_cran()
  tableRes <- locations(country="IN")
  expect_true(class(tableRes$location) == "character")
  expect_true(class(tableRes$sourceName) == "character")
  expect_true(class(tableRes$country) == "character")
  expect_true(class(tableRes$city) == "character")
  expect_true(class(tableRes$cityURL) == "character")
  expect_true(class(tableRes$locationURL) == "character")
  expect_true(class(tableRes$firstUpdated)[1] == "POSIXct")
  expect_true(class(tableRes$lastUpdated)[1] == "POSIXct")
  expect_true(class(tableRes$longitude) == "numeric" |
                class(tableRes$longitude) == "logical")
  expect_true(class(tableRes$latitude) == "numeric" |
                class(tableRes$latitude) == "logical")
})
