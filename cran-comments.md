## Test environments
* local x86_64-w64-mingw32/x64 install, R 3.3.1
* Ubuntu 12.04 (on Travis CI), R devel, release and oldrel
* Windows on Appveyor CI (stable, patched and devel)

## R CMD check results

0 errors | 0 warnings | 0 note

## Release summary

* Fixes a bug in vignette building (invalid link) and skips one test depending on API health.

## Reverse dependencies

The `rnoaa` vignette using `ropenaq` can still be built.

---


