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

  expect_true(class(output$location) == "character")
  expect_true(class(output$parameter) == "character")
  expect_true(class(output$value) == "numeric" |
                class(output$value) == "integer")
  expect_true(class(output$unit) == "character")
  expect_true(class(output$country) == "character")
  expect_true(class(output$city) == "character")
  expect_true(class(output$cityURL) == "character")
  expect_true(class(output$locationURL) == "character")
  expect_true(class(output$dateUTC)[1] == "POSIXct")
  expect_true(class(output$dateLocal)[1] == "POSIXct")
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
