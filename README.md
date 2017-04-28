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
| Austria                                    | AT   |     370|        370|    846350|
| Australia                                  | AU   |      56|         56|   1518432|
| Bosnia and Herzegovina                     | BA   |      12|         12|    364986|
| Bangladesh                                 | BD   |       2|          2|     11284|
| Belgium                                    | BE   |      99|         99|    595381|
| Bahrain                                    | BH   |       1|          1|      4112|
| Brazil                                     | BR   |     148|        148|   2163751|
| Canada                                     | CA   |     157|        157|   1408289|
| Chile                                      | CL   |     168|        168|   3133655|
| China                                      | CN   |       6|          6|     77716|
| Colombia                                   | CO   |       1|          1|      9759|
| Czech Republic                             | CZ   |     102|        102|    268954|
| Germany                                    | DE   |     653|        653|   2238927|
| Denmark                                    | DK   |      13|         13|     55679|
| Spain                                      | ES   |     645|        645|   2224426|
| Ethiopia                                   | ET   |       2|          2|     10149|
| Finland                                    | FI   |      68|         68|    169703|
| France                                     | FR   |     608|        608|   1837314|
| United Kingdom                             | GB   |     162|        162|   3312515|
| Gibraltar                                  | GI   |       3|          3|     10213|
| Croatia                                    | HR   |      32|         32|     78539|
| Hungary                                    | HU   |      25|         25|     76174|
| Indonesia                                  | ID   |       3|          3|     26277|
| Ireland                                    | IE   |      12|         12|     28580|
| Israel                                     | IL   |       1|          1|      1826|
| India                                      | IN   |     103|        103|   3503286|
| Kuwait                                     | KW   |       1|          1|      1666|
| Macedonia, the Former Yugoslav Republic of | MK   |      30|         30|    108490|
| Mongolia                                   | MN   |      12|         12|   1624019|
| Mexico                                     | MX   |      48|         48|   1327228|
| Nigeria                                    | NG   |       1|          1|      2541|
| Netherlands                                | NL   |     110|        110|   3628235|
| Norway                                     | NO   |      64|         64|    436471|
| Nepal                                      | NP   |       2|          2|      3500|
| Peru                                       | PE   |      11|         11|    416028|
| Philippines                                | PH   |       1|          1|       958|
| Poland                                     | PL   |      16|         16|    547921|
| Sweden                                     | SE   |      11|         11|     45832|
| Singapore                                  | SG   |       1|          1|      1275|
| Thailand                                   | TH   |      63|         63|   1819906|
| Turkey                                     | TR   |     140|        140|   1257090|
| Taiwan, Province of China                  | TW   |      67|         67|   1175931|
| Uganda                                     | UG   |       1|          1|      1661|
| United States                              | US   |    1892|       1892|  19371972|
| Viet Nam                                   | VN   |       3|          3|     22998|
| Kosovo                                     | XK   |       1|          1|      9224|

``` r
attr(countries_table, "meta")
```

    ## # A tibble: 1 × 6
    ##         name   license                  website  page limit found
    ##       <fctr>    <fctr>                   <fctr> <int> <int> <int>
    ## 1 openaq-api CC BY 4.0 https://docs.openaq.org/     1   100    47

``` r
attr(countries_table, "timestamp")
```

    ## # A tibble: 1 × 1
    ##             queriedAt
    ##                <dttm>
    ## 1 2017-04-28 13:15:07

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
| Aberdeen   | GB      |          3|  53749| Aberdeen   |
| Aberdeen   | US      |          2|  15491| Aberdeen   |
| ADA        | US      |          1|  17323| ADA        |
| ADAIR      | US      |          1|  34045| ADAIR      |

The optional `country` argument allows to do this for a given country instead of the whole world.

``` r
cities_tableIndia <- aq_cities(country="IN", limit = 10)
kable(cities_tableIndia)
```

| city             | country |  locations|   count| cityURL          |
|:-----------------|:--------|----------:|-------:|:-----------------|
| Nagpur           | IN      |          5|   44255| Nagpur           |
| Nashik           | IN      |          4|   30867| Nashik           |
| Panchkula        | IN      |          1|   82178| Panchkula        |
| Patna            | IN      |          1|   45229| Patna            |
| Pune             | IN      |          1|   87180| Pune             |
| Rohtak           | IN      |          1|   45364| Rohtak           |
| Solapur          | IN      |          1|  177945| Solapur          |
| Thane            | IN      |          3|   64211| Thane            |
| Tirupati         | IN      |          3|   83099| Tirupati         |
| Varanasi         | IN      |          1|  122278| Varanasi         |
| Jodhpur          | IN      |          1|   93495| Jodhpur          |
| Jorapokhar       | IN      |          1|    1948| Jorapokhar       |
| Kanpur           | IN      |          2|  120102| Kanpur           |
| Kolkata          | IN      |          5|  122526| Kolkata          |
| Lucknow          | IN      |          4|  134537| Lucknow          |
| Ludhiana         | IN      |          1|    3962| Ludhiana         |
| Mandi Gobindgarh | IN      |          1|    6386| Mandi+Gobindgarh |
| Medak            | IN      |          1|    2671| Medak            |
| Mumbai           | IN      |          3|  200508| Mumbai           |
| Muzaffarpur      | IN      |          1|   78906| Muzaffarpur      |
| Dhanbad          | IN      |          1|       3| Dhanbad          |
| Durgapur         | IN      |          1|   30858| Durgapur         |
| Faridabad        | IN      |          1|   65569| Faridabad        |
| Gaya             | IN      |          1|   47950| Gaya             |
| Ghaziabad        | IN      |          2|    4281| Ghaziabad        |
| Gurgaon          | IN      |          1|   78886| Gurgaon          |
| Haldia           | IN      |          1|   62012| Haldia           |
| Howrah           | IN      |          1|   23640| Howrah           |
| Hyderabad        | IN      |         10|  215533| Hyderabad        |
| Jaipur           | IN      |          1|   97012| Jaipur           |
| Vijayawara       | IN      |          1|      72| Vijayawara       |
| Visakhapatnam    | IN      |          6|   82632| Visakhapatnam    |
| Agra             | IN      |          1|   45537| Agra             |
| Ahmedabad        | IN      |          1|   37016| Ahmedabad        |
| Amritsar         | IN      |          1|   13481| Amritsar         |
| Aurangabad       | IN      |          1|   57904| Aurangabad       |
| Barddhaman       | IN      |          3|    2470| Barddhaman       |
| Bengaluru        | IN      |          5|  206532| Bengaluru        |
| Chandrapur       | IN      |          2|  117804| Chandrapur       |
| Chennai          | IN      |          4|  140222| Chennai          |
| Chittoor         | IN      |          1|    2013| Chittoor         |
| Delhi            | IN      |         16|  624212| Delhi            |

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
| Alandur Bus Depot           | Chennai | IN      |   3081| CPCB              | 1493383500  | 1487450700   | CPCB              |  12.99711|   80.19152| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai | Alandur+Bus+Depot             |
| IIT                         | Chennai | IN      |   4223| CPCB              | 1493382600  | 1487442600   | CPCB              |  12.99251|   80.23745| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai | IIT                           |
| Manali                      | Chennai | IN      |   3754| CPCB              | 1493382600  | 1487452500   | CPCB              |  13.16454|   80.26285| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai | Manali                        |
| US Diplomatic Post: Chennai | Chennai | IN      |  11905| StateAir\_Chennai | 1493379000  | 1449869400   | StateAir\_Chennai |  13.08784|   80.27847| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai | US+Diplomatic+Post%3A+Chennai |

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

| location                      | parameter |  value| unit  | country | city  |  latitude|  longitude| dateUTC             | dateLocal           | cityURL | locationURL                     |
|:------------------------------|:----------|------:|:------|:--------|:------|---------:|----------:|:--------------------|:--------------------|:--------|:--------------------------------|
| US Diplomatic Post: New Delhi | pm25      |  158.9| µg/m³ | IN      | Delhi |  28.63576|   77.22445| 2017-01-20 04:30:00 | 2017-01-20 10:00:00 | Delhi   | US+Diplomatic+Post%3A+New+Delhi |
| Income Tax Office             | pm25      |  141.0| µg/m³ | IN      | Delhi |  28.62350|   77.24940| 2017-01-20 04:15:00 | 2017-01-20 09:45:00 | Delhi   | Income+Tax+Office               |
| Siri Fort                     | pm25      |  168.3| µg/m³ | IN      | Delhi |        NA|         NA| 2017-01-20 04:15:00 | 2017-01-20 09:45:00 | Delhi   | Siri+Fort                       |
| Punjabi Bagh                  | pm25      |  160.0| µg/m³ | IN      | Delhi |  28.66830|   77.11670| 2017-01-20 04:10:00 | 2017-01-20 09:40:00 | Delhi   | Punjabi+Bagh                    |
| R K Puram                     | pm25      |  191.0| µg/m³ | IN      | Delhi |  28.56480|   77.17440| 2017-01-20 04:10:00 | 2017-01-20 09:40:00 | Delhi   | R+K+Puram                       |
| Income Tax Office             | pm25      |  137.0| µg/m³ | IN      | Delhi |  28.62350|   77.24940| 2017-01-20 04:00:00 | 2017-01-20 09:30:00 | Delhi   | Income+Tax+Office               |

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
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| co        |  6125.000| 2017-04-28 11:45:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| no2       |    50.000| 2017-04-28 11:45:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| o3        |    40.000| 2017-04-28 11:45:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| pm10      |   135.000| 2017-04-28 11:45:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  47.93291|  106.92138| so2       |    64.000| 2017-03-27 02:00:00 | µg/m³ | Agaar.mn   | Ulaanbaatar          | 100+ail           |
| 16th and Whitmore | Omaha-Council Bluffs | US      |  41.32247|  -95.93799| o3        |     0.024| 2017-04-28 11:00:00 | ppm   | AirNow     | Omaha-Council+Bluffs | 16th+and+Whitmore |

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
| Bollaram Industrial Area, Hyderabad - TSPCB | Hyderabad | IN      |        NA|         NA| co        |  160.0| 2017-04-28 12:15:00 | µg/m³ | CPCB       | Hyderabad | Bollaram+Industrial+Area%2C+Hyderabad+-+TSPCB |

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

[![ropensci\_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
