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
| Australia              | AU   |      11|         28|   634272|
| Bosnia and Herzegovina | BA   |       4|         11|   107982|
| Bangladesh             | BD   |       1|          2|     4137|
| Brazil                 | BR   |      73|         97|   979608|
| Canada                 | CA   |      11|        157|   358236|
| Chile                  | CL   |      93|        102|  1438463|
| China                  | CN   |       5|          6|    41969|
| Colombia               | CO   |       1|          1|     2613|
| United Kingdom         | GB   |     105|        152|  1118266|
| Indonesia              | ID   |       2|          3|    11985|
| Israel                 | IL   |       1|          1|     1826|
| India                  | IN   |      30|         65|   768914|
| Mongolia               | MN   |       1|         12|   781745|
| Mexico                 | MX   |       5|         48|   344799|
| Nigeria                | NG   |       1|          1|     2541|
| Netherlands            | NL   |      63|         93|  1706432|
| Peru                   | PE   |       1|         11|   136909|
| Philippines            | PH   |       1|          1|      958|
| Poland                 | PL   |       9|         14|   354922|
| Singapore              | SG   |       1|          1|     1275|
| Thailand               | TH   |      33|         61|   844716|
| United States          | US   |     670|       1681|  5400225|
| Viet Nam               | VN   |       2|          3|     8705|
| Kosovo                 | XK   |       1|          1|     2079|

``` r
kable(countriesTable$meta)
```

| name       | license   | website                    |  page|  limit|  found|
|:-----------|:----------|:---------------------------|-----:|------:|------:|
| openaq-api | CC BY 4.0 | <https://docs.openaq.org/> |     1|    100|     24|

``` r
kable(countriesTable$timestamp)
```

| lastModif           | queriedAt           |
|:--------------------|:--------------------|
| 2016-07-04 13:12:34 | 2016-07-04 13:14:12 |

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
| ABBEVILLE | US      |          1|   1717| ABBEVILLE |
| Aberdeen  | GB      |          3|  16907| Aberdeen  |
| Aberdeen  | US      |          2|   3665| Aberdeen  |
| ADA       | US      |          1|   5151| ADA       |
| ADAIR     | US      |          1|   7729| ADAIR     |

The optional `country` argument allows to do this for a given country instead of the whole world.

``` r
citiesTableIndia <- aq_cities(country="IN")
kable(citiesTableIndia$results)
```

| city          | country |  locations|   count| cityURL       |
|:--------------|:--------|----------:|-------:|:--------------|
| Agra          | IN      |          1|   12612| Agra          |
| Ahmedabad     | IN      |          1|    1689| Ahmedabad     |
| Bengaluru     | IN      |          5|   43613| Bengaluru     |
| Chandrapur    | IN      |          1|   20930| Chandrapur    |
| Chennai       | IN      |          4|   23565| Chennai       |
| Chittoor      | IN      |          1|    2013| Chittoor      |
| Delhi         | IN      |         15|  229036| Delhi         |
| Faridabad     | IN      |          1|   24157| Faridabad     |
| Gaya          | IN      |          1|    7275| Gaya          |
| Gurgaon       | IN      |          1|   24841| Gurgaon       |
| Haldia        | IN      |          1|   14580| Haldia        |
| Howrah        | IN      |          1|     967| Howrah        |
| Hyderabad     | IN      |          3|   44058| Hyderabad     |
| Jaipur        | IN      |          1|   35309| Jaipur        |
| Jodhpur       | IN      |          1|   38591| Jodhpur       |
| Kanpur        | IN      |          2|   29781| Kanpur        |
| Kolkata       | IN      |          2|    6488| Kolkata       |
| Lucknow       | IN      |          4|   14832| Lucknow       |
| Mumbai        | IN      |          3|   42300| Mumbai        |
| Muzaffarpur   | IN      |          1|   24151| Muzaffarpur   |
| Nagpur        | IN      |          4|    8641| Nagpur        |
| Nashik        | IN      |          2|    5031| Nashik        |
| Panchkula     | IN      |          1|   20510| Panchkula     |
| Patna         | IN      |          1|   14267| Patna         |
| Pune          | IN      |          1|   12337| Pune          |
| Rohtak        | IN      |          1|    3531| Rohtak        |
| Solapur       | IN      |          1|   28694| Solapur       |
| Tirupati      | IN      |          2|    1183| Tirupati      |
| Varanasi      | IN      |          1|   32353| Varanasi      |
| Visakhapatnam | IN      |          2|    1579| Visakhapatnam |

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

| location                                      | city          | country | sourceName          |  count| lastUpdated         | firstUpdated        |  latitude|  longitude| pm25 | pm10  | no2   | so2   | o3    | co    | bc    | cityURL       | locationURL                                   |
|:----------------------------------------------|:--------------|:--------|:--------------------|------:|:--------------------|:--------------------|---------:|----------:|:-----|:------|:------|:------|:------|:------|:------|:--------------|:----------------------------------------------|
| AAQMS Karve Road Pune                         | Pune          | IN      | CPCB                |   2966| 2016-07-04 12:45:00 | 2016-03-21 08:00:00 |  18.49748|   73.81349| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Pune          | AAQMS+Karve+Road+Pune                         |
| Anand Vihar                                   | Delhi         | IN      | CPCB                |   6518| 2016-07-04 12:55:00 | 2015-06-29 14:30:00 |  28.65080|   77.31520| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi         | Anand+Vihar                                   |
| AP Tirumala                                   | Chittoor      | IN      | CPCB                |    493| 2016-07-04 06:15:00 | 2016-06-23 05:30:00 |        NA|         NA| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chittoor      | AP+Tirumala                                   |
| Ardhali Bazar                                 | Varanasi      | IN      | CPCB                |   6475| 2016-07-04 12:55:00 | 2016-03-22 00:05:00 |  25.35056|   82.97833| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Varanasi      | Ardhali+Bazar                                 |
| Central School                                | Lucknow       | IN      | CPCB                |   1913| 2016-07-04 00:30:00 | 2016-03-22 10:00:00 |  26.85273|   80.99633| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Lucknow       | Central+School                                |
| Chandrapur                                    | Chandrapur    | IN      | CPCB                |   3346| 2016-07-04 10:25:00 | 2016-03-22 00:25:00 |  19.95000|   79.30000| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chandrapur    | Chandrapur                                    |
| Civil Lines                                   | Delhi         | IN      | CPCB                |      1| 2015-07-10 08:15:00 | 2015-07-10 08:15:00 |  28.67870|   77.22620| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi         | Civil+Lines                                   |
| Collectorate - Gaya - BSPCB                   | Gaya          | IN      | CPCB                |   1721| 2016-04-28 13:05:00 | 2016-03-21 16:35:00 |  24.74897|   84.94384| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Gaya          | Collectorate+-+Gaya+-+BSPCB                   |
| Collectorate Jodhpur - RSPCB                  | Jodhpur       | IN      | CPCB                |   6420| 2016-06-24 10:45:00 | 2016-03-21 18:30:00 |  26.29206|   73.03791| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Jodhpur       | Collectorate+Jodhpur+-+RSPCB                  |
| Collectorate - Muzaffarpur - BSPCB            | Muzaffarpur   | IN      | CPCB                |   4845| 2016-07-04 13:10:00 | 2016-03-19 09:20:00 |  26.07620|   85.41150| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Muzaffarpur   | Collectorate+-+Muzaffarpur+-+BSPCB            |
| GVM Corporation                               | Visakhapatnam | IN      | CPCB                |    263| 2016-07-01 05:30:00 | 2016-06-20 18:30:00 |        NA|         NA| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Visakhapatnam | GVM+Corporation                               |
| IGI Airport                                   | Delhi         | IN      | CPCB                |      1| 2015-07-10 06:30:00 | 2015-07-10 06:30:00 |  28.56000|   77.09400| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi         | IGI+Airport                                   |
| IGSC Planetarium Complex - Patna - BSPCB      | Patna         | IN      | CPCB                |   3480| 2016-07-04 12:45:00 | 2016-03-21 19:30:00 |  25.36360|   85.07550| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Patna         | IGSC+Planetarium+Complex+-+Patna+-+BSPCB      |
| Maharashtra Pollution Control Board Bandra    | Mumbai        | IN      | CPCB                |   3620| 2016-07-04 05:00:00 | 2016-03-21 16:15:00 |  19.04185|   72.86551| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai        | Maharashtra+Pollution+Control+Board+Bandra    |
| Maharashtra Pollution Control Board - Solapur | Solapur       | IN      | CPCB                |   4584| 2016-07-04 13:00:00 | 2016-03-21 18:30:00 |  17.65992|   75.90639| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Solapur       | Maharashtra+Pollution+Control+Board+-+Solapur |
| Mandir Marg                                   | Delhi         | IN      | CPCB                |  10470| 2016-07-04 12:55:00 | 2015-06-29 14:30:00 |  28.63410|   77.20050| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi         | Mandir+Marg                                   |
| Navi Mumbai Municipal Corporation Airoli      | Mumbai        | IN      | CPCB                |   6379| 2016-07-04 13:15:00 | 2016-03-21 18:30:00 |  19.14940|   72.99860| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai        | Navi+Mumbai+Municipal+Corporation+Airoli      |
| Nehru Nagar                                   | Kanpur        | IN      | CPCB                |   5624| 2016-07-04 12:35:00 | 2016-03-21 22:45:00 |  26.47031|   80.32517| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Kanpur        | Nehru+Nagar                                   |
| Punjabi Bagh                                  | Delhi         | IN      | CPCB                |  11625| 2016-07-04 12:55:00 | 2015-06-29 00:30:00 |  28.66830|   77.11670| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi         | Punjabi+Bagh                                  |
| R K Puram                                     | Delhi         | IN      | CPCB                |   2786| 2016-07-04 12:55:00 | 2016-03-21 23:55:00 |  28.56480|   77.17440| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi         | R+K+Puram                                     |
| RK Puram                                      | Delhi         | IN      | RK Puram            |   8593| 2016-03-22 00:10:00 | 2015-06-29 14:30:00 |  28.56480|   77.17440| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi         | RK+Puram                                      |
| Sanjay Palace                                 | Agra          | IN      | CPCB                |   3922| 2016-07-04 13:05:00 | 2016-03-22 00:20:00 |  27.19866|   78.00598| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Agra          | Sanjay+Palace                                 |
| Sector 6 Panchkula - HSPCB                    | Panchkula     | IN      | CPCB                |   4172| 2016-07-04 13:15:00 | 2016-03-21 18:30:00 |  30.70578|   76.85318| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Panchkula     | Sector+6+Panchkula+-+HSPCB                    |
| SPARTAN - IIT Kanpur                          | Kanpur        | IN      | Spartan             |   1684| 2014-09-26 00:30:00 | 2013-12-14 10:30:00 |  26.51900|   80.23300| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Kanpur        | SPARTAN+-+IIT+Kanpur                          |
| Tirumala                                      | Tirupati      | IN      | CPCB                |      4| 2016-07-04 13:00:00 | 2016-07-04 06:15:00 |        NA|         NA| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Tirupati      | Tirumala                                      |
| US Diplomatic Post: Chennai                   | Chennai       | IN      | StateAir\_Chennai   |   4759| 2016-07-04 12:30:00 | 2015-12-11 21:30:00 |  13.05237|   80.25193| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai       | US+Diplomatic+Post%3A+Chennai                 |
| US Diplomatic Post: Hyderabad                 | Hyderabad     | IN      | StateAir\_Hyderabad |   4759| 2016-07-04 12:30:00 | 2015-12-11 21:30:00 |  17.44346|   78.47489| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Hyderabad     | US+Diplomatic+Post%3A+Hyderabad               |
| US Diplomatic Post: Kolkata                   | Kolkata       | IN      | StateAir\_Kolkata   |   4759| 2016-07-04 12:30:00 | 2015-12-11 21:30:00 |  22.54714|   88.35105| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Kolkata       | US+Diplomatic+Post%3A+Kolkata                 |
| US Diplomatic Post: Mumbai                    | Mumbai        | IN      | StateAir\_Mumbai    |   4759| 2016-07-04 12:30:00 | 2015-12-11 21:30:00 |  19.06602|   72.86870| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai        | US+Diplomatic+Post%3A+Mumbai                  |
| US Diplomatic Post: New Delhi                 | Delhi         | IN      | StateAir\_NewDelhi  |   4809| 2016-07-04 12:30:00 | 2015-12-11 21:30:00 |  28.59810|   77.18907| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi         | US+Diplomatic+Post%3A+New+Delhi               |
| Vikas Sadan Gurgaon - HSPCB                   | Gurgaon       | IN      | CPCB                |   4338| 2016-06-21 06:30:00 | 2016-03-25 07:15:00 |  28.45013|   77.02631| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Gurgaon       | Vikas+Sadan+Gurgaon+-+HSPCB                   |
| Visakhapatnam                                 | Visakhapatnam | IN      | CPCB                |      1| 2016-06-21 11:30:00 | 2016-06-21 11:30:00 |        NA|         NA| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Visakhapatnam | Visakhapatnam                                 |
| VK Industrial Area Jaipur - RSPCB             | Jaipur        | IN      | CPCB                |   6240| 2016-07-04 12:45:00 | 2016-03-21 18:30:00 |  26.97388|   75.77388| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Jaipur        | VK+Industrial+Area+Jaipur+-+RSPCB             |
| ZooPark                                       | Hyderabad     | IN      | CPCB                |   4615| 2016-05-29 16:45:00 | 2016-03-21 18:30:00 |  17.34969|   78.45144| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | FALSE | Hyderabad     | ZooPark                                       |

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
| Anand Vihar | pm25      |     90| µg/m³ | IN      | Delhi | 2016-07-04 12:55:00 | 2016-07-04 18:25:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     87| µg/m³ | IN      | Delhi | 2016-07-04 12:25:00 | 2016-07-04 17:55:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     87| µg/m³ | IN      | Delhi | 2016-07-04 11:55:00 | 2016-07-04 17:25:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     77| µg/m³ | IN      | Delhi | 2016-07-04 05:25:00 | 2016-07-04 10:55:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     77| µg/m³ | IN      | Delhi | 2016-07-04 04:55:00 | 2016-07-04 10:25:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |    107| µg/m³ | IN      | Delhi | 2016-07-04 04:25:00 | 2016-07-04 09:55:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |

``` r
kable(tableResults$timestamp)
```

| lastModif           | queriedAt           |
|:--------------------|:--------------------|
| 2016-07-04 13:12:34 | 2016-07-04 13:14:22 |

``` r
kable(tableResults$meta)
```

| name       | license   | website                    |  page|  limit|  found|
|:-----------|:----------|:---------------------------|-----:|------:|------:|
| openaq-api | CC BY 4.0 | <https://docs.openaq.org/> |     1|    100|   6518|

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
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| co        |  678.000| 2016-07-04 13:00:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| no2       |   35.000| 2016-07-04 13:00:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| o3        |   32.000| 2016-07-04 13:00:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| pm10      |  184.000| 2016-07-04 13:00:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| so2       |    0.000| 2016-07-04 13:00:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 16th and Whitmore | Omaha-Council Bluffs | US      |   41.32247|  -95.93799| o3        |    0.031| 2016-07-03 10:00:00 | ppm   | Omaha-Council+Bluffs | 16th+and+Whitmore |

Below are the latest values for Anand Vihar at the time this vignette was compiled (cache=FALSE).

``` r
tableLatest <- aq_latest(country="IN", city="Delhi", location="Anand+Vihar")
kable(head(tableLatest$results))
```

| location    | city  | country |  longitude|  latitude| parameter |   value| lastUpdated         | unit  | cityURL | locationURL |
|:------------|:------|:--------|----------:|---------:|:----------|-------:|:--------------------|:------|:--------|:------------|
| Anand Vihar | Delhi | IN      |    28.6508|   77.3152| co        |  1300.0| 2016-03-21 14:45:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |    28.6508|   77.3152| no2       |    55.8| 2016-07-04 12:55:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |    28.6508|   77.3152| o3        |    16.5| 2016-07-04 12:55:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |    28.6508|   77.3152| pm10      |   190.0| 2016-07-04 12:55:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      |    28.6508|   77.3152| pm25      |    90.0| 2016-07-04 12:55:00 | µg/m³ | Delhi   | Anand+Vihar |
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
| openaq-api | CC BY 4.0 | <https://docs.openaq.org/> |     1|    100|  44803|

``` r
how_many$found
```

    ## [1] 44803

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
