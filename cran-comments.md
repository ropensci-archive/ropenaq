## Test environments
* local Ubuntu install, R 3.6
* Windows, macOS, Ubuntu with GitHub Actions
* Winbuilder R devel
* R-hub windows-x86_64-devel (r-devel)
* R-hub ubuntu-gcc-release (r-release)
* R-hub fedora-clang-devel (r-devel)

## R CMD check results

0 errors | 0 warnings | 0 note

## Release summary

* Skip a vcr-enabled test on CRAN because of a (known, under investigation) vcr problem with encoding. https://github.com/ropensci/vcr/issues/158

* Actually fixes the bug due to the max value of page, not only in the docs this time.

## Reverse dependencies

The `rnoaa` vignette using `ropenaq` can still be built.

---


