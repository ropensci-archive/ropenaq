ropenaq
=======

[![Build Status](https://travis-ci.org/ropenscilabs/ropenaq.svg?branch=master)](https://travis-ci.org/ropenscilabs/ropenaq) [![Build status](https://ci.appveyor.com/api/projects/status/qurhlh0j8ra3qors?svg=true)](https://ci.appveyor.com/project/ropenscilabs/ropenaq) [![codecov.io](https://codecov.io/github/ropenscilabs/ropenaq/coverage.svg?branch=master)](https://codecov.io/github/ropenscilabs/Ropenaq?branch=master)

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
| Australia              | AU   |      11|         28|   535543|
| Bosnia and Herzegovina | BA   |       4|         10|    49706|
| Bangladesh             | BD   |       1|          1|     1859|
| Brazil                 | BR   |      72|         96|   835801|
| Canada                 | CA   |      11|        157|   243082|
| Chile                  | CL   |      87|        102|  1221308|
| China                  | CN   |       5|          5|    26388|
| Colombia               | CO   |       1|          1|     1700|
| United Kingdom         | GB   |     105|        152|   822192|
| Indonesia              | ID   |       1|          2|     7282|
| India                  | IN   |      25|         53|   538511|
| Mongolia               | MN   |       1|         12|   707633|
| Mexico                 | MX   |       5|         48|   208043|
| Netherlands            | NL   |      63|         93|  1460192|
| Peru                   | PE   |       1|         11|    98329|
| Poland                 | PL   |       9|         14|   303369|
| Thailand               | TH   |      33|         60|   715663|
| United States          | US   |     654|       1649|  3617460|
| Viet Nam               | VN   |       2|          2|     5964|
| Kosovo                 | XK   |       1|          1|     1166|

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
| 2016-05-27 09:33:01 | 2016-05-27 09:33:20 |

The `aq_cities` function
------------------------

Using the `aq_cities` functions one can get all cities for which information is available within the platform. For each city, one gets the number of locations and the count of measures for the city, the URL encoded string, and the country it is in.

``` r
citiesTable <- aq_cities()
kable(head(citiesTable$results))
```

| city      | country |  locations|  count| cityURL   |
|:----------|:--------|----------:|------:|:----------|
| 76t       | TH      |          1|      4| 76t       |
| ABBEVILLE | US      |          1|   1150| ABBEVILLE |
| Aberdeen  | GB      |          3|  11755| Aberdeen  |
| Aberdeen  | US      |          2|   2281| Aberdeen  |
| ADA       | US      |          1|   3438| ADA       |
| ADAIR     | US      |          1|   4884| ADAIR     |

The optional `country` argument allows to do this for a given country instead of the whole world.

``` r
citiesTableIndia <- aq_cities(country="IN")
kable(citiesTableIndia$results)
```

| city        | country |  locations|   count| cityURL     |
|:------------|:--------|----------:|-------:|:------------|
| Agra        | IN      |          1|    8074| Agra        |
| Bengaluru   | IN      |          5|   29866| Bengaluru   |
| Chandrapur  | IN      |          1|   16013| Chandrapur  |
| Chennai     | IN      |          4|   15122| Chennai     |
| Delhi       | IN      |         11|  195880| Delhi       |
| Faridabad   | IN      |          1|   15840| Faridabad   |
| Gaya        | IN      |          1|    7274| Gaya        |
| Gurgaon     | IN      |          1|   14311| Gurgaon     |
| Haldia      | IN      |          1|    9779| Haldia      |
| Hyderabad   | IN      |          3|   37467| Hyderabad   |
| Jaipur      | IN      |          1|   22138| Jaipur      |
| Jodhpur     | IN      |          1|   28152| Jodhpur     |
| Kanpur      | IN      |          1|   16327| Kanpur      |
| Kolkata     | IN      |          1|    3845| Kolkata     |
| Lucknow     | IN      |          4|     934| Lucknow     |
| Mumbai      | IN      |          3|   28967| Mumbai      |
| Muzaffarpur | IN      |          1|   17998| Muzaffarpur |
| Nagpur      | IN      |          4|    5268| Nagpur      |
| Nashik      | IN      |          2|    2536| Nashik      |
| Panchkula   | IN      |          1|   15179| Panchkula   |
| Patna       | IN      |          1|    8996| Patna       |
| Pune        | IN      |          1|    3752| Pune        |
| Rohtak      | IN      |          1|    3531| Rohtak      |
| Solapur     | IN      |          1|   11009| Solapur     |
| Varanasi    | IN      |          1|   20253| Varanasi    |

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

| location                                      | city        | country | sourceName          |  count| lastUpdated         | firstUpdated        |  latitude|  longitude| pm25 | pm10  | no2   | so2   | o3    | co    | bc    | cityURL     | locationURL                                   |
|:----------------------------------------------|:------------|:--------|:--------------------|------:|:--------------------|:--------------------|---------:|----------:|:-----|:------|:------|:------|:------|:------|:------|:------------|:----------------------------------------------|
| AAQMS Karve Road Pune                         | Pune        | IN      | CPCB                |    928| 2016-05-27 09:15:00 | 2016-03-21 08:00:00 |  18.49748|   73.81349| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Pune        | AAQMS+Karve+Road+Pune                         |
| Anand Vihar                                   | Delhi       | IN      | CPCB                |   5242| 2016-05-21 09:35:00 | 2015-06-29 14:30:00 |  28.65080|   77.31520| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | Anand+Vihar                                   |
| Ardhali Bazar                                 | Varanasi    | IN      | CPCB                |   4055| 2016-05-27 09:25:00 | 2016-03-22 00:05:00 |  25.35056|   82.97833| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Varanasi    | Ardhali+Bazar                                 |
| Central School                                | Lucknow     | IN      | CPCB                |     77| 2016-05-09 05:30:00 | 2016-03-22 10:00:00 |  26.85273|   80.99633| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Lucknow     | Central+School                                |
| Chandrapur                                    | Chandrapur  | IN      | CPCB                |   2587| 2016-05-27 07:25:00 | 2016-03-22 00:25:00 |  19.95000|   79.30000| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chandrapur  | Chandrapur                                    |
| Collectorate - Gaya - BSPCB                   | Gaya        | IN      | CPCB                |   1720| 2016-04-27 12:05:00 | 2016-03-21 16:35:00 |  24.74897|   84.94384| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Gaya        | Collectorate+-+Gaya+-+BSPCB                   |
| Collectorate Jodhpur - RSPCB                  | Jodhpur     | IN      | CPCB                |   4704| 2016-05-27 09:30:00 | 2016-03-21 18:30:00 |  26.29206|   73.03791| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Jodhpur     | Collectorate+Jodhpur+-+RSPCB                  |
| Collectorate - Muzaffarpur - BSPCB            | Muzaffarpur | IN      | CPCB                |   3518| 2016-05-27 09:10:00 | 2016-03-19 09:20:00 |  26.07620|   85.41150| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Muzaffarpur | Collectorate+-+Muzaffarpur+-+BSPCB            |
| IGSC Planetarium Complex - Patna - BSPCB      | Patna       | IN      | CPCB                |   2227| 2016-05-27 09:20:00 | 2016-03-21 19:30:00 |  25.36360|   85.07550| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Patna       | IGSC+Planetarium+Complex+-+Patna+-+BSPCB      |
| Maharashtra Pollution Control Board Bandra    | Mumbai      | IN      | CPCB                |   2669| 2016-05-27 08:45:00 | 2016-03-21 16:15:00 |  19.04185|   72.86551| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai      | Maharashtra+Pollution+Control+Board+Bandra    |
| Maharashtra Pollution Control Board - Solapur | Solapur     | IN      | CPCB                |   1829| 2016-05-27 09:30:00 | 2016-03-21 18:30:00 |  17.65992|   75.90639| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Solapur     | Maharashtra+Pollution+Control+Board+-+Solapur |
| Mandir Marg                                   | Delhi       | IN      | CPCB                |   9374| 2016-05-27 06:55:00 | 2015-06-29 14:30:00 |  28.63410|   77.20050| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | Mandir+Marg                                   |
| Navi Mumbai Municipal Corporation Airoli      | Mumbai      | IN      | CPCB                |   3850| 2016-05-27 05:30:00 | 2016-03-21 18:30:00 |  19.14940|   72.99860| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai      | Navi+Mumbai+Municipal+Corporation+Airoli      |
| Nehru Nagar                                   | Kanpur      | IN      | CPCB                |   3276| 2016-05-27 09:25:00 | 2016-03-21 22:45:00 |  26.47031|   80.32517| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Kanpur      | Nehru+Nagar                                   |
| Punjabi Bagh                                  | Delhi       | IN      | CPCB                |  10401| 2016-05-27 06:50:00 | 2015-06-29 00:30:00 |  28.66830|   77.11670| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | Punjabi+Bagh                                  |
| R K Puram                                     | Delhi       | IN      | CPCB                |   1756| 2016-05-27 06:55:00 | 2016-03-21 23:55:00 |  28.56480|   77.17440| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | R+K+Puram                                     |
| RK Puram                                      | Delhi       | IN      | RK Puram            |   8593| 2016-03-22 00:10:00 | 2015-06-29 14:30:00 |  28.56480|   77.17440| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | RK+Puram                                      |
| Sanjay Palace                                 | Agra        | IN      | CPCB                |   2615| 2016-05-27 08:45:00 | 2016-03-22 00:20:00 |  27.19866|   78.00598| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Agra        | Sanjay+Palace                                 |
| Sector 6 Panchkula - HSPCB                    | Panchkula   | IN      | CPCB                |   3089| 2016-05-27 09:30:00 | 2016-03-21 18:30:00 |  30.70578|   76.85318| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Panchkula   | Sector+6+Panchkula+-+HSPCB                    |
| US Diplomatic Post: Chennai                   | Chennai     | IN      | StateAir\_Chennai   |   3846| 2016-05-27 09:30:00 | 2015-12-11 21:30:00 |  13.05237|   80.25193| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai     | US+Diplomatic+Post%3A+Chennai                 |
| US Diplomatic Post: Hyderabad                 | Hyderabad   | IN      | StateAir\_Hyderabad |   3845| 2016-05-27 08:30:00 | 2015-12-11 21:30:00 |  17.44346|   78.47489| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Hyderabad   | US+Diplomatic+Post%3A+Hyderabad               |
| US Diplomatic Post: Kolkata                   | Kolkata     | IN      | StateAir\_Kolkata   |   3845| 2016-05-27 08:30:00 | 2015-12-11 21:30:00 |  22.54714|   88.35105| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Kolkata     | US+Diplomatic+Post%3A+Kolkata                 |
| US Diplomatic Post: Mumbai                    | Mumbai      | IN      | StateAir\_Mumbai    |   3845| 2016-05-27 08:30:00 | 2015-12-11 21:30:00 |  19.06602|   72.86870| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai      | US+Diplomatic+Post%3A+Mumbai                  |
| US Diplomatic Post: New Delhi                 | Delhi       | IN      | StateAir\_NewDelhi  |   3895| 2016-05-27 08:30:00 | 2015-12-11 21:30:00 |  28.59810|   77.18907| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | US+Diplomatic+Post%3A+New+Delhi               |
| Vikas Sadan Gurgaon - HSPCB                   | Gurgaon     | IN      | CPCB                |   2893| 2016-05-27 09:30:00 | 2016-03-25 07:15:00 |  28.45013|   77.02631| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Gurgaon     | Vikas+Sadan+Gurgaon+-+HSPCB                   |
| VK Industrial Area Jaipur - RSPCB             | Jaipur      | IN      | CPCB                |   3903| 2016-05-27 09:15:00 | 2016-03-21 18:30:00 |  26.97388|   75.77388| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Jaipur      | VK+Industrial+Area+Jaipur+-+RSPCB             |
| ZooPark                                       | Hyderabad   | IN      | CPCB                |   4443| 2016-05-27 09:15:00 | 2016-03-21 18:30:00 |  17.34969|   78.45144| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Hyderabad   | ZooPark                                       |

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
| Anand Vihar | pm25      |     66| µg/m³ | IN      | Delhi | 2016-05-21 09:35:00 | 2016-05-21 15:05:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     81| µg/m³ | IN      | Delhi | 2016-05-21 09:20:00 | 2016-05-21 14:50:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     81| µg/m³ | IN      | Delhi | 2016-05-21 09:00:00 | 2016-05-21 14:30:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     81| µg/m³ | IN      | Delhi | 2016-05-21 08:30:00 | 2016-05-21 14:00:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     76| µg/m³ | IN      | Delhi | 2016-05-21 08:00:00 | 2016-05-21 13:30:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     76| µg/m³ | IN      | Delhi | 2016-05-21 07:30:00 | 2016-05-21 13:00:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |

``` r
kable(tableResults$timestamp)
```

| lastModif           | queriedAt           |
|:--------------------|:--------------------|
| 2016-05-27 09:33:01 | 2016-05-27 09:33:26 |

``` r
kable(tableResults$meta)
```

| name       | license   | website                    |  page|  limit|  found|
|:-----------|:----------|:---------------------------|-----:|------:|------:|
| openaq-api | CC BY 4.0 | <https://docs.openaq.org/> |     1|    100|   5242|

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
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| co        |  213.000| 2016-05-27 09:15:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| no2       |   14.000| 2016-05-27 09:15:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| o3        |   92.000| 2016-05-27 09:15:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| pm10      |  459.000| 2016-05-27 09:15:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| so2       |    2.000| 2016-05-27 09:15:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 16th and Whitmore | Omaha-Council Bluffs | US      |   41.32247|  -95.93799| o3        |    0.047| 2016-05-27 07:00:00 | ppm   | Omaha-Council+Bluffs | 16th+and+Whitmore |

Below are the latest values for Anand Vihar at the time this vignette was compiled (cache=FALSE).

``` r
tableLatest <- aq_latest(country="IN", city="Delhi", location="Anand+Vihar")
kable(head(tableLatest$results))
```

| location    | city  | country |  longitude|  latitude| parameter |   value| lastUpdated         | unit  | cityURL | locationURL |
|:------------|:------|:--------|----------:|---------:|:----------|-------:|:--------------------|:------|:--------|:------------|
| Anand Vihar | Delhi | IN      |    28.6508|   77.3152| co        |  1300.0| 2016-03-21 14:45:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |    28.6508|   77.3152| no2       |    38.9| 2016-05-21 09:35:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |    28.6508|   77.3152| o3        |    27.2| 2016-05-21 09:35:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |    28.6508|   77.3152| pm10      |   404.0| 2016-05-21 09:35:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |    28.6508|   77.3152| pm25      |    66.0| 2016-05-21 09:35:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |    28.6508|   77.3152| so2       |    18.0| 2016-03-21 14:45:00 | µg/m³ | Delhi   | Anand+Vihar |

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
| openaq-api | CC BY 4.0 | <https://docs.openaq.org/> |     1|    100|  39261|

``` r
how_many$found
```

    ## [1] 39261

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

Meta
----

-   Please [report any issues or bugs](https://github.com/ropenscilabs/ropenaq/issues).
-   License: GPL
-   Get citation information for `ropenaq` in R doing `citation(package = 'ropenaq')`
-   Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci\_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
