library("Ropenaq")

#################################################################################################
context("latest")
#################################################################################################
test_that("latest returns a data.frame (tbl_df)", {
  skip_on_cran()
  expect_that(latest(), is_a("tbl_df"))

})

test_that("latest has the right columns", {
  skip_on_cran()
  tableRes <- latest()
  expect_true(all(names(tableRes) == c("location",
                                       "city",
                                       "country",
                                       "longitude",
                                       "latitude",
                                       "parameter",
                                        "value",
                                       "lastUpdated",
                                       "unit",
                                       "cityURL",
                                       "locationURL")))
  classCol <- unlist(lapply(tableRes, class))
  expect_true(all(classCol==c("character",
                             "character",
                             "character",
                             "numeric",
                             "numeric",
                             "character",
                             "numeric",
                             "POSIXct",
                             "POSIXt",
                             "character",
                             "character",
                             "character")))
})

# test_that("The value_from and value_to arguments work as they should", {
#   skip_on_cran()
#   expect_true(all(latest(value_from=10)$value>=10), TRUE)
#   expect_true(all(latest(value_to=10)$value<=10), TRUE)
# })
