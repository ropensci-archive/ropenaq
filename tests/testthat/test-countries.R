library("Ropenaq")
#################################################################################################
context("countries")
#################################################################################################
test_that("countries returns a list of two data.frames (tbl_df)", {
  skip_on_cran()
  output <- aq_countries()
  expect_that(output$results, is_a("tbl_df"))
  expect_that(output$meta, is_a("tbl_df"))
  expect_that(output$timestamp, is_a("tbl_df"))
})


test_that("countries has the right columns", {
  skip_on_cran()
  output <- aq_countries()
  tableRes <- output$results
  expect_true(class(tableRes$count) == "integer")
  expect_true(class(tableRes$code) == "character")
  expect_true(class(tableRes$name) == "character")
  meta <- output$meta
  expect_true(all(names(meta) == c("name", "license",
                                   "website", "page",
                                   "limit", "found")))
  expect_is(output$timestamp$lastModif, "POSIXt")
  expect_is(output$timestamp$queriedAt, "POSIXt")
})
