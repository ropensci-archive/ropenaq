## Test environments
* local x86_64-w64-mingw32/x64 install, R 3.3.1
* Ubuntu 12.04 (on Travis CI), R devel, release and oldrel
* Windows on Appveyor CI (stable, patched and devel)

## R CMD check results

0 errors | 0 warnings | 0 note

## Release summary

* Adds async http requests, making the functions easier to use. For that, replaces the `httr` dependency with `crul`.

* Uses the status page of the API better. If the API status is not green, but orange, several calls are tried with increasing waiting time. If the status a red, an informative error message is returned.

* The package now uses the most recent limit for each API call.

## check results

An example failed and created an error. Now this error cannot happen any more because the output is parsed better.

## Reverse dependencies

The `rnoaa` vignette using `ropenaq` can still be built.

---


