library("Ropenaq")
#################################################################################################
context("cities")
#################################################################################################
test_that("cities returns a data.frame (tbl_df)", {
  skip_on_cran()
  expect_that(cities(country="IN"), is_a("tbl_df"))

})
