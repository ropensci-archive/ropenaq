ropenaq
=======

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/ropenaq)](http://cran.r-project.org/package=ropenaq) [![Build Status](https://travis-ci.org/ropensci/ropenaq.svg?branch=master)](https://travis-ci.org/ropensci/ropenaq) [![Build status](https://ci.appveyor.com/api/projects/status/jlfxconpqnf0fta4?svg=true)](https://ci.appveyor.com/project/ropensci/ropenaq) [![codecov.io](https://codecov.io/github/ropensci/ropenaq/coverage.svg?branch=master)](https://codecov.io/github/ropensci/Ropenaq?branch=master)
[![](https://badges.ropensci.org/24_status.svg)](https://github.com/ropensci/onboarding/issues/24)

# Introduction

This R package is aimed at accessing the openaq API. OpenAQ is a community of scientists, software developers, and lovers of open environmental data who are building an open, real-time database that provides programmatic and historical access to air quality data. See their website at <https://openaq.org/> and see the API documentation at <https://docs.openaq.org/>. The package contains 5 functions that correspond to the 5 different types of query offered by the openaq API: cities, countries, latest, locations and measurements. The package uses the `dplyr` package: all output tables are data.frame (dplyr "tbl_df") objects, that can be further processed and analysed.

Check out [this blog post](https://ropensci.org/blog/blog/2017/02/21/ropenaq) about OpenAQ.

More details about the package can be found [in the vignettes](http://docs.ropensci.org/ropenaq/articles/index.html), in particular the [introductory vignette](http://docs.ropensci.org/ropenaq/articles/Ropenaq-vignette.html).

Via the API since November 2017 the API only provides access to the latest 90 days of OpenAQ data. The whole OpenAQ data can be accessed via Amazon S3. See [this announcement](https://medium.com/@openaq/changes-to-the-openaq-api-and-how-to-access-the-full-archive-of-data-3324b136da8c). You can interact with Amazon S3 using [the `aws.s3` package]( https://CRAN.R-project.org/package=aws.s3) and the maintainer of `ropenaq` plans to write tutorials about how to access OpenAQ data and will also keep the documentation of `ropenaq` up-to-date regarding data access changes.

# Installation

Install the package with:

```r
install.packages("ropenaq")
```

Or install the development version using [devtools](https://github.com/hadley/devtools) with:

```r
library("devtools")
install_github("ropensci/ropenaq")

```

If you experience trouble using the package on a Linux machine, please run

```r
url::curl_version()$ssl_version
```

If it answers `GnuTLS`,  run

```
apt-get install libcurl4-openssl-dev
```

And desinstall then re-install `curl`.

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
