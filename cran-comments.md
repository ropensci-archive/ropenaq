## Test environments
* local Ubuntu install, R 3.4.4
* Windows on Appveyor CI (stable, patched)
* rhub::check_for_cran()

## R CMD check results

0 errors | 0 warnings | 0 note

## Release summary

* This is a bug fix in aq_measurements() when returning the attribution column.

* Removes unneeded ggmap dependency.

## Reverse dependencies

The `rnoaa` vignette using `ropenaq` can still be built.

---


