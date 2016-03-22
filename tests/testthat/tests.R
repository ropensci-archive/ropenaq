#################################################################################################
if (requireNamespace("lintr", quietly = TRUE)) {
  context("lints")
  test_that("Package Style", {
    skip_on_appveyor()
    skip_on_travis()
    lintr::expect_lint_free()
  })
}
