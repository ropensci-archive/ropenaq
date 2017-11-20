## Test environments
* local x86_64-w64-mingw32/x64 install, R 3.3.1
* Ubuntu 12.04 (on Travis CI), R devel, release and oldrel
* Windows on Appveyor CI (stable, patched)

## R CMD check results

0 errors | 0 warnings | 0 note

## Release summary

* Tests less strictly for the API health status.

* Now waits if the API tells so.

* The documentation has been updated regarding data availability.

## Reverse dependencies

The `rnoaa` vignette using `ropenaq` can still be built.

---


