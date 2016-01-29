library("Ropenaq")

#################################################################################################
context("latest")
#################################################################################################
test_that("latest returns a data.frame (tbl_df)", {
  skip_on_cran()
  expect_that(latest(), is_a("tbl_df"))

})

# test_that("The value_from and value_to arguments work as they should", {
#   skip_on_cran()
#   expect_true(all(latest(value_from=10)$value>=10), TRUE)
#   expect_true(all(latest(value_to=10)$value<=10), TRUE)
# })
