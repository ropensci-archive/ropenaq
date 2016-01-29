library("Ropenaq")
#################################################################################################
context("cities")
#################################################################################################
test_that("cities returns a data.frame (tbl_df)", {
  skip_on_cran()
  expect_that(cities(country="IN"), is_a("tbl_df"))

})

test_that("cities has the right columns", {
  skip_on_cran()
  tableRes <- cities(country="IN")
  expect_true(class(tableRes$city) == "character")
  expect_true(class(tableRes$country) == "character")
  expect_true(class(tableRes$cityURL) == "character")
  expect_true(class(tableRes$count) == "integer")
  expect_true(class(tableRes$locations) == "integer")

})
