#' Providing a simple listing of cities within the platform.
#'
#' @importFrom lazyeval interp
#' @importFrom dplyr mutate_ select_ "%>%"
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#' @param country Limit results by a certain country -- a two-letters codem see countries() for finding code based on name.
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
#' cities(country='IN')
cities <- function(country = NULL) {
    ####################################################
    # BUILD QUERY
    urlAQ <- paste0(base_url(), "cities")
    argsList <- buildQuery(country = country)

    ####################################################
    # GET AND TRANSFORM RESULTS
    citiesTable <- getResults(urlAQ, argsList)
    citiesTable <- addCityURL(citiesTable)

    ####################################################
    # DONE!
    return(citiesTable)
}
