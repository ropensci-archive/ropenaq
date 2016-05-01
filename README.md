ropenaq
=======

[![Build Status](https://travis-ci.org/ropenscilabs/ropenaq.svg?branch=master)](https://travis-ci.org/ropenscilabs/ropenaq) [![Build status](https://ci.appveyor.com/api/projects/status/3k104wgbahv3t7h6?svg=true)](https://ci.appveyor.com/project/masalmon/ropenaq-84qm3) [![codecov.io](https://codecov.io/github/ropenscilabs/ropenaq/coverage.svg?branch=master)](https://codecov.io/github/ropenscilabs/Ropenaq?branch=master)

Installation
============

To install the package, you will need the devtools package.

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
countriesTable <- aq_countries()
library("knitr")
kable(countriesTable$results)
```

| name                   | code |  cities|  locations|    count|
|:-----------------------|:-----|-------:|----------:|--------:|
| Australia              | AU   |      11|         28|   469900|
| Bosnia and Herzegovina | BA   |       4|         10|     8497|
| Bangladesh             | BD   |       1|          1|     1238|
| Brazil                 | BR   |      71|         95|   735836|
| Canada                 | CA   |      10|        153|   157101|
| Chile                  | CL   |      79|        101|  1074774|
| China                  | CN   |       5|          5|    23283|
| Colombia               | CO   |       1|          1|     1079|
| United Kingdom         | GB   |     105|        151|   615145|
| Indonesia              | ID   |       1|          2|     6040|
| India                  | IN   |      25|         51|   391990|
| Mongolia               | MN   |       1|         11|   645344|
| Mexico                 | MX   |       5|         47|   114971|
| Netherlands            | NL   |      63|         93|  1293062|
| Peru                   | PE   |       1|         11|    62088|
| Poland                 | PL   |       9|         14|   268526|
| Thailand               | TH   |      29|         57|   636094|
| United States          | US   |     653|       1638|  2410720|
| Viet Nam               | VN   |       2|          2|     4722|
| Kosovo                 | XK   |       1|          1|      545|

``` r
kable(countriesTable$meta)
```

| name       | license   | website                    |  page|  limit|  found|
|:-----------|:----------|:---------------------------|-----:|------:|------:|
| openaq-api | CC BY 4.0 | <https://docs.openaq.org/> |     1|    100|     20|

``` r
kable(countriesTable$timestamp)
```

| lastModif           | queriedAt           |
|:--------------------|:--------------------|
| 2016-05-01 12:42:12 | 2016-05-01 12:50:59 |

The `aq_cities` function
------------------------

Using the `aq_cities` functions one can get all cities for which information is available within the platform. For each city, one gets the number of locations and the count of measures for the city, the URL encoded string, and the country it is in.

``` r
citiesTable <- aq_cities()
kable(head(citiesTable$results))
```

| city      | country |  locations|  count| cityURL   |
|:----------|:--------|----------:|------:|:----------|
| ABBEVILLE | US      |          1|    751| ABBEVILLE |
| Aberdeen  | GB      |          3|   8305| Aberdeen  |
| Aberdeen  | US      |          2|   1266| Aberdeen  |
| ADA       | US      |          1|   2263| ADA       |
| ADAIR     | US      |          1|   3347| ADAIR     |
| ADAMS     | US      |          2|   3037| ADAMS     |

The optional `country` argument allows to do this for a given country instead of the whole world.

``` r
citiesTableIndia <- aq_cities(country="IN")
kable(citiesTableIndia$results)
```

| city        | country |  locations|   count| cityURL     |
|:------------|:--------|----------:|-------:|:------------|
| Agra        | IN      |          1|    5018| Agra        |
| Bengaluru   | IN      |          5|   19256| Bengaluru   |
| Chandrapur  | IN      |          1|   10928| Chandrapur  |
| Chennai     | IN      |          4|    9298| Chennai     |
| Delhi       | IN      |         11|  177500| Delhi       |
| Faridabad   | IN      |          1|    9496| Faridabad   |
| Gaya        | IN      |          1|    7274| Gaya        |
| Gurgaon     | IN      |          1|    4742| Gurgaon     |
| Haldia      | IN      |          1|    7779| Haldia      |
| Hyderabad   | IN      |          3|   22706| Hyderabad   |
| Jaipur      | IN      |          1|   15198| Jaipur      |
| Jodhpur     | IN      |          1|   17575| Jodhpur     |
| Kanpur      | IN      |          1|    9656| Kanpur      |
| Kolkata     | IN      |          1|    3224| Kolkata     |
| Lucknow     | IN      |          3|     516| Lucknow     |
| Mumbai      | IN      |          3|   18752| Mumbai      |
| Muzaffarpur | IN      |          1|   11683| Muzaffarpur |
| Nagpur      | IN      |          4|    2348| Nagpur      |
| Nashik      | IN      |          1|    1020| Nashik      |
| Panchkula   | IN      |          1|    9768| Panchkula   |
| Patna       | IN      |          1|    5488| Patna       |
| Pune        | IN      |          1|     173| Pune        |
| Rohtak      | IN      |          1|    3013| Rohtak      |
| Solapur     | IN      |          1|    8092| Solapur     |
| Varanasi    | IN      |          1|   11487| Varanasi    |

If one inputs a country that is not in the platform (or misspells a code), then an error message is thrown.

``` r
#aq_cities(country="PANEM")
```

The `locations` function
------------------------

The `aq_locations` function has far more arguments than the first two functions. On can filter locations in a given country, city, location, for a given parameter (valid values are "pm25", "pm10", "so2", "no2", "o3", "co" and "bc"), from a given date and/or up to a given date, for values between a minimum and a maximum. In the output table one also gets URL encoded strings for the city and the location. Below are several examples.

Here we only look for locations with PM2.5 information in India.

``` r
locationsIndia <- aq_locations(country="IN", parameter="pm25")
kable(locationsIndia$results)
```

| location                                      | city        | country | sourceName          |  count| lastUpdated         | firstUpdated        |  latitude|  longitude| pm25 | pm10  | no2   | o3    | co    | bc    | cityURL     | locationURL                                   |
|:----------------------------------------------|:------------|:--------|:--------------------|------:|:--------------------|:--------------------|---------:|----------:|:-----|:------|:------|:------|:------|:------|:------------|:----------------------------------------------|
| AAQMS Karve Road Pune                         | Pune        | IN      | CPCB                |     43| 2016-04-30 09:45:00 | 2016-03-21 08:00:00 |  18.49748|   73.81349| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Pune        | AAQMS+Karve+Road+Pune                         |
| Anand Vihar                                   | Delhi       | IN      | CPCB                |   4655| 2016-04-29 17:00:00 | 2015-06-29 14:30:00 |  28.65080|   77.31520| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | Anand+Vihar                                   |
| Ardhali Bazar                                 | Varanasi    | IN      | CPCB                |   2294| 2016-04-30 12:25:00 | 2016-03-22 00:05:00 |  25.35056|   82.97833| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Varanasi    | Ardhali+Bazar                                 |
| Central School                                | Lucknow     | IN      | CPCB                |     63| 2016-05-01 10:00:00 | 2016-03-22 10:00:00 |  26.85273|   80.99633| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Lucknow     | Central+School                                |
| Chandrapur                                    | Chandrapur  | IN      | CPCB                |   1799| 2016-05-01 12:15:00 | 2016-03-22 00:25:00 |  19.95000|   79.30000| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Chandrapur  | Chandrapur                                    |
| Collectorate - Gaya - BSPCB                   | Gaya        | IN      | CPCB                |   1720| 2016-04-27 12:05:00 | 2016-03-21 16:35:00 |  24.74897|   84.94384| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Gaya        | Collectorate+-+Gaya+-+BSPCB                   |
| Collectorate Jodhpur - RSPCB                  | Jodhpur     | IN      | CPCB                |   2923| 2016-05-01 12:30:00 | 2016-03-21 18:30:00 |  26.29206|   73.03791| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Jodhpur     | Collectorate+Jodhpur+-+RSPCB                  |
| Collectorate - Muzaffarpur - BSPCB            | Muzaffarpur | IN      | CPCB                |   2306| 2016-05-01 12:20:00 | 2016-03-19 09:20:00 |  26.07620|   85.41150| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Muzaffarpur | Collectorate+-+Muzaffarpur+-+BSPCB            |
| IGSC Planetarium Complex - Patna - BSPCB      | Patna       | IN      | CPCB                |   1356| 2016-05-01 12:10:00 | 2016-03-21 19:30:00 |  25.36360|   85.07550| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Patna       | IGSC+Planetarium+Complex+-+Patna+-+BSPCB      |
| Maharashtra Pollution Control Board Bandra    | Mumbai      | IN      | CPCB                |   1850| 2016-05-01 12:30:00 | 2016-03-21 16:15:00 |  19.04185|   72.86551| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai      | Maharashtra+Pollution+Control+Board+Bandra    |
| Maharashtra Pollution Control Board - Solapur | Solapur     | IN      | CPCB                |   1345| 2016-04-09 12:15:00 | 2016-03-21 18:30:00 |  17.65992|   75.90639| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Solapur     | Maharashtra+Pollution+Control+Board+-+Solapur |
| Mandir Marg                                   | Delhi       | IN      | CPCB                |   8688| 2016-04-29 17:00:00 | 2015-06-29 14:30:00 |  28.63410|   77.20050| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | Mandir+Marg                                   |
| Navi Mumbai Municipal Corporation Airoli      | Mumbai      | IN      | CPCB                |   2033| 2016-04-29 10:15:00 | 2016-03-21 18:30:00 |  19.14940|   72.99860| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai      | Navi+Mumbai+Municipal+Corporation+Airoli      |
| Nehru Nagar                                   | Kanpur      | IN      | CPCB                |   1919| 2016-05-01 12:25:00 | 2016-03-21 22:45:00 |  26.47031|   80.32517| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Kanpur      | Nehru+Nagar                                   |
| Punjabi Bagh                                  | Delhi       | IN      | CPCB                |   9544| 2016-04-29 17:00:00 | 2015-06-29 00:30:00 |  28.66830|   77.11670| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | Punjabi+Bagh                                  |
| R K Puram                                     | Delhi       | IN      | CPCB                |    992| 2016-04-29 17:05:00 | 2016-03-21 23:55:00 |  28.56480|   77.17440| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | R+K+Puram                                     |
| RK Puram                                      | Delhi       | IN      | RK Puram            |   8593| 2016-03-22 00:10:00 | 2015-06-29 14:30:00 |        NA|         NA| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | RK+Puram                                      |
| Sanjay Palace                                 | Agra        | IN      | CPCB                |   1668| 2016-05-01 11:05:00 | 2016-03-22 00:20:00 |  27.19866|   78.00598| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Agra        | Sanjay+Palace                                 |
| Sector 6 Panchkula - HSPCB                    | Panchkula   | IN      | CPCB                |   1999| 2016-05-01 12:45:00 | 2016-03-21 18:30:00 |  30.70578|   76.85318| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Panchkula   | Sector+6+Panchkula+-+HSPCB                    |
| US Diplomatic Post: Chennai                   | Chennai     | IN      | StateAir\_Chennai   |   3224| 2016-05-01 11:30:00 | 2015-12-11 21:30:00 |  13.05237|   80.25193| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai     | US+Diplomatic+Post%3A+Chennai                 |
| US Diplomatic Post: Hyderabad                 | Hyderabad   | IN      | StateAir\_Hyderabad |   3224| 2016-05-01 11:30:00 | 2015-12-11 21:30:00 |  17.44346|   78.47489| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Hyderabad   | US+Diplomatic+Post%3A+Hyderabad               |
| US Diplomatic Post: Kolkata                   | Kolkata     | IN      | StateAir\_Kolkata   |   3224| 2016-05-01 11:30:00 | 2015-12-11 21:30:00 |  22.54714|   88.35105| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Kolkata     | US+Diplomatic+Post%3A+Kolkata                 |
| US Diplomatic Post: Mumbai                    | Mumbai      | IN      | StateAir\_Mumbai    |   3224| 2016-05-01 11:30:00 | 2015-12-11 21:30:00 |  19.06602|   72.86870| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai      | US+Diplomatic+Post%3A+Mumbai                  |
| US Diplomatic Post: New Delhi                 | Delhi       | IN      | StateAir\_NewDelhi  |   3274| 2016-05-01 11:30:00 | 2015-12-11 21:30:00 |  28.59810|   77.18907| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | US+Diplomatic+Post%3A+New+Delhi               |
| Vikas Sadan Gurgaon - HSPCB                   | Gurgaon     | IN      | CPCB                |    969| 2016-05-01 12:30:00 | 2016-03-25 07:15:00 |  28.45013|   77.02631| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Gurgaon     | Vikas+Sadan+Gurgaon+-+HSPCB                   |
| VK Industrial Area Jaipur - RSPCB             | Jaipur      | IN      | CPCB                |   2701| 2016-05-01 12:15:00 | 2016-03-21 18:30:00 |  26.97388|   75.77388| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Jaipur      | VK+Industrial+Area+Jaipur+-+RSPCB             |
| ZooPark                                       | Hyderabad   | IN      | CPCB                |   2669| 2016-05-01 12:15:00 | 2016-03-21 18:30:00 |  17.34969|   78.45144| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Hyderabad   | ZooPark                                       |

Getting measurements
====================

Two functions allow to get data: `aq_measurement` and `aq_latest`. In both of them the arguments city and location needs to be given as URL encoded strings.

The `aq_measurements` function
------------------------------

The `aq_measurements` function has many arguments for getting a query specific to, say, a given parameter in a given location. Below we get the PM2.5 measures for Anand Vihar in Delhi in India.

``` r
tableResults <- aq_measurements(country="IN", city="Delhi", location="Anand+Vihar", parameter="pm25")
kable(head(tableResults$results))
```

| location    | parameter |  value| unit  | country | city  | dateUTC             | dateLocal           |  latitude|  longitude| cityURL | locationURL |
|:------------|:----------|------:|:------|:--------|:------|:--------------------|:--------------------|---------:|----------:|:--------|:------------|
| Anand Vihar | pm25      |    432| µg/m³ | IN      | Delhi | 2016-04-29 17:00:00 | 2016-04-29 22:30:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |    432| µg/m³ | IN      | Delhi | 2016-04-29 16:30:00 | 2016-04-29 22:00:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |    368| µg/m³ | IN      | Delhi | 2016-04-29 16:00:00 | 2016-04-29 21:30:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |    368| µg/m³ | IN      | Delhi | 2016-04-29 15:30:00 | 2016-04-29 21:00:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |    122| µg/m³ | IN      | Delhi | 2016-04-29 15:00:00 | 2016-04-29 20:30:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |    122| µg/m³ | IN      | Delhi | 2016-04-29 14:30:00 | 2016-04-29 20:00:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |

``` r
kable(tableResults$timestamp)
```

| lastModif           | queriedAt           |
|:--------------------|:--------------------|
| 2016-05-01 12:42:12 | 2016-05-01 12:51:10 |

``` r
kable(tableResults$meta)
```

| name       | license   | website                    |  page|  limit|  found|
|:-----------|:----------|:---------------------------|-----:|------:|------:|
| openaq-api | CC BY 4.0 | <https://docs.openaq.org/> |     1|    100|   4655|

One could also get all possible parameters in the same table.

The `aq_latest` function
------------------------

This function gives a table with all newest measures for the locations that are chosen by the arguments. If all arguments are `NULL`, it gives all the newest measures for all locations.

``` r
tableLatest <- aq_latest()
kable(head(tableLatest$results))
```

| location          | city                 | country |  longitude|   latitude| parameter |    value| lastUpdated         | unit  | cityURL              | locationURL       |
|:------------------|:---------------------|:--------|----------:|----------:|:----------|--------:|:--------------------|:------|:---------------------|:------------------|
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| co        |  425.000| 2016-05-01 03:00:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| no2       |   16.000| 2016-05-01 03:00:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| o3        |   52.000| 2016-05-01 03:00:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| pm10      |   46.000| 2016-05-01 03:00:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| so2       |   18.000| 2016-05-01 03:00:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 16th and Whitmore | Omaha-Council Bluffs | US      |   41.32247|  -95.93799| o3        |    0.032| 2016-05-01 11:00:00 | ppm   | Omaha-Council+Bluffs | 16th+and+Whitmore |

Below are the latest values for Anand Vihar at the time this vignette was compiled (cache=FALSE).

``` r
tableLatest <- aq_latest(country="IN", city="Delhi", location="Anand+Vihar")
kable(head(tableLatest$results))
```

| location    | city  | country | longitude |  latitude| lastUpdated         | unit  | cityURL | locationURL |
|:------------|:------|:--------|:----------|---------:|:--------------------|:------|:--------|:------------|
| Anand Vihar | Delhi | IN      | co        |    1300.0| 2016-03-21 14:45:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | no2       |     138.9| 2016-04-29 17:00:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | o3        |      25.5| 2016-04-29 17:00:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | pm10      |     591.0| 2016-04-29 17:00:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | pm25      |     432.0| 2016-04-29 17:00:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | so2       |      18.0| 2016-03-21 14:45:00 | µg/m³ | Delhi   | Anand+Vihar |

Paging and limit
================

For all endpoints/functions, there a a `limit` and a `page` arguments, which indicate, respectively, how many results per page should be shown and which page should be queried. Based on this, how to get all results corresponding to a query? First, look at the number of results, e.g.

``` r
how_many <- aq_measurements(city = "Delhi",
                            parameter = "pm25")$meta
knitr::kable(how_many)
```

| name       | license   | website                    |  page|  limit|  found|
|:-----------|:----------|:---------------------------|-----:|------:|------:|
| openaq-api | CC BY 4.0 | <https://docs.openaq.org/> |     1|    100|  35747|

``` r
how_many$found
```

    ## [1] 35747

Then one can write a loop over pages. Note that the maximal value of `limit` is 1000.

``` r
meas <- NULL
for (page in 1:(ceiling(how_many$found/1000))){
  meas <- rbind(meas,
                aq_measurements(city = "Delhi",
                                parameter = "pm25",
                                page = page,
                                limit = 1000))
  }
```

If you really need a lot of data, you might consider download the csv files that contain all measurements per location [from this link](https://openaq.org/#/sources).

Meta
----

-   Please [report any issues or bugs](https://github.com/ropenscilabs/ropenaq/issues).
-   License: GPL
-   Get citation information for `ropenaq` in R doing `citation(package = 'ropenaq')`
-   Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci\_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
