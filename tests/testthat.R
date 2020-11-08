library(testthat)
library(ropenaq)

Sys.setenv("VCR_TURN_OFF" = FALSE)
test_check("ropenaq")
