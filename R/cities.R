#' Providing a simple listing of cities within the platform.
#'
#' @importFrom dplyr tbl_df "%>%"
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#' @param country Limit results by a certain country -- a two-letters codem see countries() for finding code based on name.
#'
#' @return a data.frame (dplyr "tbl_df") with 5 columns:
#' city name ("city"), country code ("country"),
#'  number of measures in total for the city ("count"),
#' number of locations ("locations"),
#' and also an URL encoded string for the city ("cityURL") which can be useful for
#' queries involving a city argument.
#' @details Please note that if an argument is composed by several words,
#' e.g. 'RK Puram' as a location, it has to be written 'RK+Puram' as in a URL.
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
    citiesTable <- dplyr::tbl_df(getResults(urlAQ,
                                            argsList))
    citiesTable <- addCityURL(citiesTable)

    ####################################################
    # DONE!
    return(citiesTable)
}
