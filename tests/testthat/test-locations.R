library("Ropenaq")

#################################################################################################
context("locations")
#################################################################################################

test_that("locations returns a data.frame (tbl_df)", {
  skip_on_cran()
  output <- aq_locations(country="IN")
  expect_that(output$results, is_a("tbl_df"))
  expect_that(output$meta, is_a("tbl_df"))
  expect_that(output$timestamp, is_a("tbl_df"))
})

test_that("locations has the right columns", {
  skip_on_cran()
  output <- aq_locations(country="IN")
  tableRes <- output$results
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
  meta <- output$meta
  expect_true(all(names(meta) == c("name", "license",
                                   "website", "page",
                                   "limit", "found")))
  expect_is(output$timestamp$lastModif, "POSIXt")
  expect_is(output$timestamp$queriedAt, "POSIXt")
})
