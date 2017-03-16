context("async requests")

test_that("It's possible to do async queries",{
  skip_on_cran()
  meas <- aq_measurements(city = "Delhi",
                          date_from = as.character(Sys.Date() - 1),
                          limit = 100)
  expect_that(meas, is_a("tbl_df"))
})
