library("Ropenaq")
#################################################################################################
context("countries")
#################################################################################################
test_that("countries returns a data.frame (tbl_df)", {
  skip_on_cran()
  expect_that(countries(), is_a("tbl_df"))

})
