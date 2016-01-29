Ropenaq
=======

[![Build Status](https://travis-ci.org/masalmon/Ropenaq.svg)](https://travis-ci.org/masalmon/Ropenaq) [![Build status](https://ci.appveyor.com/api/projects/status/dgh82o8ldlgl6qrq?svg=true)](https://ci.appveyor.com/project/masalmon/ropenaq) [![codecov.io](https://codecov.io/github/masalmon/Ropenaq/coverage.svg?branch=master)](https://codecov.io/github/masalmon/Ropenaq?branch=master)

Introduction
============

This R package is aimed at accessing the openaq API. See the API documentation at <https://docs.openaq.org/>. The package contains 5 functions that correspond to the 5 different types of query offered by the openaq API: cities, countries, latest, locations and measurements. The package uses the `dplyr` package: all output tables are data.frame (dplyr "tbl\_df") objects, that can be further processed and analysed.

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
| TH   | Thailand       |  319986|
| CN   | China          |   12346|
| MN   | Mongolia       |  370276|
| GB   | United Kingdom |   99528|
| CL   | Chile          |  576243|
| US   | United States  |  164995|
| AU   | Australia      |  248640|
| IN   | India          |  114308|
| VN   | Viet Nam       |    1045|
| BR   | Brazil         |  385687|
| PL   | Poland         |  148900|
| NL   | Netherlands    |  732674|
| ID   | Indonesia      |    1580|

The `cities` function
---------------------

Using the `cities` functions one can get all cities for which information is available within the platform. For each city, one gets the number of locations and the count of measures for the city, the URL encoded string, and the country it is in.

``` r
citiesTable <- cities()
kable(head(citiesTable))
```

|  locations|  count| country | city         | cityURL      |
|----------:|------:|:--------|:-------------|:-------------|
|         14|  94329| NL      | Amsterdam    | Amsterdam    |
|          1|   2468| CL      | Andacollo    | Andacollo    |
|          1|   4552| CL      | Antofagasta  | Antofagasta  |
|          1|   2250| CL      | Arica        | Arica        |
|          1|   6039| TH      | Ayutthaya    | Ayutthaya    |
|          1|  10378| NL      | Badhoevedorp | Badhoevedorp |

The optional `country` argument allows to do this for a given country instead of the whole world.

``` r
citiesTableIndia <- cities(country="IN")
kable(citiesTableIndia)
```

|  locations|   count| country | city      | cityURL   |
|----------:|-------:|:--------|:----------|:----------|
|          1|    1046| IN      | Chennai   | Chennai   |
|          5|  110130| IN      | Delhi     | Delhi     |
|          1|    1044| IN      | Hyderabad | Hyderabad |
|          1|    1044| IN      | Kolkata   | Kolkata   |
|          1|    1044| IN      | Mumbai    | Mumbai    |

If one inputs a country that is not in the platform (or misspells a code), then an error message is thrown.

``` r
cities(country="PANEM")
```

    ## Error in buildQuery(country = country, query = query): This country is not available within the platform.

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
| Anand Vihar                   | Anand+Vihar                     | Delhi     | Delhi     | IN      |   4005| Anand Vihar         | 2015-06-29 14:30:00 | 2016-01-24 19:40:00 | pm25       |        NA|         NA|
| Mandir Marg                   | Mandir+Marg                     | Delhi     | Delhi     | IN      |   5871| Mandir Marg         | 2015-06-29 14:30:00 | 2016-01-24 20:00:00 | pm25       |        NA|         NA|
| Punjabi Bagh                  | Punjabi+Bagh                    | Delhi     | Delhi     | IN      |   5697| Punjabi Bagh        | 2015-06-29 00:30:00 | 2016-01-24 19:55:00 | pm25       |        NA|         NA|
| RK Puram                      | RK+Puram                        | Delhi     | Delhi     | IN      |   6186| RK Puram            | 2015-06-29 14:30:00 | 2016-01-24 19:55:00 | pm25       |        NA|         NA|
| US Diplomatic Post: Chennai   | US+Diplomatic+Post%3A+Chennai   | Chennai   | Chennai   | IN      |   1046| StateAir\_Chennai   | 2015-12-11 21:30:00 | 2016-01-29 13:30:00 | pm25       |  13.05237|   80.25193|
| US Diplomatic Post: Hyderabad | US+Diplomatic+Post%3A+Hyderabad | Hyderabad | Hyderabad | IN      |   1044| StateAir\_Hyderabad | 2015-12-11 21:30:00 | 2016-01-29 12:30:00 | pm25       |  17.44346|   78.47489|
| US Diplomatic Post: Kolkata   | US+Diplomatic+Post%3A+Kolkata   | Kolkata   | Kolkata   | IN      |   1044| StateAir\_Kolkata   | 2015-12-11 21:30:00 | 2016-01-29 12:30:00 | pm25       |  22.54714|   88.35105|
| US Diplomatic Post: Mumbai    | US+Diplomatic+Post%3A+Mumbai    | Mumbai    | Mumbai    | IN      |   1044| StateAir\_Mumbai    | 2015-12-11 21:30:00 | 2016-01-29 12:30:00 | pm25       |  19.06602|   72.86870|
| US Diplomatic Post: New Delhi | US+Diplomatic+Post%3A+New+Delhi | Delhi     | Delhi     | IN      |   1044| StateAir\_NewDelhi  | 2015-12-11 21:30:00 | 2016-01-29 12:30:00 | pm25       |  28.59810|   77.18907|

Then we could only choose to see the locations with results before 2015-10-01.

``` r
locationsIndia2 <- locations(country="IN", parameter="pm25", date_to="2015-10-01")
kable(locationsIndia2)
```

| location     | locationURL  | city  | cityURL | country |  count| sourceName   | firstUpdated        | lastUpdated         | parameters | latitude | longitude |
|:-------------|:-------------|:------|:--------|:--------|------:|:-------------|:--------------------|:--------------------|:-----------|:---------|:----------|
| Anand Vihar  | Anand+Vihar  | Delhi | Delhi   | IN      |   1499| Anand Vihar  | 2015-06-29 14:30:00 | 2015-09-14 12:30:00 | pm25       | NA       | NA        |
| Mandir Marg  | Mandir+Marg  | Delhi | Delhi   | IN      |   2023| Mandir Marg  | 2015-06-29 14:30:00 | 2015-09-30 23:50:00 | pm25       | NA       | NA        |
| Punjabi Bagh | Punjabi+Bagh | Delhi | Delhi   | IN      |   1516| Punjabi Bagh | 2015-06-29 00:30:00 | 2015-09-30 23:50:00 | pm25       | NA       | NA        |
| RK Puram     | RK+Puram     | Delhi | Delhi   | IN      |   1886| RK Puram     | 2015-06-29 14:30:00 | 2015-09-30 23:50:00 | pm25       | NA       | NA        |

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
| 2016-01-13 10:30:00 | 2016-01-13 16:00:00 | pm25      | Anand Vihar | Anand+Vihar |    264| µg/m³ | Delhi | IN      | NA       | NA        |
| 2016-01-13 11:10:00 | 2016-01-13 16:40:00 | pm25      | Anand Vihar | Anand+Vihar |    264| µg/m³ | Delhi | IN      | NA       | NA        |
| 2016-01-13 11:30:00 | 2016-01-13 17:00:00 | pm25      | Anand Vihar | Anand+Vihar |    132| µg/m³ | Delhi | IN      | NA       | NA        |
| 2016-01-13 12:10:00 | 2016-01-13 17:40:00 | pm25      | Anand Vihar | Anand+Vihar |    132| µg/m³ | Delhi | IN      | NA       | NA        |
| 2016-01-13 12:30:00 | 2016-01-13 18:00:00 | pm25      | Anand Vihar | Anand+Vihar |    460| µg/m³ | Delhi | IN      | NA       | NA        |
| 2016-01-13 13:20:00 | 2016-01-13 18:50:00 | pm25      | Anand Vihar | Anand+Vihar |    460| µg/m³ | Delhi | IN      | NA       | NA        |

One could also get all possible parameters in the same table.

The `latest` function
---------------------

This function gives a table with all newest measures for the locations that are chosen by the arguments. If all arguments are `NULL`, it gives all the newest measures for all locations.

``` r
tableLatest <- latest()
kable(head(tableLatest))
```

| location | locationURL | city        | cityURL     | country | parameter |    value| lastUpdated         | unit  |
|:---------|:------------|:------------|:------------|:--------|:----------|--------:|:--------------------|:------|
| 100 ail  | 100+ail     | Ulaanbaatar | Ulaanbaatar | MN      | co        |  3725.00| 2016-01-29 13:15:00 | µg/m³ |
| 100 ail  | 100+ail     | Ulaanbaatar | Ulaanbaatar | MN      | pm10      |    21.63| 2015-11-13 05:00:00 | µg/m³ |
| 100 ail  | 100+ail     | Ulaanbaatar | Ulaanbaatar | MN      | co        |     0.00| 2015-11-07 07:00:00 | ppm   |
| 100 ail  | 100+ail     | Ulaanbaatar | Ulaanbaatar | MN      | pm10      |     6.40| 2015-11-03 20:00:00 | µg/m³ |
| 100 ail  | 100+ail     | Ulaanbaatar | Ulaanbaatar | MN      | o3        |     6.00| 2015-10-23 06:00:00 | µg/m³ |
| 100 ail  | 100+ail     | Ulaanbaatar | Ulaanbaatar | MN      | co        |  1941.00| 2016-01-20 17:30:00 | µg/m³ |

Below are the latest values for Anand Vihar at the time this vignette was compiled (cache=FALSE).

``` r
tableLatest <- latest(country="IN", city="Delhi", location="Anand+Vihar")
kable(head(tableLatest))
```

| location    | locationURL | city  | cityURL | country | parameter |  value| lastUpdated         | unit  |
|:------------|:------------|:------|:--------|:--------|:----------|------:|:--------------------|:------|
| Anand Vihar | Anand+Vihar | Delhi | Delhi   | IN      | co        |  900.0| 2016-01-24 19:40:00 | µg/m³ |
| Anand Vihar | Anand+Vihar | Delhi | Delhi   | IN      | no2       |   39.8| 2016-01-16 22:30:00 | µg/m³ |
| Anand Vihar | Anand+Vihar | Delhi | Delhi   | IN      | o3        |    9.5| 2016-01-24 19:40:00 | µg/m³ |
| Anand Vihar | Anand+Vihar | Delhi | Delhi   | IN      | pm10      |  366.0| 2016-01-24 19:40:00 | µg/m³ |
| Anand Vihar | Anand+Vihar | Delhi | Delhi   | IN      | pm25      |  228.0| 2016-01-24 19:40:00 | µg/m³ |
| Anand Vihar | Anand+Vihar | Delhi | Delhi   | IN      | so2       |   18.3| 2016-01-16 10:10:00 | µg/m³ |
