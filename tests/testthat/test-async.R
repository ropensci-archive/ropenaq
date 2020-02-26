context("async requests")

test_that("It's possible to do async queries",{
  skip_on_cran()
  skip_if_offline()
  meas <- aq_measurements(city = "Escaldes-Engordany",
                          date_from = as.character(Sys.Date() - 1),
                          limit = 10)
  expect_that(meas, is_a("tbl_df"))
})
