#' Providing a simple listing of countries within the platform.
#'
#' @importFrom httr GET content
#' @return data.frame (dplyr "tbl_df") with 3 columns:
#' \itemize{
#' \item the number of measures for a country ("count"),
#' \item the code of the country ("code"),
#' \item and its name ("name").
#' }
#' @details For queries involving a country argument,
#' the code of the country, not its name, should be used.
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
    return(countriesTable)
}
