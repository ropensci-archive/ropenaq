test_that("latest returns a data.frame (tbl_df)", {

  vcr::use_cassette("aq_latest_page1_limit100", {
    output <- aq_latest(page = 1, limit = 100)
  })

  expect_that(output, is_a("tbl_df"))
  expect_that(attr(output, "meta"), is_a("tbl_df"))
  expect_that(attr(output, "timestamp"), is_a("tbl_df"))

  vcr::use_cassette("aq_latest_00_radius", {
    output2 <- aq_latest(page = 1, latitude = 0, longitude = 0, radius = 10000000, limit = 2)
  })

  expect_that(output2, is_a("tbl_df"))

  vcr::use_cassette("aq_latest_00", {
    output3 <- aq_latest(page = 1, latitude = 0, longitude = 0, limit = 2)
  })

  expect_that(output3, is_a("tbl_df"))
})

test_that("latest has the right columns", {

  vcr::use_cassette("aq_latest_page1_limit2", {
    output <- aq_latest(page = 1, limit = 2)
  })


  expect_true(all(names(output) %in% c("location",
                                       "city",
                                       "distance",
                                       "country",
                                       "latitude",
                                       "longitude",
                                       "parameter",
                                        "value",
                                       "lastUpdated",
                                       "unit",
                                       "sourceName",
                                       "cityURL",
                                       "locationURL",
                                       "averagingPeriod_unit",
                                       "averagingPeriod_value")))
  expect_true(class(output$location) == "character")
  expect_true(class(output$parameter) == "character")
  expect_true(class(output$value) == "numeric")
  expect_true(class(output$unit) == "character")
  expect_true(class(output$country) == "character")
  expect_true(class(output$city) == "character")
  expect_true(class(output$cityURL) == "character")
  expect_true(class(output$locationURL) == "character")
  expect_true(class(output$lastUpdated)[1] == "POSIXct")
  expect_true(class(output$longitude) == "numeric" |
                class(output$longitude) == "logical")
  expect_true(class(output$latitude) == "numeric" |
                class(output$latitude) == "logical")
  meta <- attr(output, "meta")
  expect_true(all(names(meta) == c("name", "license",
                                   "website", "page",
                                   "limit", "found")))
  expect_is(attr(output, "timestamp")$queriedAt, "POSIXt")
})


