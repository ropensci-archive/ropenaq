test_that("cities returns a data.frame (tbl_df)", {

  vcr::use_cassette("aq_cities_page1", {
    output <- aq_cities(page = 1)
  })

  expect_that(output, is_a("tbl_df"))
  expect_that(attr(output, "meta"), is_a("tbl_df"))
  expect_that(attr(output, "timestamp"), is_a("tbl_df"))

})

test_that("cities has the right columns", {

  vcr::use_cassette("aq_cities_page1_IN", {
    tableRes <- aq_cities(page = 1, country="IN")
  })


  expect_true(class(tableRes$city) == "character")
  expect_true(class(tableRes$country) == "character")
  expect_true(class(tableRes$cityURL) == "character")
  expect_true(class(tableRes$count) == "integer")
  expect_true(class(tableRes$locations) == "integer")
  meta <- attr(tableRes, "meta")
  expect_true(all(names(meta) == c("name", "license",
                                   "website", "page",
                                   "limit", "found")))
  expect_is(attr(tableRes, "timestamp")$queriedAt, "POSIXt")

})
