test_that("error handling", {
  webmockr::enable()
  stub <- webmockr::stub_request("get", paste0(ropenaq:::base_url(), "latest"))
  webmockr::to_raise(stub, fauxpas::HTTPTooManyRequests)

    expect_message(
      output <- aq_latest(),
      "Too many requests")
    print(output)
      expect_null(output)

  webmockr::disable()
})
