#' Function for getting measurements table from the openAQ API
#'
#' @importFrom dplyr tbl_df select_
#' @importFrom lubridate ymd ymd_hms
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content
#' @param country Limit results by a certain country -- a two-letters codem see countries() for finding code based on name.
#' @param city Limit results by a certain city.
#' @param location Limit results by a certain location.
#' @param parameter Limit to only a certain parameter (valid values are 'pm25', 'pm10', 'so2', 'no2', 'o3', 'co' and 'bc').
#' If no parameter is given, all parameters are retrieved.
#' @param value_from Show results above value threshold, useful in combination with \code{parameter}.
#' @param value_to Show results below value threshold, useful in combination with \code{parameter}.
#' @param has_geo Filter out items that have or do not have geographic information.
#' @param date_from Show results after a certain date. (character year-month-day, ex. '2015-12-20')
#' @param date_to Show results before a certain date. (character year-month-day, ex. '2015-12-20')
#' @param limit Change the number of results returned, max is 1000.
#' @param page The page of the results to query. This can be useful if e.g. there are 2000 measurements, then first use page=1 and page=2 with limit=100 to get all measurements for your query.

#'
#' @return a data.frame (dplyr "tbl_df") with 12 columns:
#' \itemize{
#'  \item the name of the location ("location"),
#'  \item the parameter ("parameter")
#'  \item the value of the measurement ("value")
#'  \item the unit of the measure ("unit")
#'  \item the code of country the location is in ("country"),
#'  \item the city it is in ("city"),
#'  \item and finally an URL encoded version of the city name ("cityURL")
#'  \item and of the location name ("locationURL"),
#'  \item the UTC POSIXct time ("dateUTC"),
#'  \item the local POSIXct time ("dateLocal"),
#'  \item its longitude ("longitude") and latitude if available ("latitude").
#' }
#' @details For queries involving a city or location argument,
#' the URL-encoded name of the city/location (as in cityURL/locationURL),
#' not its name, should be used.
#'  You can query any nested combination of country/location/city (level 1, 2 and 3),
#'  with only one value for each argument.
#'   If you write inconsistent combination such as city="Paris" and country="IN", an error message will be returned.
#'   If you write city="Delhi", you do not need to write the code of the country, unless
#'   one day there is a city with the same name in another country.
#'
#' @examples
#' \dontrun{
#' aq_measurements(country='IN', limit=9, city='Chennai')
#' aq_measurements(country='US', has_geo=TRUE)
#' }
#' @export

aq_measurements <- function(country = NULL, city = NULL, location = NULL,# nolint
                         parameter = NULL, has_geo = NULL, date_from = NULL,
                         date_to = NULL, limit = 100, value_from = NULL,
                         value_to = NULL, page = 1) {

    ####################################################
    # BUILD QUERY base URL
    urlAQ <- paste0(base_url(), "measurements")

    argsList <- buildQuery(country = country,
                           city = city,
                           location = location,
                          parameter = parameter,
                          has_geo = has_geo,
                          date_from = date_from,
                          date_to = date_to,
                          value_from = value_from,
                          value_to = value_to,
                          limit = limit,
                          page = page)

    ####################################################
    # GET AND TRANSFORM RESULTS
    tableOfResults <- getResults(urlAQ, argsList)
    # if no results
    if (nrow(tableOfResults) == 0){
      warning("No results for this query, returning an empty table.")
      return(tableOfResults)
    }

    tableOfResults <- addCityURL(resTable = tableOfResults)
    tableOfResults <- addLocationURL(resTable = tableOfResults)
    tableOfResults <- functionTime2(resTable = tableOfResults)

    tableOfResults <- dplyr::select_(tableOfResults,
                                      ~ - date)
    tableOfResults <- addGeo(resTable = tableOfResults)

    ####################################################
    # DONE!
    return(tableOfResults)

}
