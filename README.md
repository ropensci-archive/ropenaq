[![Build Status](https://travis-ci.org/masalmon/Ropenaq.svg)](https://travis-ci.org/masalmon/Ropenaq) [![codecov.io](https://codecov.io/github/masalmon/Ropenaq/coverage.svg?branch=master)](https://codecov.io/github/masalmon/Ropenaq?branch=master)

Introduction
============

This R package is aimed at accessing the openaq API. See the API documentation at <https://docs.openaq.org/>. The package contains 5 functions that correspond to the 5 different types of query offered by the openaq API: cities, countries, latest, locations and measurements. The package uses the `dplyr` package: all output tables are data.table objects, that can be further processed and analysed.

The package depends on three R packages in total: `httr`, `dplyr` and `lubridate`.

For installing the package,

``` r
library("devtools")
install_github("masalmon/Ropenaq")
```

Finding data availability
=========================

Three functions of the package allow to get lists of available information. Measurements are obtained from *locations* that are in *cities* that are in *countries*.

The `countries` function
------------------------

The `countries` function allows to see for which countries information is available within the platform. It is the easiest function because it does not have any argument.

``` r
library("Ropenaq")
countriesTable <- countries()
library("knitr")
kable(countriesTable)
```

| code | name           |   count|
|:-----|:---------------|-------:|
| AU   | Australia      |  197181|
| BR   | Brazil         |  310760|
| CL   | Chile          |  472829|
| CN   | China          |   11867|
| GB   | United Kingdom |   95743|
| ID   | Indonesia      |     562|
| IN   | India          |  107888|
| MN   | Mongolia       |  312353|
| NL   | Netherlands    |  594239|
| PL   | Poland         |  121878|
| TH   | Thailand       |  241829|
| US   | United States  |  125913|
| VN   | Viet Nam       |     536|

The `cities` function
---------------------

Using the `cities` functions one can get all cities for which information is available within the platform. For each city, one gets the number of locations and the count of measures for the city, and the country it is in.

``` r
citiesTable <- cities()
kable(head(citiesTable))
```

|  locations|  count| country | city         |
|----------:|------:|:--------|:-------------|
|         14|  73537| NL      | Amsterdam    |
|          1|   1910| CL      | Andacollo    |
|          1|   3530| CL      | Antofagasta  |
|          1|   1730| CL      | Arica        |
|          1|   4140| TH      | Ayutthaya    |
|          1|   8130| NL      | Badhoevedorp |

The optional `country` argument allows to do this for a given country instead of the whole world.

``` r
citiesTableIndia <- cities(country="IN")
kable(citiesTableIndia)
```

|  locations|   count| country | city      |
|----------:|-------:|:--------|:----------|
|          1|     426| IN      | Chennai   |
|          5|  102830| IN      | Delhi     |
|          1|     425| IN      | Hyderabad |
|          1|     425| IN      | Kolkata   |
|          1|     425| IN      | Mumbai    |

If one inputs a country that is not in the platform (or misspells a code), then an error message is thrown.

``` r
cities(country="PANEM")
```

    ## Error in cities(country = "PANEM"): This country is not available within the platform.

The `locations` function
------------------------

The `locations` function has far more arguments than the first two functions. On can filter locations in a given country, city, location, for a given parameter (valid values are "pm25", "pm10", "so2", "no2", "o3", "co" and "bc"), from a given date and/or up to a given date, for values between a minimum and a maximum. Below are several examples.

Here we only look for locations with PM2.5 information in India.

``` r
locationsIndia <- locations(country="IN", parameter="pm25")
kable(locationsIndia)
```

| location                      | city      | country |  count| sourceName          | firstUpdated        | lastUpdated         | parameters |  latitude|  longitude|
|:------------------------------|:----------|:--------|------:|:--------------------|:--------------------|:--------------------|:-----------|---------:|----------:|
| US Diplomatic Post: Chennai   | Chennai   | IN      |    426| StateAir\_Chennai   | 2015-12-11 21:30:00 | 2015-12-29 14:30:00 | pm25       |  13.05237|   80.25193|
| Anand Vihar                   | Delhi     | IN      |   3779| Anand Vihar         | 2015-06-29 14:30:00 | 2015-12-29 13:30:00 | pm25       |        NA|         NA|
| Mandir Marg                   | Delhi     | IN      |   5539| Mandir Marg         | 2015-06-29 14:30:00 | 2015-12-29 14:10:00 | pm25       |        NA|         NA|
| Punjabi Bagh                  | Delhi     | IN      |   5363| Punjabi Bagh        | 2015-06-29 00:30:00 | 2015-12-29 14:05:00 | pm25       |        NA|         NA|
| RK Puram                      | Delhi     | IN      |   5892| RK Puram            | 2015-06-29 14:30:00 | 2015-12-29 14:10:00 | pm25       |        NA|         NA|
| US Diplomatic Post: New Delhi | Delhi     | IN      |    425| StateAir\_NewDelhi  | 2015-12-11 21:30:00 | 2015-12-29 13:30:00 | pm25       |  28.59810|   77.18907|
| US Diplomatic Post: Hyderabad | Hyderabad | IN      |    425| StateAir\_Hyderabad | 2015-12-11 21:30:00 | 2015-12-29 13:30:00 | pm25       |  17.44346|   78.47489|
| US Diplomatic Post: Kolkata   | Kolkata   | IN      |    425| StateAir\_Kolkata   | 2015-12-11 21:30:00 | 2015-12-29 13:30:00 | pm25       |  22.54714|   88.35105|
| US Diplomatic Post: Mumbai    | Mumbai    | IN      |    425| StateAir\_Mumbai    | 2015-12-11 21:30:00 | 2015-12-29 13:30:00 | pm25       |  19.06602|   72.86870|

Then we could only choose to see the locations with results before 2015-10-01.

``` r
locationsIndia2 <- locations(country="IN", parameter="pm25", date_to="2015-10-01")
kable(locationsIndia2)
```

| location     | city  | country |  count| sourceName   | firstUpdated        | lastUpdated         | parameters |
|:-------------|:------|:--------|------:|:-------------|:--------------------|:--------------------|:-----------|
| Anand Vihar  | Delhi | IN      |   1499| Anand Vihar  | 2015-06-29 14:30:00 | 2015-09-14 12:30:00 | pm25       |
| Mandir Marg  | Delhi | IN      |   2023| Mandir Marg  | 2015-06-29 14:30:00 | 2015-09-30 23:50:00 | pm25       |
| Punjabi Bagh | Delhi | IN      |   1516| Punjabi Bagh | 2015-06-29 00:30:00 | 2015-09-30 23:50:00 | pm25       |
| RK Puram     | Delhi | IN      |   1886| RK Puram     | 2015-06-29 14:30:00 | 2015-09-30 23:50:00 | pm25       |

Getting data
============

Two functions allow to get data: `measurement` and `latest`.

The `measurements` function
---------------------------

The measurements function has many arguments for getting a query specific to, say, a given parameter in a given location. Below we get the PM2.5 measures for Anand Vihar in Delhi in India.

``` r
tableResults <- measurements(country="IN", city="Delhi", location="Anand+Vihar", parameter="pm25", limit=9)
kable(tableResults)
```

| dateUTC             | dateLocal           | parameter | location    |  value| unit  | city  | country | latitude | longitude |
|:--------------------|:--------------------|:----------|:------------|------:|:------|:------|:--------|:---------|:----------|
| 2015-12-29 08:30:00 | 2015-12-29 14:00:00 | pm25      | Anand Vihar |    121| µg/m³ | Delhi | IN      | NA       | NA        |
| 2015-12-29 08:50:00 | 2015-12-29 14:20:00 | pm25      | Anand Vihar |    121| µg/m³ | Delhi | IN      | NA       | NA        |
| 2015-12-29 09:30:00 | 2015-12-29 15:00:00 | pm25      | Anand Vihar |    102| µg/m³ | Delhi | IN      | NA       | NA        |
| 2015-12-29 10:30:00 | 2015-12-29 16:00:00 | pm25      | Anand Vihar |     84| µg/m³ | Delhi | IN      | NA       | NA        |
| 2015-12-29 11:30:00 | 2015-12-29 17:00:00 | pm25      | Anand Vihar |     78| µg/m³ | Delhi | IN      | NA       | NA        |
| 2015-12-29 12:10:00 | 2015-12-29 17:40:00 | pm25      | Anand Vihar |     78| µg/m³ | Delhi | IN      | NA       | NA        |
| 2015-12-29 12:30:00 | 2015-12-29 18:00:00 | pm25      | Anand Vihar |    104| µg/m³ | Delhi | IN      | NA       | NA        |
| 2015-12-29 13:10:00 | 2015-12-29 18:40:00 | pm25      | Anand Vihar |    104| µg/m³ | Delhi | IN      | NA       | NA        |
| 2015-12-29 13:30:00 | 2015-12-29 19:00:00 | pm25      | Anand Vihar |    129| µg/m³ | Delhi | IN      | NA       | NA        |

One could also get all possible parameters in the same table.

The `latest` function
---------------------

This function gives a table with all newest measures for the locations that are chosen by the arguments. If all arguments are `NULL`, it gives all the newest measures for all locations.

``` r
tableLatest <- latest()
kable(head(tableLatest))
```

| location         | city   | country | parameter |   value| lastUpdated         | unit  |
|:-----------------|:-------|:--------|:----------|-------:|:--------------------|:------|
| Tha Pradu, Mueng | Rayong | TH      | pm10      |  50.000| 2015-10-23 18:00:00 | µg/m³ |
| Tha Pradu, Mueng | Rayong | TH      | no2       |   0.039| 2015-11-19 01:00:00 | ppm   |
| Tha Pradu, Mueng | Rayong | TH      | pm25      |  15.150| 2015-12-01 22:00:00 | µg/m³ |
| Tha Pradu, Mueng | Rayong | TH      | o3        |   0.017| 2015-12-02 01:00:00 | ppm   |
| Tha Pradu, Mueng | Rayong | TH      | so2       |   8.056| 2015-12-02 10:00:00 | µg/m³ |
| Tha Pradu, Mueng | Rayong | TH      | so2       |   2.750| 2015-12-02 10:00:00 | µg/m³ |

Below are the latest values for Anand Vihar at the time this vignette was compiled (cache=TRUE).

``` r
tableLatest <- latest(country="IN", city="Delhi", location="Anand+Vihar")
kable(head(tableLatest))
```

| location    | city  | country | parameter |   value| lastUpdated         | unit  |
|:------------|:------|:--------|:----------|-------:|:--------------------|:------|
| Anand Vihar | Delhi | IN      | pm10      |   516.0| 2015-12-29 13:30:00 | µg/m³ |
| Anand Vihar | Delhi | IN      | so2       |    24.1| 2015-12-29 13:30:00 | µg/m³ |
| Anand Vihar | Delhi | IN      | o3        |     9.6| 2015-12-29 13:30:00 | µg/m³ |
| Anand Vihar | Delhi | IN      | no2       |   116.9| 2015-12-29 13:30:00 | µg/m³ |
| Anand Vihar | Delhi | IN      | pm25      |   129.0| 2015-12-29 13:30:00 | µg/m³ |
| Anand Vihar | Delhi | IN      | co        |  2800.0| 2015-12-29 13:30:00 | µg/m³ |
