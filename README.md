Ropenaq
=======

[![Build Status](https://travis-ci.org/masalmon/Ropenaq.svg)](https://travis-ci.org/masalmon/Ropenaq) [![Build status](https://ci.appveyor.com/api/projects/status/dgh82o8ldlgl6qrq?svg=true)](https://ci.appveyor.com/project/masalmon/ropenaq) [![codecov.io](https://codecov.io/github/masalmon/Ropenaq/coverage.svg?branch=master)](https://codecov.io/github/masalmon/Ropenaq?branch=master)

Introduction
============

This R package is aimed at accessing the openaq API. OpenAQ is a community of scientists, software developers, and lovers of open environmental data who are building an open, real-time database that provides programmatic and historical access to air quality data. See their website at <https://openaq.org/> and see the API documentation at <https://docs.openaq.org/>. The package contains 5 functions that correspond to the 5 different types of query offered by the openaq API: cities, countries, latest, locations and measurements. The package uses the `dplyr` package: all output tables are data.frame (dplyr "tbl\_df") objects, that can be further processed and analysed.

Finding data availability
=========================

Three functions of the package allow to get lists of available information. Measurements are obtained from *locations* that are in *cities* that are in *countries*.

The `aq_countries` function
---------------------------

The `aq_countries` function allows to see for which countries information is available within the platform. It is the easiest function because it does not have any argument.

``` r
library("Ropenaq")
countriesTable <- aq_countries()
library("knitr")
kable(countriesTable)
```

|   count| code | name           |
|-------:|:-----|:---------------|
|  332075| TH   | Thailand       |
|   12579| CN   | China          |
|  377705| MN   | Mongolia       |
|  101491| GB   | United Kingdom |
|  592505| CL   | Chile          |
|  170387| US   | United States  |
|  255047| AU   | Australia      |
|  114677| IN   | India          |
|    1118| VN   | Viet Nam       |
|  396648| BR   | Brazil         |
|  152722| PL   | Poland         |
|  752749| NL   | Netherlands    |
|    1726| ID   | Indonesia      |

The `aq_cities` function
------------------------

Using the `aq_cities` functions one can get all cities for which information is available within the platform. For each city, one gets the number of locations and the count of measures for the city, the URL encoded string, and the country it is in.

``` r
citiesTable <- aq_cities()
kable(head(citiesTable))
```

| city         | country |  count|  locations| cityURL      |
|:-------------|:--------|------:|----------:|:-------------|
| Amsterdam    | NL      |  96957|         14| Amsterdam    |
| Andacollo    | CL      |   2540|          1| Andacollo    |
| Antofagasta  | CL      |   4668|          1| Antofagasta  |
| Arica        | CL      |   2303|          1| Arica        |
| Ayutthaya    | TH      |   6303|          1| Ayutthaya    |
| Badhoevedorp | NL      |  10670|          1| Badhoevedorp |

The optional `country` argument allows to do this for a given country instead of the whole world.

``` r
citiesTableIndia <- aq_cities(country="IN")
kable(citiesTableIndia)
```

| city      | country |   count|  locations| cityURL   |
|:----------|:--------|-------:|----------:|:----------|
| Chennai   | IN      |    1119|          1| Chennai   |
| Delhi     | IN      |  110204|          5| Delhi     |
| Hyderabad | IN      |    1118|          1| Hyderabad |
| Kolkata   | IN      |    1118|          1| Kolkata   |
| Mumbai    | IN      |    1118|          1| Mumbai    |

If one inputs a country that is not in the platform (or misspells a code), then an error message is thrown.

``` r
aq_cities(country="PANEM")
```

    ## Error in buildQuery(country = country): This country is not available within the platform. See ?countries

The `locations` function
------------------------

The `aq_locations` function has far more arguments than the first two functions. On can filter locations in a given country, city, location, for a given parameter (valid values are "pm25", "pm10", "so2", "no2", "o3", "co" and "bc"), from a given date and/or up to a given date, for values between a minimum and a maximum. In the output table one also gets URL encoded strings for the city and the location. Below are several examples.

Here we only look for locations with PM2.5 information in India.

``` r
locationsIndia <- aq_locations(country="IN", parameter="pm25")
kable(locationsIndia)
```

| location                      | city      | country | sourceName          |  count| lastUpdated | firstUpdated | parameters |  longitude|  latitude| cityURL   | locationURL                     |
|:------------------------------|:----------|:--------|:--------------------|------:|:------------|:-------------|:-----------|----------:|---------:|:----------|:--------------------------------|
| Anand Vihar                   | Delhi     | IN      | Anand Vihar         |   4005| 1453664400  | 1435588200   | pm25       |         NA|        NA| Delhi     | Anand+Vihar                     |
| Mandir Marg                   | Delhi     | IN      | Mandir Marg         |   5871| 1453665600  | 1435588200   | pm25       |         NA|        NA| Delhi     | Mandir+Marg                     |
| Punjabi Bagh                  | Delhi     | IN      | Punjabi Bagh        |   5697| 1453665300  | 1435537800   | pm25       |         NA|        NA| Delhi     | Punjabi+Bagh                    |
| RK Puram                      | Delhi     | IN      | RK Puram            |   6186| 1453665300  | 1435588200   | pm25       |         NA|        NA| Delhi     | RK+Puram                        |
| US Diplomatic Post: Chennai   | Chennai   | IN      | StateAir\_Chennai   |   1119| 1454337000  | 1449869400   | pm25       |   80.25193|  13.05237| Chennai   | US+Diplomatic+Post%3A+Chennai   |
| US Diplomatic Post: Hyderabad | Hyderabad | IN      | StateAir\_Hyderabad |   1118| 1454337000  | 1449869400   | pm25       |   78.47489|  17.44346| Hyderabad | US+Diplomatic+Post%3A+Hyderabad |
| US Diplomatic Post: Kolkata   | Kolkata   | IN      | StateAir\_Kolkata   |   1118| 1454337000  | 1449869400   | pm25       |   88.35105|  22.54714| Kolkata   | US+Diplomatic+Post%3A+Kolkata   |
| US Diplomatic Post: Mumbai    | Mumbai    | IN      | StateAir\_Mumbai    |   1118| 1454337000  | 1449869400   | pm25       |   72.86870|  19.06602| Mumbai    | US+Diplomatic+Post%3A+Mumbai    |
| US Diplomatic Post: New Delhi | Delhi     | IN      | StateAir\_NewDelhi  |   1118| 1454337000  | 1449869400   | pm25       |   77.18907|  28.59810| Delhi     | US+Diplomatic+Post%3A+New+Delhi |

Then we could only choose to see the locations with results before 2015-10-01.

``` r
locationsIndia2 <- aq_locations(country="IN", parameter="pm25", date_to="2015-10-01")
kable(locationsIndia2)
```

| location     | city  | country | sourceName   |  count| lastUpdated | firstUpdated | parameters | latitude | longitude | cityURL | locationURL  |
|:-------------|:------|:--------|:-------------|------:|:------------|:-------------|:-----------|:---------|:----------|:--------|:-------------|
| Anand Vihar  | Delhi | IN      | Anand Vihar  |   1499| 1442233800  | 1435588200   | pm25       | NA       | NA        | Delhi   | Anand+Vihar  |
| Mandir Marg  | Delhi | IN      | Mandir Marg  |   2023| 1443657000  | 1435588200   | pm25       | NA       | NA        | Delhi   | Mandir+Marg  |
| Punjabi Bagh | Delhi | IN      | Punjabi Bagh |   1516| 1443657000  | 1435537800   | pm25       | NA       | NA        | Delhi   | Punjabi+Bagh |
| RK Puram     | Delhi | IN      | RK Puram     |   1886| 1443657000  | 1435588200   | pm25       | NA       | NA        | Delhi   | RK+Puram     |

Getting data
============

Two functions allow to get data: `aq_measurement` and `aq_latest`. In both of them the arguments city and location needs to be given as URL encoded strings.

The `aq_measurements` function
------------------------------

The `aq_measurements` function has many arguments for getting a query specific to, say, a given parameter in a given location. Below we get the PM2.5 measures for Anand Vihar in Delhi in India.

``` r
tableResults <- aq_measurements(country="IN", city="Delhi", location="Anand+Vihar", parameter="pm25")
kable(head(tableResults))
```

| location    | parameter |  value| unit  | country | city  | cityURL | locationURL | dateUTC             | dateLocal           | latitude | longitude |
|:------------|:----------|------:|:------|:--------|:------|:--------|:------------|:--------------------|:--------------------|:---------|:----------|
| Anand Vihar | pm25      |    228| µg/m³ | IN      | Delhi | Delhi   | Anand+Vihar | 2016-01-24 19:40:00 | 2016-01-24 19:40:00 | NA       | NA        |
| Anand Vihar | pm25      |    251| µg/m³ | IN      | Delhi | Delhi   | Anand+Vihar | 2016-01-24 19:20:00 | 2016-01-24 19:20:00 | NA       | NA        |
| Anand Vihar | pm25      |    251| µg/m³ | IN      | Delhi | Delhi   | Anand+Vihar | 2016-01-24 18:40:00 | 2016-01-24 18:40:00 | NA       | NA        |
| Anand Vihar | pm25      |    167| µg/m³ | IN      | Delhi | Delhi   | Anand+Vihar | 2016-01-16 22:30:00 | 2016-01-16 22:30:00 | NA       | NA        |
| Anand Vihar | pm25      |    164| µg/m³ | IN      | Delhi | Delhi   | Anand+Vihar | 2016-01-16 22:10:00 | 2016-01-16 22:10:00 | NA       | NA        |
| Anand Vihar | pm25      |    164| µg/m³ | IN      | Delhi | Delhi   | Anand+Vihar | 2016-01-16 21:30:00 | 2016-01-16 21:30:00 | NA       | NA        |

One could also get all possible parameters in the same table.

The `aq_latest` function
------------------------

This function gives a table with all newest measures for the locations that are chosen by the arguments. If all arguments are `NULL`, it gives all the newest measures for all locations.

``` r
tableLatest <- aq_latest()
kable(head(tableLatest))
```

| location   | city        | country |  longitude|   latitude| parameter |    value| lastUpdated         | unit  | cityURL     | locationURL |
|:-----------|:------------|:--------|----------:|----------:|:----------|--------:|:--------------------|:------|:------------|:------------|
| 100 ail    | Ulaanbaatar | MN      |  106.92138|   47.93291| co        |  5279.00| 2016-02-01 14:45:00 | µg/m³ | Ulaanbaatar | 100+ail     |
| 100 ail    | Ulaanbaatar | MN      |  106.92138|   47.93291| no2       |   111.00| 2015-09-25 23:15:00 | µg/m³ | Ulaanbaatar | 100+ail     |
| 100 ail    | Ulaanbaatar | MN      |  106.92138|   47.93291| o3        |     2.00| 2015-09-05 18:30:00 | µg/m³ | Ulaanbaatar | 100+ail     |
| 100 ail    | Ulaanbaatar | MN      |  106.92138|   47.93291| pm10      |   559.00| 2015-09-08 14:30:00 | µg/m³ | Ulaanbaatar | 100+ail     |
| 100 ail    | Ulaanbaatar | MN      |  106.92138|   47.93291| so2       |   162.00| 2015-10-05 13:45:00 | µg/m³ | Ulaanbaatar | 100+ail     |
| 21 de mayo | Los Angeles | CL      |  -72.36146|  -37.47118| pm10      |    53.33| 2015-12-04 03:00:00 | µg/m³ | Los+Angeles | 21+de+mayo  |

Below are the latest values for Anand Vihar at the time this vignette was compiled (cache=TRUE).

``` r
tableLatest <- aq_latest(country="IN", city="Delhi", location="Anand+Vihar")
kable(head(tableLatest))
```

| location    | city  | country | latitude | longitude | parameter |  value| lastUpdated         | unit  | cityURL | locationURL |
|:------------|:------|:--------|:---------|:----------|:----------|------:|:--------------------|:------|:--------|:------------|
| Anand Vihar | Delhi | IN      | NA       | NA        | co        |  900.0| 2016-01-24 19:40:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | NA       | NA        | no2       |   39.8| 2016-01-16 22:30:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | NA       | NA        | o3        |    9.5| 2016-01-24 19:40:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | NA       | NA        | pm10      |  366.0| 2016-01-24 19:40:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | NA       | NA        | pm25      |  228.0| 2016-01-24 19:40:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | NA       | NA        | so2       |   18.3| 2016-01-16 10:10:00 | µg/m³ | Delhi   | Anand+Vihar |
