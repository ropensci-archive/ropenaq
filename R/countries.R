#' Provides a simple listing of countries within the platform.
#'
#' @param limit Change the number of results returned, max is 1000.
#' @param page The page of the results to query. This can be useful if e.g. there are 2000 measurements, then first use page=1 and page=2 with limit=100 to get all measurements for your query.

#' @importFrom httr GET content
#' @return  A results data.frame (dplyr "tbl_df") with 3 columns:
#' \itemize{
#' \item the number of measures for a country ("count"),
#' \item the ISO 3166-1 alpha-2 code of the country ("code"),
#' \item and its name ("name").
#' }
#' and 2 attributes, a meta data.frame (dplyr "tbl_df") with 1 line and 5 columns:
#' \itemize{
#' \item the API name ("name"),
#' \item the license of the data ("license"),
#' \item the website url ("website"),
#' \item the queried page ("page"),
#' \item the limit on the number of results ("limit"),
#' \item the number of results found on the platform for the query ("found")
#' }
#' and a timestamp data.frame (dplyr "tbl_df") with the query time and the last time at which the data was modified on the platform.
#' @details For queries involving a country argument,
#' the code of the country, not its name, should be used.
#' @export
#'
#' @examples
#' countries <- aq_countries()
#' countries
#' attr(countries, "meta")
#' attr(countries, "timestamp")
aq_countries <- function(limit = 100,
                         page = 1) {# nolint
  ####################################################
  # BUILD QUERY base URL
  urlAQ <- paste0(base_url(), "countries?")

  argsList <- buildQuery(limit = limit,
                         page = page)

  ####################################################
  # GET AND TRANSFORM RESULTS
  getResults(urlAQ, argsList)

}


