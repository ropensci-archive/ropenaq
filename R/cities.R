.aq_cities <- function(country = NULL, limit = 100,
                      page = 1) {# nolint
  ####################################################
  # BUILD QUERY
  urlAQ <- paste0(base_url(), "cities")
  argsList <- buildQuery(country = country,
                         limit = limit,
                         page = page)

  ####################################################
  # GET AND TRANSFORM RESULTS
  citiesTable <- getResults(urlAQ, argsList)
  # if no results
  if (nrow(citiesTable) == 0){
    warning("No results for this query, returning an empty table.")
    return(citiesTable)
  }
  citiesTable <- addCityURL(citiesTable)

  ####################################################
  # DONE!
  return(tbl_df(citiesTable))
}


#' Providing a simple listing of cities within the platform.
#'
#' @importFrom lazyeval interp
#' @importFrom dplyr mutate_ select_ "%>%" tbl_df
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#' @importFrom memoise memoise timeout
#' @param country Limit results by a certain country -- a two-letters code see countries() for finding code based on name.
#' @param limit Change the number of results returned, max is 1000.
#' @param page The page of the results to query. This can be useful if e.g. there are 2000 measurements, then first use page=1 and page=2 with limit=100 to get all measurements for your query.

#'
#' @return a data.frame (dplyr "tbl_df") with 5 columns:
#' \itemize{
#' \item city name ("city"), country code ("country"),
#' \item number of measures in total for the city ("count"),
#' \item number of locations ("locations"),
#' \item and also an URL encoded string for the city ("cityURL") which can be useful for
#' queries involving a city argument.
#' }
#' @details For queries involving a city argument,
#' the URL-encoded name of the city (as in cityURL),
#' not its name, should be used.
#' @export
#'
#' @examples
#' aq_cities(country='IN')
aq_cities <- memoise::memoise(.aq_cities, ~ timeout(360))
