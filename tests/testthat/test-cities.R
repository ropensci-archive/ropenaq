library("Ropenaq")
#################################################################################################
context("cities")
#################################################################################################
test_that("cities returns a data.frame (tbl_df)", {
  skip_on_cran()
  output <- aq_cities()
  expect_that(output$results, is_a("tbl_df"))
  expect_that(output$meta, is_a("tbl_df"))
  expect_that(output$timestamp, is_a("tbl_df"))

})

test_that("cities has the right columns", {
  skip_on_cran()
  tableRes <- aq_cities(country="IN")
  expect_true(class(tableRes$results$city) == "character")
  expect_true(class(tableRes$results$country) == "character")
  expect_true(class(tableRes$results$cityURL) == "character")
  expect_true(class(tableRes$results$count) == "integer")
  expect_true(class(tableRes$results$locations) == "integer")
  meta <- tableRes$meta
  expect_true(all(names(meta) == c("name", "license",
                                   "website", "page",
                                   "limit", "found")))
  expect_is(tableRes$timestamp$lastModif, "POSIXt")
  expect_is(tableRes$timestamp$queriedAt, "POSIXt")

})
