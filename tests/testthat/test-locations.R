library("ropenaq")

#################################################################################################
context("locations")
#################################################################################################

test_that("locations returns a data.frame (tbl_df)", {
  skip_on_cran()
  output <- aq_locations(country="IN")
  expect_that(output, is_a("tbl_df"))
  expect_that(attr(output, "meta"), is_a("tbl_df"))
  expect_that(attr(output, "timestamp"), is_a("tbl_df"))
})

test_that("locations has the right columns", {
  skip_on_cran()
  output <- aq_locations(country="IN")
  tableRes <- output
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
  meta <- attr(output, "meta")
  expect_true(all(names(meta) == c("name", "license",
                                   "website", "page",
                                   "limit", "found")))
  expect_is(attr(output, "timestamp")$queriedAt, "POSIXt")
})
