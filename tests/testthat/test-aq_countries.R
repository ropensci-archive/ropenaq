test_that("countries returns a data.frame (tbl_df) with attributes", {

  vcr::use_cassette("aq_countries", {
    output <- aq_countries()
  })

  expect_that(output, is_a("tbl_df"))
  expect_that(attr(output, "meta"), is_a("tbl_df"))
  expect_that(attr(output, "timestamp"), is_a("tbl_df"))
})


test_that("countries has the right columns", {

  vcr::use_cassette("aq_countries", {
    output <- aq_countries()
  })

  expect_true(class(output$count) == "integer")
  expect_true(class(output$code) == "character")
  expect_true(class(output$name) == "character")
  meta <- attr(output, "meta")
  expect_true(all(names(meta) == c("name", "license",
                                   "website", "page",
                                   "limit", "found")))
  expect_is(attr(output, "timestamp")$queriedAt, "POSIXt")
})
