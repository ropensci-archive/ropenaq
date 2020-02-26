#' Provides a simple listing of cities within the platform.
#'
#' @importFrom rlang .data
#' @importFrom magrittr "%>%"
#' @importFrom jsonlite fromJSON
#' @template country
#' @template limit
#' @template page

#'
#' @return  A results data.frame (dplyr "tbl_df") with 5 columns:
#' \itemize{
#' \item city name ("city"), country code ("country"),
#' \item number of measures in total for the city ("count"),
#' \item number of locations ("locations"),
#' \item and also an URL encoded string for the city ("cityURL") which can be useful for
#' queries involving a city argument.
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
#' @details For queries involving a city argument,
#' the URL-encoded name of the city (as in cityURL),
#' not its name, should be used.
#' @export
#'
#' @examples
#' \dontrun{
#' cities <- aq_cities(country = "BA")
#' cities
#' }
aq_cities <- function(country = NULL, limit = 10000,
                       page = NULL) {# nolint
  ####################################################
  # BUILD QUERY
  urlAQ <- paste0(base_url(), "cities")
  argsList <- buildQuery(country = country,
                         limit = limit,
                         page = page)

  ####################################################
  # GET AND TRANSFORM RESULTS
  output <- getResults(urlAQ, argsList)

  citiesTable <- addCityURL(output)

  ####################################################
  # DONE!
  attr(citiesTable, "meta") <- attr(output, "meta")
  attr(citiesTable, "timestamp") <- attr(output, "timestamp")

  return(citiesTable)
}

