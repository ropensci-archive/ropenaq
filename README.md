-   [ropenaq](#ropenaq)
-   [Installation](#installation)
-   [Introduction](#introduction)
-   [Finding measurements availability](#finding-measurements-availability)
    -   [The `aq_countries` function](#the-aq_countries-function)
    -   [The `aq_cities` function](#the-aq_cities-function)
    -   [The `aq_locations` function](#the-aq_locations-function)
-   [Getting measurements](#getting-measurements)
    -   [The `aq_measurements` function](#the-aq_measurements-function)
    -   [The `aq_latest` function](#the-aq_latest-function)
-   [Paging and limit](#paging-and-limit)
-   [Other packages of interest for getting air quality data](#other-packages-of-interest-for-getting-air-quality-data)
    -   [Meta](#meta)

ropenaq
=======

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/ropenaq)](http://cran.r-project.org/package=ropenaq) [![Build Status](https://travis-ci.org/ropenscilabs/ropenaq.svg?branch=master)](https://travis-ci.org/ropenscilabs/ropenaq) [![Build status](https://ci.appveyor.com/api/projects/status/qurhlh0j8ra3qors?svg=true)](https://ci.appveyor.com/project/ropenscilabs/ropenaq) [![codecov.io](https://codecov.io/github/ropenscilabs/ropenaq/coverage.svg?branch=master)](https://codecov.io/github/ropenscilabs/Ropenaq?branch=master)

Installation
============

Install the package with:

``` r
install.packages("ropenaq")
```

Or install the development version using [devtools](https://github.com/hadley/devtools) with:

``` r
library("devtools")
install_github("ropenscilabs/ropenaq")
```

If you experience trouble using the package on a Linux machine, please run

``` r
url::curl_version()$ssl_version
```

If it answers `GnuTLS`, run

``` r
apt-get install libcurl4-openssl-dev
```

And desinstall then re-install `curl`.

``` r
install.packages("curl")
```

If it still doesn't work, please open a new issue!

Introduction
============

This R package is aimed at accessing the openaq API. OpenAQ is a community of scientists, software developers, and lovers of open environmental data who are building an open, real-time database that provides programmatic and historical access to air quality data. See their website at <https://openaq.org/> and see the API documentation at <https://docs.openaq.org/>. The package contains 5 functions that correspond to the 5 different types of query offered by the openaq API: cities, countries, latest, locations and measurements. The package uses the `dplyr` package: all output tables are data.frame (dplyr "tbl\_df") objects, that can be further processed and analysed.

Finding measurements availability
=================================

Three functions of the package allow to get lists of available information. Measurements are obtained from *locations* that are in *cities* that are in *countries*.

The `aq_countries` function
---------------------------

The `aq_countries` function allows to see for which countries information is available within the platform. It is the easiest function because it does not have any argument. The code for each country is its ISO 3166-1 alpha-2 code.

``` r
library("ropenaq")
countries_table <- aq_countries()
library("knitr")
kable(countries_table)
```

| name                   | code |  cities|  locations|     count|
|:-----------------------|:-----|-------:|----------:|---------:|
| Australia              | AU   |      11|         28|    932355|
| Bosnia and Herzegovina | BA   |       4|         11|    204393|
| Bangladesh             | BD   |       1|          2|      6944|
| Brazil                 | BR   |      73|        113|   1436610|
| Canada                 | CA   |      11|        157|    752193|
| Chile                  | CL   |      99|        104|   2116543|
| China                  | CN   |       5|          6|     56021|
| Colombia               | CO   |       1|          1|      5421|
| Ethiopia               | ET   |       1|          1|      1718|
| United Kingdom         | GB   |     105|        152|   2015704|
| Indonesia              | ID   |       2|          3|     17601|
| Israel                 | IL   |       1|          1|      1826|
| India                  | IN   |      35|         85|   1648742|
| Mongolia               | MN   |       1|         12|   1042146|
| Mexico                 | MX   |       5|         48|    741490|
| Nigeria                | NG   |       1|          1|      2541|
| Netherlands            | NL   |      67|        109|   2462971|
| Peru                   | PE   |       1|         11|    249211|
| Philippines            | PH   |       1|          1|       958|
| Poland                 | PL   |      10|         15|    456354|
| Singapore              | SG   |       1|          1|      1275|
| Thailand               | TH   |      33|         61|   1243936|
| United States          | US   |     689|       1763|  11085357|
| Viet Nam               | VN   |       2|          3|     14321|
| Kosovo                 | XK   |       1|          1|      4886|

``` r
attr(countries_table, "meta")
```

    ## # A tibble: 1 × 6
    ##         name   license                  website  page limit found
    ##       <fctr>    <fctr>                   <fctr> <int> <int> <int>
    ## 1 openaq-api CC BY 4.0 https://docs.openaq.org/     1   100    25

``` r
attr(countries_table, "timestamp")
```

    ## # A tibble: 1 × 2
    ##             lastModif           queriedAt
    ##                <dttm>              <dttm>
    ## 1 2016-10-29 12:21:57 2016-10-29 12:27:29

The `aq_cities` function
------------------------

Using the `aq_cities` functions one can get all cities for which information is available within the platform. For each city, one gets the number of locations and the count of measures for the city, the URL encoded string, and the country it is in.

``` r
cities_table <- aq_cities()
kable(head(cities_table))
```

| city      | country |  locations|  count| cityURL   |
|:----------|:--------|----------:|------:|:----------|
| 76t       | TH      |          1|      4| 76t       |
| ABBEVILLE | US      |          1|   3419| ABBEVILLE |
| Aberdeen  | GB      |          3|  32917| Aberdeen  |
| Aberdeen  | US      |          2|   8539| Aberdeen  |
| ADA       | US      |          1|  10237| ADA       |
| ADAIR     | US      |          1|  14677| ADAIR     |

The optional `country` argument allows to do this for a given country instead of the whole world.

``` r
cities_tableIndia <- aq_cities(country="IN", limit = 10)
kable(cities_tableIndia)
```

| city       | country |  locations|   count| cityURL    |
|:-----------|:--------|----------:|-------:|:-----------|
| Agra       | IN      |          1|   25980| Agra       |
| Ahmedabad  | IN      |          1|   16941| Ahmedabad  |
| Aurangabad | IN      |          1|   15358| Aurangabad |
| Barddhaman | IN      |          3|    2470| Barddhaman |
| Bengaluru  | IN      |          5|   91293| Bengaluru  |
| Chandrapur | IN      |          2|   46612| Chandrapur |
| Chennai    | IN      |          4|   62457| Chennai    |
| Chittoor   | IN      |          1|    2013| Chittoor   |
| Delhi      | IN      |         15|  339118| Delhi      |
| Durgapur   | IN      |          1|    4865| Durgapur   |

If one inputs a country that is not in the platform (or misspells a code), then an error message is thrown.

``` r
#aq_cities(country="PANEM")
```

The `aq_locations` function
---------------------------

The `aq_locations` function has far more arguments than the first two functions. On can filter locations in a given country, city, location, for a given parameter (valid values are "pm25", "pm10", "so2", "no2", "o3", "co" and "bc"), from a given date and/or up to a given date, for values between a minimum and a maximum, for a given circle outside a central point by the use of the `latitude`, `longitude` and `radius` arguments. In the output table one also gets URL encoded strings for the city and the location. Below are several examples.

Here we only look for locations with PM2.5 information in Chennai, India.

``` r
locations_chennai <- aq_locations(country = "IN", city = "Chennai", parameter = "pm25")
kable(locations_chennai)
```

| location                    | city    | country | sourceName        |  count| lastUpdated         | firstUpdated        |  latitude|  longitude| pm25 | pm10  | no2   | so2   | o3    | co    | bc    | cityURL | locationURL                   |
|:----------------------------|:--------|:--------|:------------------|------:|:--------------------|:--------------------|---------:|----------:|:-----|:------|:------|:------|:------|:------|:------|:--------|:------------------------------|
| US Diplomatic Post: Chennai | Chennai | IN      | StateAir\_Chennai |   7567| 2016-10-29 12:30:00 | 2015-12-11 21:30:00 |  13.05237|   80.25193| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai | US+Diplomatic+Post%3A+Chennai |

Getting measurements
====================

Two functions allow to get data: `aq_measurement` and `aq_latest`. In both of them the arguments city and location needs to be given as URL encoded strings.

The `aq_measurements` function
------------------------------

The `aq_measurements` function has many arguments for getting a query specific to, say, a given parameter in a given location or for a given circle outside a central point by the use of the `latitude`, `longitude` and `radius` arguments. Below we get the PM2.5 measures for Anand Vihar in Delhi in India.

``` r
results_table <- aq_measurements(country = "IN", city = "Delhi", location = "Anand+Vihar", parameter = "pm25")
kable(head(results_table))
```

| location    | parameter |  value| unit  | country | city  | dateUTC             | dateLocal           |  latitude|  longitude| cityURL | locationURL |
|:------------|:----------|------:|:------|:--------|:------|:--------------------|:--------------------|---------:|----------:|:--------|:------------|
| Anand Vihar | pm25      |    293| µg/m³ | IN      | Delhi | 2016-10-29 11:35:00 | 2016-10-29 17:05:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |    234| µg/m³ | IN      | Delhi | 2016-10-29 11:05:00 | 2016-10-29 16:35:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |    234| µg/m³ | IN      | Delhi | 2016-10-29 10:35:00 | 2016-10-29 16:05:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |    276| µg/m³ | IN      | Delhi | 2016-10-29 10:05:00 | 2016-10-29 15:35:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |    276| µg/m³ | IN      | Delhi | 2016-10-29 09:35:00 | 2016-10-29 15:05:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |    301| µg/m³ | IN      | Delhi | 2016-10-29 09:05:00 | 2016-10-29 14:35:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |

One could also get all possible parameters in the same table.

The `aq_latest` function
------------------------

This function gives a table with all newest measures for the locations that are chosen by the arguments. If all arguments are `NULL`, it gives all the newest measures for all locations.

``` r
tableLatest <- aq_latest()
kable(head(tableLatest))
```

| location          | city                 | country |  latitude|  longitude| parameter |  value| lastUpdated         | unit  | cityURL              | locationURL       |
|:------------------|:---------------------|:--------|---------:|----------:|:----------|------:|:--------------------|:------|:---------------------|:------------------|
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| co        |    463| 2016-10-29 12:15:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| no2       |     36| 2016-10-29 12:15:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| o3        |     25| 2016-10-29 12:15:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| pm10      |    227| 2016-10-29 12:15:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| so2       |     22| 2016-10-29 12:15:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 16th and Whitmore | Omaha-Council Bluffs | US      |  41.32247|  -95.93799| o3        |      0| 2016-10-29 10:00:00 | ppm   | Omaha-Council+Bluffs | 16th+and+Whitmore |

Below are the latest values for Anand Vihar at the time this vignette was compiled (cache=FALSE).

``` r
tableLatest <- aq_latest(country="IN", city="Delhi", location="Anand+Vihar")
kable(head(tableLatest))
```

| location    | city  | country |  latitude|  longitude| parameter |   value| lastUpdated         | unit  | cityURL | locationURL |
|:------------|:------|:--------|---------:|----------:|:----------|-------:|:--------------------|:------|:--------|:------------|
| Anand Vihar | Delhi | IN      |   28.6508|    77.3152| co        |  1300.0| 2016-03-21 14:45:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |   28.6508|    77.3152| no2       |   174.6| 2016-10-29 11:35:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |   28.6508|    77.3152| o3        |    40.1| 2016-10-29 11:35:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |   28.6508|    77.3152| pm10      |   947.0| 2016-10-29 11:35:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |   28.6508|    77.3152| pm25      |   293.0| 2016-10-29 11:35:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |   28.6508|    77.3152| so2       |    18.0| 2016-03-21 14:45:00 | µg/m³ | Delhi   | Anand+Vihar |

Paging and limit
================

For all endpoints/functions, there a a `limit` and a `page` arguments, which indicate, respectively, how many results per page should be shown and which page should be queried. Based on this, how to get all results corresponding to a query? First, look at the number of results, e.g.

``` r
how_many <- attr(aq_measurements(city = "Delhi",
                            parameter = "pm25"), "meta")
knitr::kable(how_many)
```

| name       | license   | website                    |  page|  limit|  found|
|:-----------|:----------|:---------------------------|-----:|------:|------:|
| openaq-api | CC BY 4.0 | <https://docs.openaq.org/> |     1|    100|  59503|

``` r
how_many$found
```

    ## [1] 59503

Then one can write a loop over pages. Note that the maximal value of `limit` is 1000.

``` r
meas <- NULL
for (page in 1:(ceiling(how_many$found/1000))){
  meas <- dplyr::bind_rows(meas,
                aq_measurements(city = "Delhi",
                                parameter = "pm25",
                                page = page,
                                limit = 1000))
  }
```

If you really need a lot of data, maybe using the API and this package is not the best choice for you. You can look into downloading csv data from OpenAQ website, e.g. [here](https://openaq.org/#/locations?_k=jk7d09) or the daily csv output [here](http://openaq-data.s3.amazonaws.com/index.html). Or you might want to contact OpenAQ.

Other packages of interest for getting air quality data
=======================================================

-   The [`rdefra` package](https://github.com/kehraProject/r_rdefra), also part of the rOpenSci project, allows to to interact with the UK AIR pollution database from DEFRA, including historical measures.

-   The [`openair` package](https://github.com/davidcarslaw/openair) gives access to the same data as `rdefra` but relies on a local and compressed copy of the data on servers at King's College (UK), periodically updated.

-   The [`usaqmindia` package](https://github.com/masalmon/usaqmindia) provides data from the US air quality monitoring program in India for Delhi, Mumbai, Chennai, Hyderabad and Kolkata from 2013.

Meta
----

-   Please [report any issues or bugs](https://github.com/ropenscilabs/ropenaq/issues).
-   License: GPL
-   Get citation information for `ropenaq` in R doing `citation(package = 'ropenaq')`
-   Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci\_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
