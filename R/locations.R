#' Providing data about distinct measurement locations.
#'
#' @importFrom lubridate ymd ymd_hms
#' @importFrom httr GET content
#'
#' @param country Limit results by a certain country -- a two-letters codem see countries() for finding code based on name.
#' @param city Limit results by a certain city.
#' @param location Limit results by a certain location.
#' @param parameter Limit to only a certain parameter (valid values are 'pm25', 'pm10', 'so2', 'no2', 'o3', 'co' and 'bc').
#' If no parameter is given, all parameters are retrieved.
#' @param has_geo Filter out items that have or do not have geographic information.
#' @param value_from Show results above value threshold, useful in combination with \code{parameter}.
#' @param value_to Show results below value threshold, useful in combination with \code{parameter}.
#' @param date_from Show results after a certain date. (character year-month-day, ex. '2015-12-20').
#' @param date_to Show results before a certain date. (character year-month-day, ex. '2015-12-20')
#'
#' @return A data.frame (dplyr "tbl_df") with 12 columns:
#'  \itemize{
#'  \item the name of the location ("location"),
#'  \item the city it is in ("city"),
#'  \item the code of country it is in ("country"),
#'  \item the name of the source of the information ("sourceName"),
#'  \item the number of measures for this location in the platform ("count"),
#'  \item the last time and date at which measures were updated for this location ("lastUpdated"),
#'  \item the first time and date at which measures were updated for this location ("firstUpdated"),
#'  \item the parameters available for this location ("parameters"),
#'  \item its longitude ("longitude") and latitude if available ("latitude"),
#'  \item and finally an URL encoded version of the city name ("cityURL")
#'  \item and of the location name ("locationURL").
#'  }
#' @details For queries involving a city or location argument,
#' the URL-encoded name of the city/location (as in cityURL/locationURL),
#' not its name, should be used.
#'  You can query any nested combination of country/location/city (level 1, 2 and 3),
#'  with only one value for each argument.
#'   If you write inconsistent combination such as city="Paris" and country="IN", an error message will be returned.
#'   If you write city="Delhi", you do not need to write the code of the country, unless
#'   one day there is a city with the same name in another country.
#' @export
#'
#' @examples
#' locations(country='IN')
#' locations(city='Houston', parameter='co')
locations <- function(country = NULL, city = NULL, location = NULL,
                      parameter = NULL, has_geo = NULL, value_from = NULL,
                      value_to = NULL, date_from = NULL, date_to = NULL) {

    ####################################################
    # BUILD QUERY base URL
    urlAQ <- paste0(base_url(), "locations")

    argsList <- buildQuery(country = country, city = city,
                           location = location,
                           parameter = parameter,
                           has_geo = has_geo,
                           value_from = value_from,
                           value_to = value_to,
                           date_from = date_from,
                           date_to = date_to)

    ####################################################
    # GET AND TRANSFORM RESULTS
    locationsTable <- getResults(urlAQ, argsList)

    locationsTable <- addGeo(resTable =
                               locationsTable)

    locationsTable <- addCityURL(resTable =
                                   locationsTable)
    locationsTable <- addLocationURL(resTable =
                                       locationsTable)


    locationsTable <- functionTime(resTable =
                                     locationsTable,
                                   "firstUpdated")
    locationsTable <- functionTime(resTable = locationsTable,
                                   "lastUpdated")

    locationsTable <- functionParameters(resTable =
                                           locationsTable)
    ####################################################
    # DONE!
    return(locationsTable)

}
