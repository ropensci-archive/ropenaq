#' Provides the latest value of each available parameter for every location in the system.
#'
#' @importFrom httr GET content
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
#' @details For queries involving a city or location argument,
#' the URL-encoded name of the city/location (as in cityURL/locationURL),
#' not its name, should be used.
#'  You can query any nested combination of country/location/city (level 1, 2 and 3),
#'  with only one value for each argument.
#'   If you write inconsistent combination such as city="Paris" and country="IN", an error message will be returned.
#'   If you write city="Delhi", you do not need to write the code of the country, unless
#'   one day there is a city with the same name in another country.
#' @examples
#' \dontrun{
#' latest(country='IN', city='Chennai')
#' latest(parameter='co')
#' }
#' @return a data.frame (dplyr "tbl_df") with 11 columns:
#' \itemize{
#'  \item the name of the location ("location"),
#'  \item the city it is in ("city"),
#'  \item the code of country it is in ("country"),
#'  \item its longitude ("longitude") and latitude if available ("latitude"),
#'  \item the parameter ("parameter")
#'  \item the value of the measurement ("value")
#'  \item the last time and date at which the value was updated ("lastUpdated"),
#'  \item the unit of the measure ("unit")
#'  \item and finally an URL encoded version of the city name ("cityURL")
#'  \item and of the location name ("locationURL").

#' }.
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
    tableOfResults <- functionTime(tableOfResults,
                                   "lastUpdated")

    return(tableOfResults)
}
