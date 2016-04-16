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
kable(countriesTable$results)
```

|    count| code | name           |
|--------:|:-----|:---------------|
|   432691| AU   | Australia      |
|      879| BD   | Bangladesh     |
|   676434| BR   | Brazil         |
|   121198| CA   | Canada         |
|   988194| CL   | Chile          |
|    21488| CN   | China          |
|      720| CO   | Colombia       |
|   495530| GB   | United Kingdom |
|     5322| ID   | Indonesia      |
|   302628| IN   | India          |
|   604486| MN   | Mongolia       |
|    70393| MX   | Mexico         |
|  1198832| NL   | Netherlands    |
|    42133| PE   | Peru           |
|   248326| PL   | Poland         |
|   585525| TH   | Thailand       |
|  1762906| US   | United States  |
|     4005| VN   | Viet Nam       |
|      186| XK   | NA             |

``` r
kable(countriesTable$meta)
```

| name       | license   | website                    |  page|  limit|  found|
|:-----------|:----------|:---------------------------|-----:|------:|------:|
| openaq-api | CC BY 4.0 | <https://docs.openaq.org/> |     1|    100|     19|

``` r
kable(countriesTable$timestamp)
```

| lastModif           | queriedAt           |
|:--------------------|:--------------------|
| 2016-04-16 14:05:50 | 2016-04-16 14:15:35 |

The `aq_cities` function
------------------------

Using the `aq_cities` functions one can get all cities for which information is available within the platform. For each city, one gets the number of locations and the count of measures for the city, the URL encoded string, and the country it is in.

``` r
citiesTable <- aq_cities()
kable(head(citiesTable$results))
```

| city      | country |  count|  locations| cityURL   |
|:----------|:--------|------:|----------:|:----------|
| ABBEVILLE | US      |    539|          1| ABBEVILLE |
| Aberdeen  | GB      |   6280|          3| Aberdeen  |
| Aberdeen  | US      |    833|          2| Aberdeen  |
| ADA       | US      |   1613|          1| ADA       |
| ADAIR     | US      |   2943|          1| ADAIR     |
| ADAMS     | US      |   2159|          2| ADAMS     |

The optional `country` argument allows to do this for a given country instead of the whole world.

``` r
citiesTableIndia <- aq_cities(country="IN")
kable(citiesTableIndia$results)
```

| city        | country |   count|  locations| cityURL     |
|:------------|:--------|-------:|----------:|:------------|
| Agra        | IN      |    3471|          1| Agra        |
| Bengaluru   | IN      |   11862|          5| Bengaluru   |
| Chandrapur  | IN      |    4741|          1| Chandrapur  |
| Chennai     | IN      |    6701|          4| Chennai     |
| Delhi       | IN      |  167548|         11| Delhi       |
| Faridabad   | IN      |    6216|          1| Faridabad   |
| Gaya        | IN      |    4565|          1| Gaya        |
| Gurgaon     | IN      |    1502|          1| Gurgaon     |
| Haldia      | IN      |    5287|          1| Haldia      |
| Hyderabad   | IN      |   15244|          3| Hyderabad   |
| Jaipur      | IN      |    9904|          1| Jaipur      |
| Jodhpur     | IN      |   10905|          1| Jodhpur     |
| Kanpur      | IN      |    4572|          1| Kanpur      |
| Kolkata     | IN      |    2866|          1| Kolkata     |
| Lucknow     | IN      |     291|          3| Lucknow     |
| Mumbai      | IN      |   13572|          3| Mumbai      |
| Muzaffarpur | IN      |    6815|          1| Muzaffarpur |
| Nagpur      | IN      |     789|          4| Nagpur      |
| Nashik      | IN      |     486|          1| Nashik      |
| Panchkula   | IN      |    5950|          1| Panchkula   |
| Patna       | IN      |    3184|          1| Patna       |
| Pune        | IN      |      89|          1| Pune        |
| Rohtak      | IN      |    1867|          1| Rohtak      |
| Solapur     | IN      |    8092|          1| Solapur     |
| Varanasi    | IN      |    6109|          1| Varanasi    |

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

| location                                      | city        | country | sourceName          |  count| lastUpdated         | firstUpdated        |  longitude|  latitude| pm25 | pm10  | no2   | o3    | co    | bc    | cityURL     | locationURL                                   |
|:----------------------------------------------|:------------|:--------|:--------------------|------:|:--------------------|:--------------------|----------:|---------:|:-----|:------|:------|:------|:------|:------|:------------|:----------------------------------------------|
| AAQMS Karve Road Pune                         | Pune        | IN      | CPCB                |     22| 2016-04-16 05:45:00 | 2016-03-21 08:00:00 |   73.81349|  18.49748| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Pune        | AAQMS+Karve+Road+Pune                         |
| Anand Vihar                                   | Delhi       | IN      | Anand Vihar         |   4388| 2016-04-15 17:00:00 | 2015-06-29 14:30:00 |         NA|        NA| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | Anand+Vihar                                   |
| Ardhali Bazar                                 | Varanasi    | IN      | CPCB                |   1226| 2016-04-16 13:45:00 | 2016-03-22 00:05:00 |   82.97833|  25.35056| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Varanasi    | Ardhali+Bazar                                 |
| Central School                                | Lucknow     | IN      | CPCB                |     34| 2016-04-16 10:00:00 | 2016-03-22 10:00:00 |   80.99633|  26.85273| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Lucknow     | Central+School                                |
| Chandrapur                                    | Chandrapur  | IN      | CPCB                |    770| 2016-04-16 08:25:00 | 2016-03-22 00:25:00 |   79.30000|  19.95000| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Chandrapur  | Chandrapur                                    |
| Collectorate - Gaya - BSPCB                   | Gaya        | IN      | CPCB                |   1054| 2016-04-16 13:35:00 | 2016-03-21 16:35:00 |   84.94384|  24.74897| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Gaya        | Collectorate+-+Gaya+-+BSPCB                   |
| Collectorate Jodhpur - RSPCB                  | Jodhpur     | IN      | CPCB                |   1794| 2016-04-16 13:45:00 | 2016-03-21 18:30:00 |   73.03791|  26.29206| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Jodhpur     | Collectorate+Jodhpur+-+RSPCB                  |
| Collectorate - Muzaffarpur - BSPCB            | Muzaffarpur | IN      | CPCB                |   1345| 2016-04-16 13:40:00 | 2016-03-19 09:20:00 |   85.41150|  26.07620| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Muzaffarpur | Collectorate+-+Muzaffarpur+-+BSPCB            |
| IGSC Planetarium Complex - Patna - BSPCB      | Patna       | IN      | CPCB                |    777| 2016-04-16 13:20:00 | 2016-03-21 19:30:00 |   85.07550|  25.36360| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Patna       | IGSC+Planetarium+Complex+-+Patna+-+BSPCB      |
| Maharashtra Pollution Control Board Bandra    | Mumbai      | IN      | CPCB                |   1282| 2016-04-16 12:45:00 | 2016-03-21 16:15:00 |   72.86551|  19.04185| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai      | Maharashtra+Pollution+Control+Board+Bandra    |
| Maharashtra Pollution Control Board - Solapur | Solapur     | IN      | CPCB                |   1345| 2016-04-09 12:15:00 | 2016-03-21 18:30:00 |   75.90639|  17.65992| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Solapur     | Maharashtra+Pollution+Control+Board+-+Solapur |
| Mandir Marg                                   | Delhi       | IN      | CPCB                |   8392| 2016-04-15 05:25:00 | 2015-06-29 14:30:00 |   77.20050|  28.63410| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | Mandir+Marg                                   |
| Navi Mumbai Municipal Corporation Airoli      | Mumbai      | IN      | CPCB                |   1361| 2016-04-16 13:45:00 | 2016-03-21 18:30:00 |   72.99860|  19.14940| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai      | Navi+Mumbai+Municipal+Corporation+Airoli      |
| Nehru Nagar                                   | Kanpur      | IN      | CPCB                |    910| 2016-04-16 13:35:00 | 2016-03-21 22:45:00 |   80.32517|  26.47031| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Kanpur      | Nehru+Nagar                                   |
| Punjabi Bagh                                  | Delhi       | IN      | CPCB                |   9141| 2016-04-15 17:00:00 | 2015-06-29 00:30:00 |   77.11670|  28.66830| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | Punjabi+Bagh                                  |
| R K Puram                                     | Delhi       | IN      | CPCB                |    616| 2016-04-15 17:00:00 | 2016-03-21 23:55:00 |   77.17440|  28.56480| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | R+K+Puram                                     |
| RK Puram                                      | Delhi       | IN      | RK Puram            |   8593| 2016-03-22 00:10:00 | 2015-06-29 14:30:00 |         NA|        NA| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | RK+Puram                                      |
| Sanjay Palace                                 | Agra        | IN      | CPCB                |   1153| 2016-04-16 13:35:00 | 2016-03-22 00:20:00 |   78.00598|  27.19866| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Agra        | Sanjay+Palace                                 |
| Sector 6 Panchkula - HSPCB                    | Panchkula   | IN      | CPCB                |   1221| 2016-04-16 13:15:00 | 2016-03-21 18:30:00 |   76.85318|  30.70578| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Panchkula   | Sector+6+Panchkula+-+HSPCB                    |
| US Diplomatic Post: Chennai                   | Chennai     | IN      | StateAir\_Chennai   |   2866| 2016-04-16 13:30:00 | 2015-12-11 21:30:00 |   80.25193|  13.05237| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai     | US+Diplomatic+Post%3A+Chennai                 |
| US Diplomatic Post: Hyderabad                 | Hyderabad   | IN      | StateAir\_Hyderabad |   2866| 2016-04-16 13:30:00 | 2015-12-11 21:30:00 |   78.47489|  17.44346| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Hyderabad   | US+Diplomatic+Post%3A+Hyderabad               |
| US Diplomatic Post: Kolkata                   | Kolkata     | IN      | StateAir\_Kolkata   |   2866| 2016-04-16 13:30:00 | 2015-12-11 21:30:00 |   88.35105|  22.54714| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Kolkata     | US+Diplomatic+Post%3A+Kolkata                 |
| US Diplomatic Post: Mumbai                    | Mumbai      | IN      | StateAir\_Mumbai    |   2866| 2016-04-16 13:30:00 | 2015-12-11 21:30:00 |   72.86870|  19.06602| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai      | US+Diplomatic+Post%3A+Mumbai                  |
| US Diplomatic Post: New Delhi                 | Delhi       | IN      | StateAir\_NewDelhi  |   2916| 2016-04-16 13:30:00 | 2015-12-11 21:30:00 |   77.18907|  28.59810| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | US+Diplomatic+Post%3A+New+Delhi               |
| Vikas Sadan Gurgaon - HSPCB                   | Gurgaon     | IN      | CPCB                |    264| 2016-04-16 12:00:00 | 2016-03-25 07:15:00 |   77.02631|  28.45013| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Gurgaon     | Vikas+Sadan+Gurgaon+-+HSPCB                   |
| VK Industrial Area Jaipur - RSPCB             | Jaipur      | IN      | CPCB                |   1674| 2016-04-16 13:30:00 | 2016-03-21 18:30:00 |   75.77388|  26.97388| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Jaipur      | VK+Industrial+Area+Jaipur+-+RSPCB             |
| ZooPark                                       | Hyderabad   | IN      | CPCB                |   1736| 2016-04-16 13:30:00 | 2016-03-21 18:30:00 |   78.45144|  17.34969| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Hyderabad   | ZooPark                                       |

Getting data
============

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
| Anand Vihar | pm25      |    141| µg/m³ | IN      | Delhi | 2016-04-15 17:00:00 | 2016-04-15 17:00:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |    141| µg/m³ | IN      | Delhi | 2016-04-15 16:30:00 | 2016-04-15 16:30:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |    117| µg/m³ | IN      | Delhi | 2016-04-15 16:00:00 | 2016-04-15 16:00:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     69| µg/m³ | IN      | Delhi | 2016-04-15 14:00:00 | 2016-04-15 14:00:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     69| µg/m³ | IN      | Delhi | 2016-04-15 13:30:00 | 2016-04-15 13:30:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     47| µg/m³ | IN      | Delhi | 2016-04-15 13:00:00 | 2016-04-15 13:00:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |

``` r
kable(tableResults$timestamp)
```

| lastModif           | queriedAt           |
|:--------------------|:--------------------|
| 2016-04-16 14:05:50 | 2016-04-16 14:15:46 |

``` r
kable(tableResults$meta)
```

| name       | license   | website                    |  page|  limit|  found|
|:-----------|:----------|:---------------------------|-----:|------:|------:|
| openaq-api | CC BY 4.0 | <https://docs.openaq.org/> |     1|    100|   4388|

One could also get all possible parameters in the same table.

The `aq_latest` function
------------------------

This function gives a table with all newest measures for the locations that are chosen by the arguments. If all arguments are `NULL`, it gives all the newest measures for all locations.

``` r
tableLatest <- aq_latest()
kable(head(tableLatest$results))
```

| location          | city                 | country |  longitude|  latitude| parameter |    value| lastUpdated         | unit  | cityURL              | locationURL       |
|:------------------|:---------------------|:--------|----------:|---------:|:----------|--------:|:--------------------|:------|:---------------------|:------------------|
| 100 ail           | Ulaanbaatar          | MN      |  106.92138|  47.93291| co        |  417.000| 2016-04-16 13:45:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  106.92138|  47.93291| no2       |   27.000| 2016-04-16 13:45:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  106.92138|  47.93291| o3        |   42.000| 2016-04-16 13:45:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  106.92138|  47.93291| pm10      |  117.000| 2016-04-16 13:45:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |  106.92138|  47.93291| so2       |   14.000| 2016-04-16 13:45:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 16th and Whitmore | Omaha-Council Bluffs | US      |  -95.93799|  41.32247| o3        |    0.029| 2016-04-16 12:00:00 | ppm   | Omaha-Council+Bluffs | 16th+and+Whitmore |

Below are the latest values for Anand Vihar at the time this vignette was compiled (cache=FALSE).

``` r
tableLatest <- aq_latest(country="IN", city="Delhi", location="Anand+Vihar")
kable(head(tableLatest$results))
```

| location    | city  | country | longitude |  latitude| lastUpdated         | unit  | cityURL | locationURL |
|:------------|:------|:--------|:----------|---------:|:--------------------|:------|:--------|:------------|
| Anand Vihar | Delhi | IN      | co        |    1300.0| 2016-03-21 14:45:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | no2       |     100.7| 2016-04-15 17:00:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | o3        |      19.5| 2016-04-15 17:00:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | pm10      |     459.0| 2016-04-15 17:00:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | pm25      |     141.0| 2016-04-15 17:00:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | so2       |      18.0| 2016-03-21 14:45:00 | µg/m³ | Delhi   | Anand+Vihar |
