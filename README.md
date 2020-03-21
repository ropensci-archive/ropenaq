ropenaq
=======

> Access OpenAQ global and open air quality data

<!-- badges: start -->
  [![R build status](https://github.com/ropensci/ropenaq/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci/ropenaq/actions?query=workflow%3AR-CMD-check)
  [![codecov.io](https://codecov.io/github/ropensci/ropenaq/coverage.svg?branch=master)](https://codecov.io/github/ropensci/Ropenaq?branch=master)
[![rOpenSci peer-review](https://badges.ropensci.org/24_status.svg)](https://github.com/ropensci/software-review/issues/24)
[![CRAN](https://www.r-pkg.org/badges/version/ropenaq)](https://cran.r-project.org/web/packages/ropenaq/index.html)
  <!-- badges: end -->
  
# Introduction

This R package is aimed at accessing the OpenAQ API. OpenAQ is a community of scientists, software developers, and lovers of open environmental data who are building an open, real-time database that provides programmatic and historical access to air quality data. See their website at <https://openaq.org/> and see the API documentation at <https://docs.openaq.org/>. The package contains 5 functions that correspond to the 5 different types of query offered by the openaq API: cities, countries, latest, locations and measurements. The package uses the `dplyr` package: all output tables are tibble objects, that can be further processed and analysed.

Check out [this blog post](https://ropensci.org/blog/blog/2017/02/21/ropenaq) about OpenAQ.

More details about the package can be found [in the articles](http://docs.ropensci.org/ropenaq/articles/index.html), in particular the [introductory articles](https://docs.ropensci.org/ropenaq/articles/ropenaq.html).

Via the API since November 2017 the API only provides access to the latest 90 days of OpenAQ data. The whole OpenAQ data can be accessed via Amazon S3. See [this announcement](https://medium.com/@openaq/changes-to-the-openaq-api-and-how-to-access-the-full-archive-of-data-3324b136da8c). You can interact with Amazon S3 using [the `aws.s3` package]( https://CRAN.R-project.org/package=aws.s3) and the maintainer of `ropenaq` plans to write tutorials about how to access OpenAQ data and will also keep the documentation of `ropenaq` up-to-date regarding data access changes.

# Installation

Install the package with:

```r
install.packages("ropenaq")
```

Or install the development version:

```r
# install.packages("remotes")
remotes::install_github("ropensci/ropenaq")

```

If you experience trouble using the package on a Linux machine, please run

```r
url::curl_version()$ssl_version
```

If it answers `GnuTLS`,  run

```
apt-get install libcurl4-openssl-dev
```

And uninstall then re-install `curl`.

```r
install.packages("curl")
```

If it still doesn't work, please open a new issue!

# Meta

* Please [report any issues or bugs](https://github.com/ropensci/ropenaq/issues).
* License: GPL
* Get citation information for `ropenaq` in R doing `citation(package = 'ropenaq')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci_footer](http://www.ropensci.org/public_images/github_footer.png)](http://ropensci.org)
