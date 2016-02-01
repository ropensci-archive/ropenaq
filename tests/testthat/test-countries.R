library("Ropenaq")
#################################################################################################
context("countries")
#################################################################################################
test_that("countries returns a data.frame (tbl_df)", {
  skip_on_cran()
  expect_that(aq_countries(), is_a("tbl_df"))

})


test_that("countries has the right columns", {
  skip_on_cran()
  tableRes <- aq_countries()
  expect_true(class(tableRes$count) == "integer")
  expect_true(class(tableRes$code) == "character")
  expect_true(class(tableRes$name) == "character")
})
