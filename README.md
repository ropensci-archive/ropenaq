[![Build Status](https://travis-ci.org/masalmon/Ropenaq.svg)](https://travis-ci.org/masalmon/Ropenaq) [![Build status](https://ci.appveyor.com/api/projects/status/dgh82o8ldlgl6qrq?svg=true)](https://ci.appveyor.com/project/masalmon/ropenaq) [![codecov.io](https://codecov.io/github/masalmon/Ropenaq/coverage.svg?branch=master)](https://codecov.io/github/masalmon/Ropenaq?branch=master)

Introduction
============

This R package is aimed at accessing the openaq API. See the API documentation at <https://docs.openaq.org/>. The package contains 5 functions that correspond to the 5 different types of query offered by the openaq API: cities, countries, latest, locations and measurements. The package uses the `dplyr` package: all output tables are data.table objects, that can be further processed and analysed.

For installing the package, you can copy the following lines. Set `build_vignettes` to FALSE if you do not wish to install the suggested packages.

``` r
library("devtools")
install_github("masalmon/Ropenaq", build_vignettes=TRUE)
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
| AU   | Australia      |  221694|
| BR   | Brazil         |  346455|
| CL   | Chile          |  520316|
| CN   | China          |   12210|
| GB   | United Kingdom |   98425|
| ID   | Indonesia      |    1052|
| IN   | India          |  112924|
| MN   | Mongolia       |  340356|
| NL   | Netherlands    |  661614|
| PL   | Poland         |  135583|
| TH   | Thailand       |  280272|
| US   | United States  |  144710|
| VN   | Viet Nam       |     781|

The `cities` function
---------------------

Using the `cities` functions one can get all cities for which information is available within the platform. For each city, one gets the number of locations and the count of measures for the city, the URL encoded string, and the country it is in.

``` r
citiesTable <- cities()
kable(head(citiesTable))
```

|  locations|  count| country | city         | cityURL      |
|----------:|------:|:--------|:-------------|:-------------|
|         14|  81241| NL      | Amsterdam    | Amsterdam    |
|          1|   2097| CL      | Andacollo    | Andacollo    |
|          1|   3884| CL      | Antofagasta  | Antofagasta  |
|          1|   1919| CL      | Arica        | Arica        |
|          1|   4912| TH      | Ayutthaya    | Ayutthaya    |
|          1|   8986| NL      | Badhoevedorp | Badhoevedorp |

The optional `country` argument allows to do this for a given country instead of the whole world.

``` r
citiesTableIndia <- cities(country="IN")
kable(citiesTableIndia)
```

|  locations|   count| country | city      | cityURL   |
|----------:|-------:|:--------|:----------|:----------|
|          1|     662| IN      | Chennai   | Chennai   |
|          5|  107036| IN      | Delhi     | Delhi     |
|          1|     661| IN      | Hyderabad | Hyderabad |
|          1|     661| IN      | Kolkata   | Kolkata   |
|          1|     661| IN      | Mumbai    | Mumbai    |

If one inputs a country that is not in the platform (or misspells a code), then an error message is thrown.

``` r
cities(country="PANEM")
```

    ## Error in cities(country = "PANEM"): This country is not available within the platform.

The `locations` function
------------------------

The `locations` function has far more arguments than the first two functions. On can filter locations in a given country, city, location, for a given parameter (valid values are "pm25", "pm10", "so2", "no2", "o3", "co" and "bc"), from a given date and/or up to a given date, for values between a minimum and a maximum. In the output table one also gets URL encoded strings for the city and the location. Below are several examples.

Here we only look for locations with PM2.5 information in India.

``` r
locationsIndia <- locations(country="IN", parameter="pm25")
kable(locationsIndia)
```

| location                      | locationURL                     | city      | cityURL   | country |  count| sourceName          | firstUpdated        | lastUpdated         | parameters |  latitude|  longitude|
|:------------------------------|:--------------------------------|:----------|:----------|:--------|------:|:--------------------|:--------------------|:--------------------|:-----------|---------:|----------:|
| US Diplomatic Post: Chennai   | US+Diplomatic+Post%3A+Chennai   | Chennai   | Chennai   | IN      |    662| StateAir\_Chennai   | 2015-12-11 21:30:00 | 2016-01-13 13:30:00 | pm25       |  13.05237|   80.25193|
| Anand Vihar                   | Anand+Vihar                     | Delhi     | Delhi     | IN      |   3911| Anand Vihar         | 2015-06-29 14:30:00 | 2016-01-13 13:20:00 | pm25       |        NA|         NA|
| Mandir Marg                   | Mandir+Marg                     | Delhi     | Delhi     | IN      |   5729| Mandir Marg         | 2015-06-29 14:30:00 | 2016-01-13 13:50:00 | pm25       |        NA|         NA|
| Punjabi Bagh                  | Punjabi+Bagh                    | Delhi     | Delhi     | IN      |   5565| Punjabi Bagh        | 2015-06-29 00:30:00 | 2016-01-13 13:45:00 | pm25       |        NA|         NA|
| RK Puram                      | RK+Puram                        | Delhi     | Delhi     | IN      |   6077| RK Puram            | 2015-06-29 14:30:00 | 2016-01-13 13:50:00 | pm25       |        NA|         NA|
| US Diplomatic Post: New Delhi | US+Diplomatic+Post%3A+New+Delhi | Delhi     | Delhi     | IN      |    661| StateAir\_NewDelhi  | 2015-12-11 21:30:00 | 2016-01-13 13:30:00 | pm25       |  28.59810|   77.18907|
| US Diplomatic Post: Hyderabad | US+Diplomatic+Post%3A+Hyderabad | Hyderabad | Hyderabad | IN      |    661| StateAir\_Hyderabad | 2015-12-11 21:30:00 | 2016-01-13 13:30:00 | pm25       |  17.44346|   78.47489|
| US Diplomatic Post: Kolkata   | US+Diplomatic+Post%3A+Kolkata   | Kolkata   | Kolkata   | IN      |    661| StateAir\_Kolkata   | 2015-12-11 21:30:00 | 2016-01-13 13:30:00 | pm25       |  22.54714|   88.35105|
| US Diplomatic Post: Mumbai    | US+Diplomatic+Post%3A+Mumbai    | Mumbai    | Mumbai    | IN      |    661| StateAir\_Mumbai    | 2015-12-11 21:30:00 | 2016-01-13 13:30:00 | pm25       |  19.06602|   72.86870|

Then we could only choose to see the locations with results before 2015-10-01.

``` r
locationsIndia2 <- locations(country="IN", parameter="pm25", date_to="2015-10-01")
kable(locationsIndia2)
```

| location     | locationURL  | city  | cityURL | country |  count| sourceName   | firstUpdated        | lastUpdated         | parameters |
|:-------------|:-------------|:------|:--------|:--------|------:|:-------------|:--------------------|:--------------------|:-----------|
| Anand Vihar  | Anand+Vihar  | Delhi | Delhi   | IN      |   1499| Anand Vihar  | 2015-06-29 14:30:00 | 2015-09-14 12:30:00 | pm25       |
| Mandir Marg  | Mandir+Marg  | Delhi | Delhi   | IN      |   2023| Mandir Marg  | 2015-06-29 14:30:00 | 2015-09-30 23:50:00 | pm25       |
| Punjabi Bagh | Punjabi+Bagh | Delhi | Delhi   | IN      |   1516| Punjabi Bagh | 2015-06-29 00:30:00 | 2015-09-30 23:50:00 | pm25       |
| RK Puram     | RK+Puram     | Delhi | Delhi   | IN      |   1886| RK Puram     | 2015-06-29 14:30:00 | 2015-09-30 23:50:00 | pm25       |

Getting data
============

Two functions allow to get data: `measurement` and `latest`. In both of them the arguments city and location needs to be given as URL encoded strings.

The `measurements` function
---------------------------

The measurements function has many arguments for getting a query specific to, say, a given parameter in a given location. Below we get the PM2.5 measures for Anand Vihar in Delhi in India.

``` r
tableResults <- measurements(country="IN", city="Delhi", location="Anand+Vihar", parameter="pm25")
kable(head(tableResults))
```

| dateUTC             | dateLocal           | parameter | location    | locationURL |  value| unit  | city  | country | latitude | longitude |
|:--------------------|:--------------------|:----------|:------------|:------------|------:|:------|:------|:--------|:---------|:----------|
| 2016-01-05 12:00:00 | 2016-01-05 17:30:00 | pm25      | Anand Vihar | Anand+Vihar |    343| µg/m³ | Delhi | IN      | NA       | NA        |
| 2016-01-05 12:20:00 | 2016-01-05 17:50:00 | pm25      | Anand Vihar | Anand+Vihar |    343| µg/m³ | Delhi | IN      | NA       | NA        |
| 2016-01-05 13:00:00 | 2016-01-05 18:30:00 | pm25      | Anand Vihar | Anand+Vihar |    344| µg/m³ | Delhi | IN      | NA       | NA        |
| 2016-01-05 13:20:00 | 2016-01-05 18:50:00 | pm25      | Anand Vihar | Anand+Vihar |    344| µg/m³ | Delhi | IN      | NA       | NA        |
| 2016-01-05 14:00:00 | 2016-01-05 19:30:00 | pm25      | Anand Vihar | Anand+Vihar |    381| µg/m³ | Delhi | IN      | NA       | NA        |
| 2016-01-05 14:20:00 | 2016-01-05 19:50:00 | pm25      | Anand Vihar | Anand+Vihar |    381| µg/m³ | Delhi | IN      | NA       | NA        |

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
| Anand Vihar | Delhi | IN      | pm10      |   859.0| 2016-01-13 13:20:00 | µg/m³ |
| Anand Vihar | Delhi | IN      | so2       |    15.9| 2016-01-13 13:35:00 | µg/m³ |
| Anand Vihar | Delhi | IN      | o3        |     8.9| 2016-01-13 13:35:00 | µg/m³ |
| Anand Vihar | Delhi | IN      | no2       |   127.5| 2016-01-13 13:35:00 | µg/m³ |
| Anand Vihar | Delhi | IN      | pm25      |   460.0| 2016-01-13 13:20:00 | µg/m³ |
| Anand Vihar | Delhi | IN      | co        |  2900.0| 2016-01-13 13:35:00 | µg/m³ |
