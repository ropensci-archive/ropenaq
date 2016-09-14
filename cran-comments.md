## Test environments
* local x86_64-w64-mingw32/x64 install, R 3.3.1
* Ubuntu 12.04 (on Travis CI), R devel, release and oldrel
* Windows on Appveyor CI (stable, patched, oldrel and devel)

## R CMD check results

0 errors | 0 warnings | 0 note

## Release summary

A few improvements

* Now all functions outputs a single data.frame with meta and timestamp as attributes. It should be easier to deal with compared to the former format (a list of 3 data.frames).

* adds `longitude`, `latitude` and `coordinates` arguments to `aq_latest`, `aq_locations` and `aq_measurements`.

* adds `attribution`, `source_name` and `averaging_period` arguments to `aq_measurements`.

## check results

All had "OK" status for the previous release.

## Reverse dependencies

There are no reverse dependencies.

---


