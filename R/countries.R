#' Providing a simple listing of countries within the platform.
#'
#' @importFrom dplyr tbl_df "%>%"
#' @importFrom httr GET content
#' @return data.frame (dplyr "tbl_df") with code and name for each country,
#' as well as the number of sources in each country.
#' @export
#'
#' @examples
#' countries()
countries <- function() {
  ####################################################
  # BUILD QUERY base URL
  urlAQ <- paste0(base_url(), "countries?")

  argsList <- buildQuery()

  ####################################################
  # GET AND TRANSFORM RESULTS
  countriesTable <- getResults(urlAQ, argsList)
  countriesTable <- dplyr::tbl_df(countriesTable)
    return(countriesTable)
}
