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

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/ropenaq)](http://cran.r-project.org/package=ropenaq) [![Build Status](https://travis-ci.org/ropensci/ropenaq.svg?branch=master)](https://travis-ci.org/ropensci/ropenaq) [![Build status](https://ci.appveyor.com/api/projects/status/qurhlh0j8ra3qors?svg=true)](https://ci.appveyor.com/project/ropensci/ropenaq) [![codecov.io](https://codecov.io/github/ropensci/ropenaq/coverage.svg?branch=master)](https://codecov.io/github/ropensci/Ropenaq?branch=master)

Installation
============

Install the package with:

``` r
install.packages("ropenaq")
```

Or install the development version using [devtools](https://github.com/hadley/devtools) with:

``` r
library("devtools")
install_github("ropensci/ropenaq")
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

| name                                       | code |  cities|  locations|     count|
|:-------------------------------------------|:-----|-------:|----------:|---------:|
| Argentina                                  | AR   |       1|          1|      2448|
| Austria                                    | AT   |     370|        370|    149732|
| Australia                                  | AU   |      56|         56|   1217398|
| Bosnia and Herzegovina                     | BA   |      11|         11|    305480|
| Bangladesh                                 | BD   |       2|          2|      9658|
| Belgium                                    | BE   |      98|         98|    200781|
| Bahrain                                    | BH   |       1|          1|      1913|
| Brazil                                     | BR   |     144|        144|   1886225|
| Canada                                     | CA   |     157|        157|   1147776|
| Chile                                      | CL   |     158|        158|   2767623|
| China                                      | CN   |       6|          6|     69586|
| Colombia                                   | CO   |       1|          1|      8133|
| Czech Republic                             | CZ   |     102|        102|    175238|
| Germany                                    | DE   |     651|        651|    331497|
| Denmark                                    | DK   |      13|         13|     19059|
| Spain                                      | ES   |     555|        555|    512576|
| Ethiopia                                   | ET   |       2|          2|      6900|
| Finland                                    | FI   |      68|         68|     24846|
| France                                     | FR   |     598|        598|     89481|
| United Kingdom                             | GB   |     160|        160|   2842151|
| Gibraltar                                  | GI   |       3|          3|      1606|
| Croatia                                    | HR   |      31|         31|     20930|
| Hungary                                    | HU   |      25|         25|      2581|
| Indonesia                                  | ID   |       3|          3|     23027|
| Ireland                                    | IE   |      12|         12|      1587|
| Israel                                     | IL   |       1|          1|      1826|
| India                                      | IN   |      93|         93|   2758544|
| Kuwait                                     | KW   |       1|          1|        41|
| Macedonia, the Former Yugoslav Republic of | MK   |      30|         30|     21709|
| Mongolia                                   | MN   |      12|         12|   1395501|
| Mexico                                     | MX   |      48|         48|   1085772|
| Nigeria                                    | NG   |       1|          1|      2541|
| Netherlands                                | NL   |     110|        110|   3192322|
| Norway                                     | NO   |      64|         64|    235257|
| Peru                                       | PE   |      11|         11|    380392|
| Philippines                                | PH   |       1|          1|       958|
| Poland                                     | PL   |      16|         16|    547921|
| Sweden                                     | SE   |      11|         11|      6669|
| Singapore                                  | SG   |       1|          1|      1275|
| Thailand                                   | TH   |      63|         63|   1596296|
| Turkey                                     | TR   |     138|        138|    562086|
| Taiwan, Province of China                  | TW   |      67|         67|    556448|
| Uganda                                     | UG   |       1|          1|        37|
| United States                              | US   |    1851|       1851|  16033724|
| Viet Nam                                   | VN   |       3|          3|     19747|
| Kosovo                                     | XK   |       1|          1|      7598|

``` r
attr(countries_table, "meta")
```

    ## # A tibble: 1 × 6
    ##         name   license                  website  page limit found
    ##       <fctr>    <fctr>                   <fctr> <int> <int> <int>
    ## 1 openaq-api CC BY 4.0 https://docs.openaq.org/     1   100    46

``` r
attr(countries_table, "timestamp")
```

    ## # A tibble: 1 × 1
    ##             queriedAt
    ##                <dttm>
    ## 1 2017-02-19 14:12:00

The `aq_cities` function
------------------------

Using the `aq_cities` functions one can get all cities for which information is available within the platform. For each city, one gets the number of locations and the count of measures for the city, the URL encoded string, and the country it is in.

``` r
cities_table <- aq_cities()
kable(head(cities_table))
```

| city      | country |  locations|  count| cityURL   |
|:----------|:--------|----------:|------:|:----------|
| ABBEVILLE | US      |          1|   4619| ABBEVILLE |
| Aberdeen  | GB      |          3|  46181| Aberdeen  |
| Aberdeen  | US      |          2|  12733| Aberdeen  |
| ADA       | US      |          1|  15246| ADA       |
| ADAIR     | US      |          1|  26640| ADAIR     |
| ADAMS     | US      |          2|  21388| ADAMS     |

The optional `country` argument allows to do this for a given country instead of the whole world.

``` r
cities_tableIndia <- aq_cities(country="IN", limit = 10)
kable(cities_tableIndia)
```

| city       | country |  locations|   count| cityURL    |
|:-----------|:--------|----------:|-------:|:-----------|
| Agra       | IN      |          1|   37226| Agra       |
| Ahmedabad  | IN      |          1|   31510| Ahmedabad  |
| Aurangabad | IN      |          1|   44989| Aurangabad |
| Barddhaman | IN      |          3|    2470| Barddhaman |
| Bengaluru  | IN      |          5|  159902| Bengaluru  |
| Chandrapur | IN      |          2|   91648| Chandrapur |
| Chennai    | IN      |          4|  101627| Chennai    |
| Chittoor   | IN      |          1|    2013| Chittoor   |
| Delhi      | IN      |         16|  513453| Delhi      |
| Durgapur   | IN      |          1|   17698| Durgapur   |

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

| location                    | city    | country |  count| sourceNames       | lastUpdated | firstUpdated | sourceName        |  latitude|  longitude| pm25 | pm10  | no2   | so2   | o3    | co    | bc    | cityURL | locationURL                   |
|:----------------------------|:--------|:--------|------:|:------------------|:------------|:-------------|:------------------|---------:|----------:|:-----|:------|:------|:------|:------|:------|:------|:--------|:------------------------------|
| Alandur Bus Depot           | Chennai | IN      |     35| CPCB              | 1487511900  | 1487450700   | CPCB              |  12.99711|   80.19152| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai | Alandur+Bus+Depot             |
| IIT                         | Chennai | IN      |     51| CPCB              | 1487511900  | 1487451600   | CPCB              |  12.99251|   80.23745| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai | IIT                           |
| Manali                      | Chennai | IN      |     35| CPCB              | 1487511900  | 1487452500   | CPCB              |  13.16454|   80.26285| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai | Manali                        |
| US Diplomatic Post: Chennai | Chennai | IN      |  10280| StateAir\_Chennai | 1487511000  | 1449869400   | StateAir\_Chennai |  13.08784|   80.27847| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai | US+Diplomatic+Post%3A+Chennai |

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
| Anand Vihar | pm25      |     86| µg/m³ | IN      | Delhi | 2017-02-19 13:25:00 | 2017-02-19 18:55:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     86| µg/m³ | IN      | Delhi | 2017-02-19 12:55:00 | 2017-02-19 18:25:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     67| µg/m³ | IN      | Delhi | 2017-02-19 12:25:00 | 2017-02-19 17:55:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     67| µg/m³ | IN      | Delhi | 2017-02-19 11:55:00 | 2017-02-19 17:25:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     46| µg/m³ | IN      | Delhi | 2017-02-19 11:25:00 | 2017-02-19 16:55:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     46| µg/m³ | IN      | Delhi | 2017-02-19 10:55:00 | 2017-02-19 16:25:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |

One could also get all possible parameters in the same table.

The `aq_latest` function
------------------------

This function gives a table with all newest measures for the locations that are chosen by the arguments. If all arguments are `NULL`, it gives all the newest measures for all locations.

``` r
tableLatest <- aq_latest()
kable(head(tableLatest))
```

| location          | city                 | country |  latitude|  longitude| parameter |     value| lastUpdated         | unit  | sourceName | cityURL              | locationURL       |
|:------------------|:---------------------|:--------|---------:|----------:|:----------|---------:|:--------------------|:------|:-----------|:---------------------|:------------------|
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| co        |  2556.000| 2017-02-19 13:45:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| no2       |    68.000| 2017-02-19 13:45:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| o3        |    14.000| 2017-02-19 13:45:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| pm10      |   172.000| 2017-02-19 13:45:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| so2       |    38.000| 2017-02-19 13:45:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 16th and Whitmore | Omaha-Council Bluffs | US      |  41.32247|  -95.93799| o3        |     0.001| 2016-11-01 13:00:00 | ppm   | AirNow     | Omaha-Council+Bluffs | 16th+and+Whitmore |

Below are the latest values for Anand Vihar at the time this vignette was compiled (cache=FALSE).

``` r
tableLatest <- aq_latest(country="IN", city="Delhi", location="Anand+Vihar")
kable(head(tableLatest))
```

| location    | city  | country |  latitude|  longitude| parameter |   value| lastUpdated         | unit  | sourceName  | cityURL | locationURL |
|:------------|:------|:--------|---------:|----------:|:----------|-------:|:--------------------|:------|:------------|:--------|:------------|
| Anand Vihar | Delhi | IN      |   28.6508|    77.3152| co        |  1300.0| 2016-03-21 14:45:00 | µg/m³ | Anand Vihar | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |   28.6508|    77.3152| no2       |   109.4| 2017-02-19 13:25:00 | µg/m³ | CPCB        | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |   28.6508|    77.3152| o3        |    11.8| 2017-02-19 13:25:00 | µg/m³ | CPCB        | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |   28.6508|    77.3152| pm10      |   511.0| 2017-02-19 13:25:00 | µg/m³ | CPCB        | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |   28.6508|    77.3152| pm25      |    86.0| 2017-02-19 13:25:00 | µg/m³ | CPCB        | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |   28.6508|    77.3152| so2       |    18.0| 2016-03-21 14:45:00 | µg/m³ | Anand Vihar | Delhi   | Anand+Vihar |

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
| openaq-api | CC BY 4.0 | <https://docs.openaq.org/> |     1|    100|  93892|

``` r
how_many$found
```

    ## [1] 93892

Then one can write a loop over pages. Note that the maximal value of `limit` is 10,000.

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

-   Please [report any issues or bugs](https://github.com/ropensci/ropenaq/issues).
-   License: GPL
-   Get citation information for `ropenaq` in R doing `citation(package = 'ropenaq')`
-   Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci\_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
