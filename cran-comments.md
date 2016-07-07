## Test environments
* local OS X install, R 3.3.1
* ubuntu 12.04 (on travis-ci), R devel, release and oldrel
* win-builder (devel, patched and release)

## R CMD check results

0 errors | 0 warnings | 0 note

## Update

I am updating very rapidly after the first submission because of a moderately serious bug I have corrected in the `aq_measurements` function:

The package used to output UTC time instead of local time for locations behind UTC time (US for instance) which I had not noticed previously: the package was tested a lot but locations ahead of UTC time.

I have now corrected the bug. Currently users could guess local time from UTC time and geographical coordinates but it is not optimal.

## check results

12 of them are there with "OK" status.

## Reverse dependencies

There are no reverse dependencies.

---


