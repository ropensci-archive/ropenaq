#' Providing a simple listing of countries within the platform.
#'
#' @param limit Change the number of results returned, max is 1000.
#' @param page The page of the results to query. This can be useful if e.g. there are 2000 measurements, then first use page=1 and page=2 with limit=100 to get all measurements for your query.

#' @importFrom httr GET content
#' @return data.frame (dplyr "tbl_df") with 3 columns:
#' \itemize{
#' \item the number of measures for a country ("count"),
#' \item the ISO 3166-1 alpha-2 code of the country ("code"),
#' \item and its name ("name").
#' }
#' @details For queries involving a country argument,
#' the code of the country, not its name, should be used.
#' @export
#'
#' @examples
#' aq_countries()
aq_countries <- function(limit = 100,
                         page = 1) {# nolint
  ####################################################
  # BUILD QUERY base URL
  urlAQ <- paste0(base_url(), "countries?")

  argsList <- buildQuery(limit = limit,
                         page = page)

  ####################################################
  # GET AND TRANSFORM RESULTS
  countriesTable <- getResults(urlAQ, argsList)
    return(countriesTable)
}
