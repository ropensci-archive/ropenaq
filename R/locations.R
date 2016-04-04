#' Providing data about distinct measurement locations.
#'
#' @importFrom lubridate ymd ymd_hms
#' @importFrom httr GET content
#' @importFrom dplyr  "%>%" tbl_df rename_
#'
#' @param country Limit results by a certain country -- a two-letters code see countries() for finding code based on name.
#' @param city Limit results by a certain city.
#' @param location Limit results by a certain location.
#' @param parameter Limit to only a certain parameter (valid values are 'pm25', 'pm10', 'so2', 'no2', 'o3', 'co' and 'bc').
#' If no parameter is given, all parameters are retrieved.
#' @param has_geo Filter out items that have or do not have geographic information.
#' @param limit Change the number of results returned, max is 1000.
#' @param page The page of the results to query. This can be useful if e.g. there are 2000 measurements, then first use page=1 and page=2 with limit=100 to get all measurements for your query.

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
#' aq_locations(country='IN')
#' aq_locations(city='Houston', parameter='co')
aq_locations <- function(country = NULL, city = NULL, location = NULL,# nolint
                      parameter = NULL, has_geo = NULL, limit = 100,
                      page = 1) {

    ####################################################
    # BUILD QUERY base URL
    urlAQ <- paste0(base_url(), "locations")

    argsList <- buildQuery(country = country, city = city,
                           location = location,
                           parameter = parameter,
                           has_geo = has_geo,
                           limit = limit,
                           page = page)

    ####################################################
    # GET AND TRANSFORM RESULTS
    locationsTable <- getResults(urlAQ, argsList)
    # if no results
    if (nrow(locationsTable) == 0){
      warning("No results for this query, returning an empty table.")
      return(locationsTable)
    }


    locationsTable <- functionParameters(resTable =
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

    names(locationsTable) <- gsub("coordinates\\.",
                                  "",
                                  names(locationsTable))

    ####################################################
    # DONE!
    return(locationsTable)

}
