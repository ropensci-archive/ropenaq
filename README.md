Ropenaq
=======

[![Build Status](https://travis-ci.org/masalmon/Ropenaq.svg)](https://travis-ci.org/masalmon/Ropenaq) [![Build status](https://ci.appveyor.com/api/projects/status/dgh82o8ldlgl6qrq?svg=true)](https://ci.appveyor.com/project/masalmon/ropenaq) [![codecov.io](https://codecov.io/github/masalmon/Ropenaq/coverage.svg?branch=master)](https://codecov.io/github/masalmon/Ropenaq?branch=master)

Installation
============

To install the package, you will need the devtools package.

``` r
library("devtools")
install_github("masalmon/Ropenaq")
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

Finding data availability
=========================

Three functions of the package allow to get lists of available information. Measurements are obtained from *locations* that are in *cities* that are in *countries*.

The `aq_countries` function
---------------------------

The `aq_countries` function allows to see for which countries information is available within the platform. It is the easiest function because it does not have any argument. The code for each country is its ISO 3166-1 alpha-2 code.

``` r
library("Ropenaq")
countriesTable <- aq_countries()
library("knitr")
kable(countriesTable)
```

|   count| code | name           |
|-------:|:-----|:---------------|
|  357095| TH   | Thailand       |
|   13341| CN   | China          |
|  397838| MN   | Mongolia       |
|  106680| GB   | United Kingdom |
|  629613| CL   | Chile          |
|  182828| US   | United States  |
|  271617| AU   | Australia      |
|  118166| IN   | India          |
|    1226| VN   | Viet Nam       |
|  420580| BR   | Brazil         |
|  161136| PL   | Poland         |
|  797574| NL   | Netherlands    |
|    2052| ID   | Indonesia      |

The `aq_cities` function
------------------------

Using the `aq_cities` functions one can get all cities for which information is available within the platform. For each city, one gets the number of locations and the count of measures for the city, the URL encoded string, and the country it is in.

``` r
citiesTable <- aq_cities()
kable(head(citiesTable))
```

| city         | country |   count|  locations| cityURL      |
|:-------------|:--------|-------:|----------:|:-------------|
| Amsterdam    | NL      |  102825|         14| Amsterdam    |
| Andacollo    | CL      |    2685|          1| Andacollo    |
| Antofagasta  | CL      |    4967|          1| Antofagasta  |
| Arica        | CL      |    2416|          1| Arica        |
| Ayutthaya    | TH      |    6771|          1| Ayutthaya    |
| Badhoevedorp | NL      |   11322|          1| Badhoevedorp |

The optional `country` argument allows to do this for a given country instead of the whole world.

``` r
citiesTableIndia <- aq_cities(country="IN")
kable(citiesTableIndia)
```

| city      | country |   count|  locations| cityURL   |
|:----------|:--------|-------:|----------:|:----------|
| Chennai   | IN      |    1228|          1| Chennai   |
| Delhi     | IN      |  113257|          5| Delhi     |
| Hyderabad | IN      |    1227|          1| Hyderabad |
| Kolkata   | IN      |    1227|          1| Kolkata   |
| Mumbai    | IN      |    1227|          1| Mumbai    |

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
| Anand Vihar                   | Delhi     | IN      | Anand Vihar         |   4019| 1454919000  | 1435588200   | pm25       |         NA|        NA| Delhi     | Anand+Vihar                     |
| Mandir Marg                   | Delhi     | IN      | Mandir Marg         |   6051| 1454910300  | 1435588200   | pm25       |         NA|        NA| Delhi     | Mandir+Marg                     |
| Punjabi Bagh                  | Delhi     | IN      | Punjabi Bagh        |   5890| 1454921700  | 1435537800   | pm25       |         NA|        NA| Delhi     | Punjabi+Bagh                    |
| RK Puram                      | Delhi     | IN      | RK Puram            |   6318| 1454922000  | 1435588200   | pm25       |         NA|        NA| Delhi     | RK+Puram                        |
| US Diplomatic Post: Chennai   | Chennai   | IN      | StateAir\_Chennai   |   1228| 1454729400  | 1449869400   | pm25       |   80.25193|  13.05237| Chennai   | US+Diplomatic+Post%3A+Chennai   |
| US Diplomatic Post: Hyderabad | Hyderabad | IN      | StateAir\_Hyderabad |   1227| 1454729400  | 1449869400   | pm25       |   78.47489|  17.44346| Hyderabad | US+Diplomatic+Post%3A+Hyderabad |
| US Diplomatic Post: Kolkata   | Kolkata   | IN      | StateAir\_Kolkata   |   1227| 1454729400  | 1449869400   | pm25       |   88.35105|  22.54714| Kolkata   | US+Diplomatic+Post%3A+Kolkata   |
| US Diplomatic Post: Mumbai    | Mumbai    | IN      | StateAir\_Mumbai    |   1227| 1454729400  | 1449869400   | pm25       |   72.86870|  19.06602| Mumbai    | US+Diplomatic+Post%3A+Mumbai    |
| US Diplomatic Post: New Delhi | Delhi     | IN      | StateAir\_NewDelhi  |   1280| 1454920200  | 1449869400   | pm25       |   77.18907|  28.59810| Delhi     | US+Diplomatic+Post%3A+New+Delhi |

Getting data
============

Two functions allow to get data: `aq_measurement` and `aq_latest`. In both of them the arguments city and location needs to be given as URL encoded strings.

The `aq_measurements` function
------------------------------

The `aq_measurements` function has many arguments for getting a query specific to, say, a given parameter in a given location. Below we get the PM2.5 measures for Anand Vihar in Delhi in India.

``` r
tableResults <- aq_measurements(country="IN", city="Delhi", location="Anand+Vihar", parameter="pm25")
```

    ## Warning in getResults(urlAQ, argsList): Your query has yielded 4019
    ## measurements. With the limit of 100 you will need to query 41 pages to
    ## get them all. You can write a loop where you change the page argument of
    ## the aq_measurements function, and if needed of the limit argument with
    ## limit<=1000.

``` r
kable(head(tableResults))
```

| location    | parameter |  value| unit  | country | city  | cityURL | locationURL | dateUTC             | dateLocal           | latitude | longitude |
|:------------|:----------|------:|:------|:--------|:------|:--------|:------------|:--------------------|:--------------------|:---------|:----------|
| Anand Vihar | pm25      |     63| µg/m³ | IN      | Delhi | Delhi   | Anand+Vihar | 2016-02-08 08:10:00 | 2016-02-08 08:10:00 | NA       | NA        |
| Anand Vihar | pm25      |     63| µg/m³ | IN      | Delhi | Delhi   | Anand+Vihar | 2016-02-08 08:00:00 | 2016-02-08 08:00:00 | NA       | NA        |
| Anand Vihar | pm25      |    121| µg/m³ | IN      | Delhi | Delhi   | Anand+Vihar | 2016-02-08 07:20:00 | 2016-02-08 07:20:00 | NA       | NA        |
| Anand Vihar | pm25      |    121| µg/m³ | IN      | Delhi | Delhi   | Anand+Vihar | 2016-02-08 07:00:00 | 2016-02-08 07:00:00 | NA       | NA        |
| Anand Vihar | pm25      |    158| µg/m³ | IN      | Delhi | Delhi   | Anand+Vihar | 2016-02-08 06:20:00 | 2016-02-08 06:20:00 | NA       | NA        |
| Anand Vihar | pm25      |    158| µg/m³ | IN      | Delhi | Delhi   | Anand+Vihar | 2016-02-08 05:55:00 | 2016-02-08 05:55:00 | NA       | NA        |

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
| 100 ail    | Ulaanbaatar | MN      |  106.92138|   47.93291| co        |  1338.00| 2016-02-08 09:15:00 | µg/m³ | Ulaanbaatar | 100+ail     |
| 100 ail    | Ulaanbaatar | MN      |  106.92138|   47.93291| no2       |    66.00| 2016-02-08 09:15:00 | µg/m³ | Ulaanbaatar | 100+ail     |
| 100 ail    | Ulaanbaatar | MN      |  106.92138|   47.93291| o3        |    14.00| 2016-02-08 09:15:00 | µg/m³ | Ulaanbaatar | 100+ail     |
| 100 ail    | Ulaanbaatar | MN      |  106.92138|   47.93291| pm10      |   200.00| 2016-02-08 09:15:00 | µg/m³ | Ulaanbaatar | 100+ail     |
| 100 ail    | Ulaanbaatar | MN      |  106.92138|   47.93291| so2       |   119.00| 2016-02-08 09:15:00 | µg/m³ | Ulaanbaatar | 100+ail     |
| 21 de mayo | Los Angeles | CL      |  -72.36146|  -37.47118| pm10      |    41.34| 2016-02-08 02:00:00 | µg/m³ | Los+Angeles | 21+de+mayo  |

Below are the latest values for Anand Vihar at the time this vignette was compiled (cache=FALSE).

``` r
tableLatest <- aq_latest(country="IN", city="Delhi", location="Anand+Vihar")
kable(head(tableLatest))
```

| location    | city  | country | latitude | longitude | parameter |  value| lastUpdated         | unit  | cityURL | locationURL |
|:------------|:------|:--------|:---------|:----------|:----------|------:|:--------------------|:------|:--------|:------------|
| Anand Vihar | Delhi | IN      | NA       | NA        | co        |  600.0| 2016-02-08 08:10:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | NA       | NA        | no2       |   73.7| 2016-02-08 08:10:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | NA       | NA        | o3        |   25.2| 2016-02-08 08:10:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | NA       | NA        | pm10      |  188.0| 2016-02-08 08:10:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | NA       | NA        | pm25      |   63.0| 2016-02-08 08:10:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | NA       | NA        | so2       |   20.7| 2016-02-08 08:10:00 | µg/m³ | Delhi   | Anand+Vihar |
