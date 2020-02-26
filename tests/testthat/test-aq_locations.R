test_that("locations returns a data.frame (tbl_df)", {

  vcr::use_cassette("aq_locations_AD", {
    output <- aq_locations(page = 1, country="AD")
  })

  expect_that(output, is_a("tbl_df"))
  expect_that(attr(output, "meta"), is_a("tbl_df"))
  expect_that(attr(output, "timestamp"), is_a("tbl_df"))
})

test_that("locations has the right columns", {

  vcr::use_cassette("aq_locations_AD", {
    output <- aq_locations(page = 1, country="AD")
  })

  expect_true(class(output$location) == "character")
  expect_true(class(output$sourceName) == "character")
  expect_true(class(output$country) == "character")
  expect_true(class(output$city) == "character")
  expect_true(class(output$cityURL) == "character")
  expect_true(class(output$locationURL) == "character")
  expect_true(class(output$firstUpdated)[1] == "POSIXct")
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
