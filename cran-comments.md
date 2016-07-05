## Test environments
* local OS X install, R 3.3.1
* ubuntu 12.04 (on travis-ci), R devel, release and oldrel
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 note

## Re-submission

I am re-submitting very rapidly after the first submission because of a bug I have corrected in the `aq_measurements` function.

The package used to output UTC time instead of local time for locations behind UTC time (US for instance) which I had not noticed previously.

I have now corrected the bug.

## Reverse dependencies

There are no reverse dependencies.

---


