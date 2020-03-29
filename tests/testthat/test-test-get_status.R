test_that("get_status works as expected", {

  # when all is well
  use_cassette("status", {
    output <- get_status()
  })

  expect_equal(get_status(), "green")

  # when not all is well
  webmockr::enable()
  stub <- webmockr::stub_request("get", status_url())
  webmockr::to_raise(stub, fauxpas::HTTPTooManyRequests)
  expect_equal(get_status(), "red")
  webmockr::disable()
})

