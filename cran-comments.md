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

* Bug fixes (page has now a maximum argument; no longer passing an empty param in the query)

* Replacement of `tidyr` and `dplyr` deprecated functions

* Use of man-roxygen and `@template` to reduce `roxygen2` docs duplication

* Tests with `vcr`

* Removal of the `openair` vignette

## Reverse dependencies

The `rnoaa` vignette using `ropenaq` can still be built.

---


