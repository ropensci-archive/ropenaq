# ropenaq (development version)

* Skip a vcr-enabled test on CRAN because of a vcr problem with encoding.

# ropenaq 0.2.8

* Bug fixes (page has now a maximum argument; no longer passing an empty param in the query)

* Replacement of `tidyr` and `dplyr` deprecated functions

* Use of man-roxygen and `@template` to reduce `roxygen2` docs duplication

* Tests with `vcr`

* Removal of the `openair` vignette

# ropenaq 0.2.7

* Have the right function names in error messages about cities and countries, see issue #38 by Birgit Fullerton

* Removes the unneeded ggmap dependency.

* Stops trying to unnest attribution when it is returned by aq_measurements().

# ropenaq 0.2.6

* Takes into account the fact that the Status API can be unavailable.

# ropenaq 0.2.5

* Changes the code for the calendar plot in the openair vignette: with only 90 days data, before February the calendar plot has to be made for the previous year.

# ropenaq 0.2.4

* Updates documentation regarding data availability (90 days worth of data via the API).

# ropenaq 0.2.3

* Does no longer return an error if the API health status is unknown.

# ropenaq 0.2.3

* Adds waiting and messaging when too many requests.

# ropenaq 0.2.2

* Fixes bug due to new output of the latest endpoint.

# ropenaq 0.2.1

* Skips some tests on CRAN since the API health can influence the results.

* Changes the footer link in the vignette.

# ropenaq 0.2.0

* Increases version number at last (because of change to crul).

* Fixes an encoding, see #31

# ropenaq 0.1.4

* The httr dependency has been replaced with crul.

* Now if not giving a value to limit all pages corresponding to a query are automatically retrieved, using async requests.

* Better use of the status page.

* Thanks to Mikayla Murphy `ropenaq` functions now use the new maximal limit per call which is 10,000.

# ropenaq 0.1.3

* Now all functions outputs a single data.frame with meta and timestamp as attributes. It should be easier to deal with compared to the former format (a list of 3 data.frames).

# ropenaq 0.1.2

* adds `longitude`, `latitude` and `coordinates` arguments to `aq_latest`, `aq_locations` and `aq_measurements`.

* adds `attribution`, `source_name` and `averaging_period` arguments to `aq_measurements`.

# ropenaq 0.1.1

* Fixes a bug in `aq_measurements`, now outputs the right local time and not the UTC time for locations behind UTC time.

# ropenaq 0.1

* Added a `NEWS.md` file to track changes to the package.



