library("Ropenaq")

#################################################################################################
context("latest")
#################################################################################################
test_that("latest returns a data.frame (tbl_df)", {
  skip_on_cran()
  expect_that(aq_latest(), is_a("tbl_df"))

})

test_that("latest has the right columns", {
  skip_on_cran()
  tableRes <- aq_latest()
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
})


