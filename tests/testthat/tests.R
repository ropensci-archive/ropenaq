library("Ropenaq")

#################################################################################################
context("cities")
#################################################################################################
test_that("cities returns a data table", {
  expect_that(cities(country="IN"), is_a("tbl_df"))

})

test_that("Country is checked for consistency", {
  expect_error(cities(country="PANEM"), "This country is not available within the platform.")

})
#################################################################################################
context("locations")
#################################################################################################

test_that("if the country is not available the function outputs an error", {
  expect_error(locations(country="PANEM"), " This country is not available within the platform.")
})

test_that("bad value_from and value_to provoke errors", {
  expect_error(locations(value_from=-3), "No negative values please!")
  expect_error(locations(value_to=-3), "No negative values please!")
  expect_error(locations(value_from=3, value_to=1), "The max value must be bigger than the min value.")
})

test_that("Country, city and location are checked for consistency", {
  expect_error(locations(country="PANEM"), "This country is not available within the platform.")
  expect_error(locations(country="IN", city="Barcelona"), "This city is not available within the platform for this country.")
  expect_error(locations(city="Capitole"), "This city is not available within the platform.")

  expect_error(locations(location="Nirgendwo"), "This location is not available within the platform.")
  expect_error(locations(country="IN", location="Nirgendwo"), "This location is not available within the platform for this country.")
  expect_error(locations(country="IN", city="Chennai", location="Nirgendwo"), "This location is not available within the platform for this country and this city.")
  expect_error(locations(city="Chennai", location="Nirgendwo"), "This location is not available within the platform for this city.")
})

test_that("The format of date_from and date_to are checked", {
  expect_error(locations(date_from="2014-29-12"), "date_from and date_to have to be inputed as year-month-day.")
  expect_error(locations(date_to="2014-29-12"), "date_from and date_to have to be inputed as year-month-day.")
})

#################################################################################################
context("countries")
#################################################################################################
test_that("countries returns a data table", {
  expect_that(countries(), is_a("tbl_df"))

})
#################################################################################################
context("measurements")
#################################################################################################

test_that("measurements returns a data table", {
  measurementsTable <- measurements(has_geo=TRUE, limit=10, country="US")
  expect_that(measurementsTable, is_a("tbl_df"))

})

test_that("if has_geo is TRUE then we get a table with coordinates", {
  measurementsTable <- measurements(has_geo=TRUE, limit=10, country="US")
  expect_true("latitude" %in% names(measurementsTable))
  expect_true("longitude" %in% names(measurementsTable))
})

test_that("Country, city and location are checked for consistency", {
  expect_error(measurements(country="PANEM"), "This country is not available within the platform.")
  expect_error(measurements(country="IN", city="Barcelona"), "This city is not available within the platform for this country.")
  expect_error(measurements(city="Capitole"), "This city is not available within the platform.")

  expect_error(measurements(location="Nirgendwo"), "This location is not available within the platform.")
  expect_error(measurements(country="IN", location="Nirgendwo"), "This location is not available within the platform for this country.")
  expect_error(measurements(country="IN", city="Chennai", location="Nirgendwo"), "This location is not available within the platform for this country and this city.")
  expect_error(measurements(city="Chennai", location="Nirgendwo"), "This location is not available within the platform for this city.")
})


test_that("Parameter has to be available", {
  expect_error(measurements(city="Hyderabad", parameter="co"), "This parameter is not available for any location corresponding to your query.")
})

test_that("The value_from and value_to arguments work as they should", {
  expect_true(all(measurements(city="Hyderabad", value_from=10, limit=10)$value>=10))
  expect_true(all(measurements(city="Hyderabad", value_to=10, limit=10)$value<=10))
})

test_that("The format of date_from and date_to are checked", {
  expect_error(measurements(date_from="2014-29-12"), "date_from and date_to have to be inputed as year-month-day.")
  expect_error(measurements(date_to="2014-29-12"), "date_from and date_to have to be inputed as year-month-day.")
})
#################################################################################################
context("latest")
#################################################################################################
test_that("latest returns a data table", {
  expect_that(latest(), is_a("tbl_df"))

})

test_that("Country, city and location are checked for consistency", {
  expect_error(latest(country="PANEM"), "This country is not available within the platform.")
  expect_error(latest(country="IN", city="Barcelona"), "This city is not available within the platform for this country.")
  expect_error(latest(city="Capitole"), "This city is not available within the platform.")

  expect_error(latest(location="Nirgendwo"), "This location is not available within the platform.")
  expect_error(latest(country="IN", location="Nirgendwo"), "This location is not available within the platform for this country.")
  expect_error(latest(country="IN", city="Chennai", location="Nirgendwo"), "This location is not available within the platform for this country and this city.")
  expect_error(latest(city="Chennai", location="Nirgendwo"), "This location is not available within the platform for this city.")
})

test_that("Parameter has to be available", {
  expect_error(latest(city="Hyderabad", parameter="co"), "This parameter is not available for any location corresponding to your query.")
})

test_that("The value_from and value_to arguments work as they should", {
  expect_true(all(latest(value_from=10)$value>=10), TRUE)
  expect_true(all(latest(value_to=10)$value<=10), TRUE)
})
