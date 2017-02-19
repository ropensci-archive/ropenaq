library("ropenaq")
#################################################################################################
context("countries")
#################################################################################################
test_that("countries returns a data.frame (tbl_df) with attributes", {
  skip_on_cran()
  output <- aq_countries()
  expect_that(output, is_a("tbl_df"))
  expect_that(attr(output, "meta"), is_a("tbl_df"))
  expect_that(attr(output, "timestamp"), is_a("tbl_df"))
})


test_that("countries has the right columns", {
  skip_on_cran()
  output <- aq_countries()
  tableRes <- output
  expect_true(class(tableRes$count) == "integer")
  expect_true(class(tableRes$code) == "character")
  expect_true(class(tableRes$name) == "character")
  meta <- attr(output, "meta")
  expect_true(all(names(meta) == c("name", "license",
                                   "website", "page",
                                   "limit", "found")))
  expect_is(attr(output, "timestamp")$queriedAt, "POSIXt")
})
