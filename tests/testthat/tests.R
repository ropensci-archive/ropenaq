library("Ropenaq")

#################################################################################################
context("cities")
#################################################################################################
test_that("cities returns a data table", {
  skip_on_cran()
  expect_that(cities(country="IN"), is_a("tbl_df"))

})

test_that("Country is checked for consistency", {
  skip_on_cran()
  expect_error(cities(country="PANEM"), "This country is not available within the platform.")

})
#################################################################################################
context("locations")
#################################################################################################

test_that("if the country is not available the function outputs an error", {
  skip_on_cran()
  expect_error(locations(country="PANEM"), " This country is not available within the platform.")
})

test_that("bad value_from and value_to provoke errors", {
  skip_on_cran()
  expect_error(locations(value_from=-3), "No negative values please!")
  expect_error(locations(value_to=-3), "No negative values please!")
  expect_error(locations(value_from=3, value_to=1), "The max value must be bigger than the min value.")
})

test_that("Country, city and location are checked for consistency", {
  skip_on_cran()
  expect_error(locations(country="PANEM"), "This country is not available within the platform.")
  expect_error(locations(country="IN", city="Barcelona"), "This city is not available within the platform for this country.")
  expect_error(locations(city="Capitole"), "This city is not available within the platform.")

  expect_error(locations(location="Nirgendwo"), "This location is not available within the platform.")
  expect_error(locations(country="IN", location="Nirgendwo"), "This location is not available within the platform for this country.")
  expect_error(locations(country="IN", city="Chennai", location="Nirgendwo"), "This location is not available within the platform for this country and this city.")
  expect_error(locations(city="Chennai", location="Nirgendwo"), "This location is not available within the platform for this city.")
})

test_that("The format of date_from and date_to are checked", {
  skip_on_cran()
  expect_error(locations(date_from="2014-29-12"), "date_from and date_to have to be inputed as year-month-day.")
  expect_error(locations(date_to="2014-29-12"), "date_from and date_to have to be inputed as year-month-day.")
  expect_error(locations(date_to="2014-12-29", date_from="2015-12-29"), "The start date must be smaller than the end date.")
})

test_that("Parameter has to be available", {
  skip_on_cran()
  expect_error(locations(parameter="lalala"), "You asked for an invalid parameter: see list of valid parameters in the Arguments section of the function help")
})

#################################################################################################
context("countries")
#################################################################################################
test_that("countries returns a data table", {
  skip_on_cran()
  expect_that(countries(), is_a("tbl_df"))

})
#################################################################################################
context("measurements")
#################################################################################################

test_that("An error is thrown is limit>1000",{
  expect_error(- measurements(has_geo=TRUE, limit=9999999, country="US"), "limit cannot be more than 1000")
})

test_that("measurements returns a data table", {
  skip_on_cran()
  measurementsTable <- measurements(limit=10, city="Sao+Paulo")
  expect_that(measurementsTable, is_a("tbl_df"))

})


test_that("Country, city and location are checked for consistency", {
  skip_on_cran()
  expect_error(measurements(country="PANEM"), "This country is not available within the platform.")
  expect_error(measurements(country="IN", city="Barcelona"), "This city is not available within the platform for this country.")
  expect_error(measurements(city="Capitole"), "This city is not available within the platform.")

  expect_error(measurements(location="Nirgendwo"), "This location is not available within the platform.")
  expect_error(measurements(country="IN", location="Nirgendwo"), "This location is not available within the platform for this country.")
  expect_error(measurements(country="IN", city="Chennai", location="Nirgendwo"), "This location is not available within the platform for this country and this city.")
  expect_error(measurements(city="Chennai", location="Nirgendwo"), "This location is not available within the platform for this city.")
})


test_that("Parameter has to be available", {
  skip_on_cran()
  expect_error(measurements(city="Hyderabad", parameter="co"), "This parameter is not available for any location corresponding to your query.")
  expect_error(measurements(city="Hyderabad", parameter="lalala"), "You asked for an invalid parameter: see list of valid parameters in the Arguments section of the function help")
})

test_that("bad value_from and value_to provoke errors", {
  skip_on_cran()
  expect_error(measurements(value_from=-3), "No negative value for value_from please!")
  expect_error(measurements(value_to=-3), "No negative value for value_to please!")
  expect_error(measurements(value_from=3, value_to=1), "The max value must be bigger than the min value.")
})

test_that("The value_from and value_to arguments work as they should", {
  skip_on_cran()
  expect_true(all(measurements(city="Hyderabad", value_from=10, limit=10)$value>=10))
  expect_true(all(measurements(city="Hyderabad", value_to=10, limit=10)$value<=10))
})

test_that("The format of date_from and date_to are checked", {
  skip_on_cran()
  expect_error(measurements(date_from="2014-29-12"), "date_from and date_to have to be inputed as year-month-day.")
  expect_error(measurements(date_to="2014-29-12"), "date_from and date_to have to be inputed as year-month-day.")
  expect_error(measurements(date_to="2014-12-29", date_from="2015-12-29"), "The start date must be smaller than the end date.")
})
#################################################################################################
context("latest")
#################################################################################################
test_that("latest returns a data table", {
  skip_on_cran()
  expect_that(latest(), is_a("tbl_df"))

})

test_that("Country, city and location are checked for consistency", {
  skip_on_cran()
  expect_error(latest(country="PANEM"), "This country is not available within the platform.")
  expect_error(latest(country="IN", city="Barcelona"), "This city is not available within the platform for this country.")
  expect_error(latest(city="Capitole"), "This city is not available within the platform.")

  expect_error(latest(location="Nirgendwo"), "This location is not available within the platform.")
  expect_error(latest(country="IN", location="Nirgendwo"), "This location is not available within the platform for this country.")
  expect_error(latest(country="IN", city="Chennai", location="Nirgendwo"), "This location is not available within the platform for this country and this city.")
  expect_error(latest(city="Chennai", location="Nirgendwo"), "This location is not available within the platform for this city.")
})

test_that("Parameter has to be available", {
  skip_on_cran()
  expect_error(latest(city="Hyderabad", parameter="co"), "This parameter is not available for any location corresponding to your query.")
  expect_error(latest(city="Hyderabad", parameter="lalala"), "You asked for an invalid parameter: see list of valid parameters in the Arguments section of the function help")
})

# test_that("The value_from and value_to arguments work as they should", {
#   skip_on_cran()
#   expect_true(all(latest(value_from=10)$value>=10), TRUE)
#   expect_true(all(latest(value_to=10)$value<=10), TRUE)
# })

#################################################################################################
if (requireNamespace("lintr", quietly = TRUE)) {
  context("lints")
  test_that("Package Style", {
    skip_on_appveyor()
    lintr::expect_lint_free()
  })
}
