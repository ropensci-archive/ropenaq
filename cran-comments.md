This is a patch release to fix a failing CRAN check and a missed bug, sorry.

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

* Fix code using dplyr (@hadley, #57)

* Fix tests that used class() == .

## Reverse dependencies

The `rnoaa` vignette using `ropenaq` has cached results. Changes in OpenAQ web API itself would break it, I notified the maintainer.

---


