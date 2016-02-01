#' Provides the latest value of each available parameter for every location in the system.
#'
#' @importFrom httr GET content
#' @importFrom dplyr tbl_df mutate filter "%>%"
#' @importFrom tidyr unnest
#' @importFrom lubridate ymd_hms
#' @param country Limit results by a certain country -- a two-letters codem see countries() for finding code based on name.
#' @param city Limit results by a certain city.
#' @param location Limit results by a certain location.
#' @param parameter  Limit to only a certain parameter (valid values are 'pm25', 'pm10', 'so2', 'no2', 'o3', 'co' and 'bc').
#' If no parameter is given, all parameters are retrieved.
#' @param has_geo has_geo Filter out items that have or do not have geographic information.
#' @param value_from Show results above value threshold, useful in combination with \code{parameter}.
#' @param value_to Show results below value threshold, useful in combination with \code{parameter}.
#' @details Please note that if an argument is composed by several words, e.g. 'RK Puram' as a location, it has to be written 'RK+Puram' as in a URL.
#'  You can query any combination of country/location/city, but only one of them at the same time.
#'   If you write inconsistent combination such as city="Paris" and country="IN", an error message will be returned.
#' @examples
#' \dontrun{
#' latest(country='IN', city='Chennai')
#' latest(parameter='co')
#' }
#' @return a data.frame (dplyr "tbl_df") with location, city, country, parameter, value, the last time at which this value was updated, unit, latitude and longitude (NA when non available).
#' @export
#'
latest <- function(country = NULL, city = NULL, location = NULL,
                   parameter = NULL, has_geo = NULL,
                   value_from = NULL, value_to = NULL) {

    ####################################################
    # BUILD QUERY base URL
    urlAQ <- paste0(base_url(), "latest")

    argsList <- buildQuery(country = country, city = city,
                           location = location,
                           parameter = parameter,
                           has_geo = has_geo,
                           value_from = value_from,
                           value_to = value_to)

    ####################################################
    # GET AND TRANSFORM RESULTS
    tableOfResults <- getResults(urlAQ, argsList)
    tableOfResults <- addGeo(tableOfResults)
    tableOfResults <- tidyr::unnest_(tableOfResults,
                                     "measurements")
    tableOfResults <- addCityURL(tableOfResults)
    tableOfResults <- addLocationURL(tableOfResults)
    tableOfResults <- dplyr::mutate(tableOfResults,
                                    lastUpdated =
                                      lubridate::ymd_hms(
                                        lastUpdated))
    tableOfResults <- dplyr::tbl_df(tableOfResults)

    return(tableOfResults)
}
