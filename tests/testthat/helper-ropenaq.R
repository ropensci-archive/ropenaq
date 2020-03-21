library("vcr")
invisible(vcr::vcr_configure(
  dir = "../../inst/fixtures",
  preserve_exact_body_bytes = TRUE
))
