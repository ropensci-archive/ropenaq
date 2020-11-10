This is release to fix a failing CRAN check, sorry.

## Test environments
* local Ubuntu install, R 4.0.2
* Windows, macOS, Ubuntu with GitHub Actions
* Winbuilder R devel
* R-hub windows-x86_64-devel (r-devel)
* R-hub ubuntu-gcc-release (r-release)
* R-hub fedora-clang-devel (r-devel)

## R CMD check results

0 errors | 0 warnings | 0 note

## Release summary

* Use vcr for all tests calling the API on CRAN.

* Changes docs around data availability since one can now download data from January 1, 2018.

## Reverse dependencies

The `rnoaa` vignette using `ropenaq` is fine.

---


