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

Check out [this blog post](https://ropensci.org/blog/blog/2017/02/21/ropenaq) about OpenAQ.

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
| Austria                                    | AT   |      16|        303|   1082152|
| Australia                                  | AU   |      16|         56|   1698276|
| Bosnia and Herzegovina                     | BA   |       8|         17|    427560|
| Bangladesh                                 | BD   |       1|          2|     12262|
| Belgium                                    | BE   |       3|         99|    735871|
| Bahrain                                    | BH   |       1|          1|      6068|
| Brazil                                     | BR   |      72|        119|   2337002|
| Canada                                     | CA   |      11|        163|   1608027|
| Chile                                      | CL   |     120|        110|   3331838|
| China                                      | CN   |       5|          6|     82606|
| Colombia                                   | CO   |       1|          1|     10737|
| Czech Republic                             | CZ   |       1|        102|    324662|
| Germany                                    | DE   |      20|        595|   2996016|
| Denmark                                    | DK   |       2|         13|     70562|
| Spain                                      | ES   |      24|        522|   2895990|
| Ethiopia                                   | ET   |       1|          2|     12105|
| Finland                                    | FI   |      20|         58|    224631|
| France                                     | FR   |      33|        612|   2486873|
| United Kingdom                             | GB   |     112|        162|   3655544|
| Gibraltar                                  | GI   |       1|          3|     13357|
| Croatia                                    | HR   |       5|         32|     97410|
| Hungary                                    | HU   |       2|         25|    117296|
| Indonesia                                  | ID   |       2|          3|     28233|
| Ireland                                    | IE   |       1|         12|     40029|
| Israel                                     | IL   |       1|          1|      1826|
| India                                      | IN   |      42|         99|   4018006|
| Kuwait                                     | KW   |       1|          1|      2644|
| Macedonia, the Former Yugoslav Republic of | MK   |       2|         15|    138246|
| Mongolia                                   | MN   |       1|         12|   1737225|
| Mexico                                     | MX   |       5|         78|   1466457|
| Nigeria                                    | NG   |       1|          1|      2541|
| Netherlands                                | NL   |      67|        110|   3888555|
| Norway                                     | NO   |      29|         64|    554549|
| Nepal                                      | NP   |       1|          2|      7412|
| Peru                                       | PE   |       1|         11|    423872|
| Philippines                                | PH   |       1|          1|       958|
| Poland                                     | PL   |      10|         16|    547921|
| Sweden                                     | SE   |       3|         11|     69306|
| Singapore                                  | SG   |       1|          1|      1275|
| Thailand                                   | TH   |      33|         63|   1950680|
| Turkey                                     | TR   |      40|        134|   1667203|
| Taiwan, Province of China                  | TW   |       8|         67|   1541848|
| Uganda                                     | UG   |       1|          1|      2639|
| United States                              | US   |     721|       1857|  21601138|
| Viet Nam                                   | VN   |       2|          3|     24954|
| Kosovo                                     | XK   |       1|          1|     10202|

``` r
attr(countries_table, "meta")
```

    ## # A tibble: 1 x 6
    ##         name   license                  website  page limit found
    ##       <fctr>    <fctr>                   <fctr> <int> <int> <int>
    ## 1 openaq-api CC BY 4.0 https://docs.openaq.org/     1   100    47

``` r
attr(countries_table, "timestamp")
```

    ## # A tibble: 1 x 1
    ##             queriedAt
    ##                <dttm>
    ## 1 2017-06-08 07:09:58

The `aq_cities` function
------------------------

Using the `aq_cities` functions one can get all cities for which information is available within the platform. For each city, one gets the number of locations and the count of measures for the city, the URL encoded string, and the country it is in.

``` r
cities_table <- aq_cities()
kable(head(cities_table))
```

| city       | country |  locations|  count| cityURL    |
|:-----------|:--------|----------:|------:|:-----------|
| 21 de mayo | CL      |          1|      2| 21+de+mayo |
| ABBEVILLE  | US      |          1|   4619| ABBEVILLE  |
| Aberdeen   | GB      |          3|  59312| Aberdeen   |
| Aberdeen   | US      |          2|  17122| Aberdeen   |
| ADA        | US      |          1|  17323| ADA        |
| ADAIR      | US      |          1|  37698| ADAIR      |

The optional `country` argument allows to do this for a given country instead of the whole world.

``` r
cities_tableIndia <- aq_cities(country="IN", limit = 10)
kable(cities_tableIndia)
```

| city             | country |  locations|   count| cityURL          |
|:-----------------|:--------|----------:|-------:|:-----------------|
| Agra             | IN      |          1|   50273| Agra             |
| Ahmedabad        | IN      |          1|   37016| Ahmedabad        |
| Amritsar         | IN      |          1|   22395| Amritsar         |
| Aurangabad       | IN      |          1|   67128| Aurangabad       |
| Barddhaman       | IN      |          3|    2470| Barddhaman       |
| Bengaluru        | IN      |          5|  230192| Bengaluru        |
| Chandrapur       | IN      |          2|  136877| Chandrapur       |
| Chennai          | IN      |          4|  166432| Chennai          |
| Chittoor         | IN      |          1|    2013| Chittoor         |
| Delhi            | IN      |         16|  687736| Delhi            |
| Vijayawara       | IN      |          1|    6190| Vijayawara       |
| Visakhapatnam    | IN      |          6|  104883| Visakhapatnam    |
| Jodhpur          | IN      |          1|  102093| Jodhpur          |
| Jorapokhar       | IN      |          1|   18092| Jorapokhar       |
| Kanpur           | IN      |          2|  125614| Kanpur           |
| Kolkata          | IN      |          5|  139419| Kolkata          |
| Lucknow          | IN      |          4|  146590| Lucknow          |
| Ludhiana         | IN      |          1|   14456| Ludhiana         |
| Mandi Gobindgarh | IN      |          1|   14967| Mandi+Gobindgarh |
| Medak            | IN      |          1|    2671| Medak            |
| Mumbai           | IN      |          3|  223240| Mumbai           |
| Muzaffarpur      | IN      |          1|   85886| Muzaffarpur      |
| Dhanbad          | IN      |          1|       3| Dhanbad          |
| Durgapur         | IN      |          1|   42448| Durgapur         |
| Faridabad        | IN      |          1|   71353| Faridabad        |
| Gaya             | IN      |          1|   55280| Gaya             |
| Ghaziabad        | IN      |          2|   24580| Ghaziabad        |
| Gurgaon          | IN      |          1|   85753| Gurgaon          |
| Haldia           | IN      |          1|   71773| Haldia           |
| Howrah           | IN      |          1|   31872| Howrah           |
| Hyderabad        | IN      |         10|  251480| Hyderabad        |
| Jaipur           | IN      |          1|  109906| Jaipur           |
| Nagpur           | IN      |          5|   49338| Nagpur           |
| Nashik           | IN      |          4|   38275| Nashik           |
| Panchkula        | IN      |          1|   95113| Panchkula        |
| Patna            | IN      |          1|   46193| Patna            |
| Pune             | IN      |          1|   97531| Pune             |
| Rohtak           | IN      |          1|   59347| Rohtak           |
| Solapur          | IN      |          1|  198868| Solapur          |
| Thane            | IN      |          3|   76978| Thane            |
| Tirupati         | IN      |          3|   92417| Tirupati         |
| Varanasi         | IN      |          1|  132865| Varanasi         |

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
| Alandur Bus Depot           | Chennai | IN      |   4988| CPCB              | 1496904300  | 1487450700   | CPCB              |  12.99711|   80.19152| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai | Alandur+Bus+Depot             |
| IIT                         | Chennai | IN      |   6869| CPCB              | 1496904300  | 1487442600   | CPCB              |  12.99251|   80.23745| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai | IIT                           |
| Manali                      | Chennai | IN      |   6785| CPCB              | 1496904300  | 1487452500   | CPCB              |  13.16454|   80.26285| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai | Manali                        |
| US Diplomatic Post: Chennai | Chennai | IN      |  12884| StateAir\_Chennai | 1496903400  | 1449869400   | StateAir\_Chennai |  13.08784|   80.27847| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai | US+Diplomatic+Post%3A+Chennai |

Getting measurements
====================

Two functions allow to get data: `aq_measurement` and `aq_latest`. In both of them the arguments city and location needs to be given as URL encoded strings.

The `aq_measurements` function
------------------------------

The `aq_measurements` function has many arguments for getting a query specific to, say, a given parameter in a given location or for a given circle outside a central point by the use of the `latitude`, `longitude` and `radius` arguments. Below we get the PM2.5 measures for Delhi in India.

``` r
results_table <- aq_measurements(country = "IN", city = "Delhi", parameter = "pm25")
kable(head(results_table))
```

| location                       | parameter |  value| unit  | country | city  |  latitude|  longitude| dateUTC             | dateLocal           | cityURL | locationURL                    |
|:-------------------------------|:----------|------:|:------|:--------|:------|---------:|----------:|:--------------------|:--------------------|:--------|:-------------------------------|
| Siri Fort                      | pm25      |   48.0| µg/m³ | IN      | Delhi |        NA|         NA| 2017-04-26 22:00:00 | 2017-04-27 03:30:00 | Delhi   | Siri+Fort                      |
| Income Tax Office              | pm25      |   78.0| µg/m³ | IN      | Delhi |   28.6235|    77.2494| 2017-04-26 22:00:00 | 2017-04-27 03:30:00 | Delhi   | Income+Tax+Office              |
| Shadipur                       | pm25      |   62.3| µg/m³ | IN      | Delhi |   28.6517|    77.1581| 2017-04-26 22:00:00 | 2017-04-27 03:30:00 | Delhi   | Shadipur                       |
| NSIT Dwarka                    | pm25      |   91.4| µg/m³ | IN      | Delhi |   28.5910|    77.0500| 2017-04-26 21:45:00 | 2017-04-27 03:15:00 | Delhi   | NSIT+Dwarka                    |
| Delhi Technological University | pm25      |  128.0| µg/m³ | IN      | Delhi |   28.7440|    77.1200| 2017-04-26 21:45:00 | 2017-04-27 03:15:00 | Delhi   | Delhi+Technological+University |
| Shadipur                       | pm25      |   62.3| µg/m³ | IN      | Delhi |   28.6517|    77.1581| 2017-04-26 21:45:00 | 2017-04-27 03:15:00 | Delhi   | Shadipur                       |

One could also get all possible parameters in the same table.

The `aq_latest` function
------------------------

This function gives a table with all newest measures for the locations that are chosen by the arguments. If all arguments are `NULL`, it gives all the newest measures for all locations.

``` r
tableLatest <- aq_latest()
kable(head(tableLatest))
```

| location          | city                 | country |  latitude|  longitude| parameter |    value| lastUpdated         | unit  | sourceName | cityURL              | locationURL       |
|:------------------|:---------------------|:--------|---------:|----------:|:----------|--------:|:--------------------|:------|:-----------|:---------------------|:------------------|
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| co        |  225.000| 2017-06-05 08:30:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| no2       |   14.000| 2017-06-05 08:30:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| o3        |   87.000| 2017-06-05 08:30:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| pm10      |   74.000| 2017-06-05 08:30:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| so2       |    1.000| 2017-06-05 08:30:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 16th and Whitmore | Omaha-Council Bluffs | US      |  41.32247|  -95.93799| o3        |    0.029| 2017-06-08 05:00:00 | ppm   | AirNow     | Omaha-Council+Bluffs | 16th+and+Whitmore |

Below are the latest values for Hyderabad at the time this vignette was compiled.

``` r
tableLatest <- aq_latest(country="IN", city="Hyderabad")
kable(head(tableLatest))
```

| location                                    | city      | country |  latitude|  longitude| parameter |  value| lastUpdated         | unit  | sourceName | cityURL   | locationURL                                   |
|:--------------------------------------------|:----------|:--------|---------:|----------:|:----------|------:|:--------------------|:------|:-----------|:----------|:----------------------------------------------|
| Bollaram Industrial Area                    | Hyderabad | IN      |        NA|         NA| co        |  420.0| 2017-02-17 05:15:00 | µg/m³ | CPCB       | Hyderabad | Bollaram+Industrial+Area                      |
| Bollaram Industrial Area                    | Hyderabad | IN      |        NA|         NA| no2       |   16.2| 2017-02-17 05:15:00 | µg/m³ | CPCB       | Hyderabad | Bollaram+Industrial+Area                      |
| Bollaram Industrial Area                    | Hyderabad | IN      |        NA|         NA| pm10      |  137.0| 2017-02-17 05:15:00 | µg/m³ | CPCB       | Hyderabad | Bollaram+Industrial+Area                      |
| Bollaram Industrial Area                    | Hyderabad | IN      |        NA|         NA| pm25      |   55.0| 2017-02-17 05:15:00 | µg/m³ | CPCB       | Hyderabad | Bollaram+Industrial+Area                      |
| Bollaram Industrial Area                    | Hyderabad | IN      |        NA|         NA| so2       |   16.8| 2017-02-17 05:15:00 | µg/m³ | CPCB       | Hyderabad | Bollaram+Industrial+Area                      |
| Bollaram Industrial Area, Hyderabad - TSPCB | Hyderabad | IN      |        NA|         NA| co        |  600.0| 2017-06-08 06:15:00 | µg/m³ | CPCB       | Hyderabad | Bollaram+Industrial+Area%2C+Hyderabad+-+TSPCB |

Paging and limit
================

For all endpoints/functions, there a a `limit` and a `page` arguments, which indicate, respectively, how many results per page should be shown and which page should be queried. If you don't enter the parameters by default all results for the query will be retrieved with async requests, but it might take a while nonetheless depending on the total number of results.

``` r
aq_measurements(city = "Delhi",
                            parameter = "pm25")
```

If you really need a lot of data, maybe using the API and this package is not the best choice for you. You can look into downloading csv data from OpenAQ website, e.g. [here](https://openaq.org/#/locations?_k=jk7d09) or the daily csv output [here](http://openaq-data.s3.amazonaws.com/index.html). Or you might want to contact OpenAQ.

Other packages of interest for getting air quality data
=======================================================

-   The [`rdefra` package](https://github.com/kehraProject/r_rdefra), also part of the rOpenSci project, allows to to interact with the UK AIR pollution database from DEFRA, including historical measures.

-   The [`openair` package](https://github.com/davidcarslaw/openair) gives access to the same data as `rdefra` but relies on a local and compressed copy of the data on servers at King's College (UK), periodically updated.

-   The [`usaqmindia` package](https://github.com/masalmon/usaqmindia) provides data from the US air quality monitoring program in India for Delhi, Mumbai, Chennai, Hyderabad and Kolkata from 2013. \#\# Meta

-   Please [report any issues or bugs](https://github.com/ropensci/ropenaq/issues).
-   License: GPL
-   Get citation information for `ropenaq` in R doing `citation(package = 'ropenaq')`
-   Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci\_footer](http://www.ropensci.org/public_images/github_footer.png)](http://ropensci.org)
