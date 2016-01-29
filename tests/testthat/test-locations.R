library("Ropenaq")

#################################################################################################
context("locations")
#################################################################################################

test_that("locations returns a data.frame (tbl_df)", {
  skip_on_cran()
  expect_that(locations(country="IN"), is_a("tbl_df"))
})
