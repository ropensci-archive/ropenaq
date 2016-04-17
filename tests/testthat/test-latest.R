library("ropenaq")

#################################################################################################
context("latest")
#################################################################################################
test_that("latest returns a list of 3 data.frames (tbl_df)", {
  skip_on_cran()
  output <- aq_latest()
  expect_that(output$results, is_a("tbl_df"))
  expect_that(output$meta, is_a("tbl_df"))
  expect_that(output$timestamp, is_a("tbl_df"))
})

test_that("latest has the right columns", {
  skip_on_cran()
  output <- aq_latest()
  tableRes <- output$results
  expect_true(all(names(tableRes) == c("location",
                                       "city",
                                       "country",
                                       "longitude",
                                       "latitude",
                                       "parameter",
                                        "value",
                                       "lastUpdated",
                                       "unit",
                                       "cityURL",
                                       "locationURL")))
  expect_true(class(tableRes$location) == "character")
  expect_true(class(tableRes$parameter) == "character")
  expect_true(class(tableRes$value) == "numeric")
  expect_true(class(tableRes$unit) == "character")
  expect_true(class(tableRes$country) == "character")
  expect_true(class(tableRes$city) == "character")
  expect_true(class(tableRes$cityURL) == "character")
  expect_true(class(tableRes$locationURL) == "character")
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


