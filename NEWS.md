# ropenaq 0.2.0

* The httr dependency has been replaced with crul.

* Now if not giving a value to limit all pages corresponding to a query are automatically retrieved, using async requests.

# ropenaq 0.1.4

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



