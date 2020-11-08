test_that("The value_from and value_to arguments work as they should", {

  vcr::use_cassette("aq_measurements_Hyderabad_value_from", {
    output <- aq_measurements(page = 1, city="Hyderabad", value_from=10, limit=10)
  })


  expect_true(all(output$value>=10))

  vcr::use_cassette("aq_measurements_Hyderabad_value_to", {
    output <- aq_measurements(page = 1, city="Hyderabad", value_to=10, limit=10)
  })

  expect_true(all(output$value<=10))
})

test_that("measurements returns a data.frame (tbl_df)", {

  vcr::use_cassette("aq_measurements_Chennai", {
    output <- aq_measurements(limit=10,
                              page = 1,
                              city="Chennai")
  })

  expect_that(output, is_a("tbl_df"))
  expect_that(attr(output, "timestamp"), is_a("tbl_df"))
  expect_that(attr(output, "meta"), is_a("tbl_df"))

  vcr::use_cassette("aq_measurements_misc", {
    expect_that(aq_measurements(page = 1, attribution = TRUE, limit = 2), is_a("tbl_df"))
    expect_that(aq_measurements(page = 1, source_name = TRUE, limit = 2), is_a("tbl_df"))
    expect_that(aq_measurements(page = 1, averaging_period = TRUE, limit = 2), is_a("tbl_df"))
    expect_that(aq_measurements(page = 1, averaging_period = TRUE, attribution = TRUE, limit = 2), is_a("tbl_df"))
  })

})

test_that("measurements has the right columns", {

  vcr::use_cassette("aq_measurements_Chennai", {
    output <- aq_measurements(limit=10,
                              page = 1,
                              city="Chennai")
  })

  expect_type(output$location, "character")
  expect_type(output$parameter, "character")
  expect_true(is(output$value, "numeric") || is(output$value, "integer"))
  expect_type(output$unit, "character")
  expect_type(output$country, "character")
  expect_type(output$city, "character")
  expect_type(output$cityURL, "character")
  expect_type(output$locationURL, "character")

  expect_true(is(output$dateUTC, "POSIXct"))
  expect_true(is.null(output$dateLocal) || is(output$dateLocal, "POSIXct"))
  expect_true(is(output$longitude, "numeric") ||
                is(output$longitude, "logical"))
  expect_true(is(output$latitude, "numeric") ||
                is(output$latitude, "logical"))
  meta <- attr(output, "meta")
  expect_true(all(names(meta) == c("name", "license",
                                   "website", "page",
                                   "limit", "found")))
  expect_is(attr(output, "timestamp")$queriedAt, "POSIXt")
})

test_that("the max value of page is used", {
  # 3444 results but only 1000 pages with 1 can be obtained
  # skipped on CRAN and offline because vcr doesn't support async yet
  skip_on_cran()
  skip_if_offline()
  res <- aq_measurements(location = "DTU%2C+Delhi+-+CPCB",
                         date_from = as.character(Sys.Date() - 5),
                         date_to = as.character(Sys.Date() - 2),
                         parameter = "no2",
                         limit = 1)

  expect_equal(nrow(res), 100)
})


