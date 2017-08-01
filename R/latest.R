#' Provides the latest value of each available parameter for every location in the system.
#'
#' @importFrom tidyr unnest
#' @importFrom lubridate ymd_hms
#' @importFrom dplyr bind_rows tbl_df "%>%"
#' @param country Limit results by a certain country -- a two-letters code see countries() for finding code based on name.
#' @param city Limit results by a certain city.
#' @param location Limit results by a certain location.
#' @param parameter  Limit to only a certain parameter (valid values are 'pm25', 'pm10', 'so2', 'no2', 'o3', 'co' and 'bc').
#' If no parameter is given, all parameters are retrieved.
#' @param has_geo has_geo Filter out items that have or do not have geographic information.
#' @param latitude Latitude of the center point (lat, lon) used to get measurements within a certain area.
#' @param longitude Longitude of the center point (lat, lon) used to get measurements within a certain area.
#' @param radius Radius (in meters) used to get measurements within a certain area, must be used with latitude and longitude
#' @param limit Change the number of results returned, max is 10000.
#' @param page The page of the results to query. This can be useful if e.g. there are 2000 measurements, then first use page=1 and page=2 with limit=100 to get all measurements for your query.

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
#' latest_chennai <- aq_latest(country='IN', city='Chennai')
#' latest_chennai
#' attr(latest_chennai, "meta")
#' attr(latest_chennai, "timestamp")
#' aq_latest(parameter='co')
#' }
#' @return  A results data.frame (dplyr "tbl_df") with 11 columns:
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
#' and two attributes, a meta data.frame (dplyr "tbl_df") with 1 line and 5 columns:
#' \itemize{
#' \item the API name ("name"),
#' \item the license of the data ("license"),
#' \item the website url ("website"),
#' \item the queried page ("page"),
#' \item the limit on the number of results ("limit"),
#' \item the number of results found on the platform for the query ("found")
#' }
#' and a timestamp data.frame (dplyr "tbl_df") with the query time and the last time at which the data was modified on the platform.
#' @export
aq_latest <- function(country = NULL, city = NULL, location = NULL,# nolint
                   parameter = NULL, has_geo = NULL, limit = 10000,
                   latitude = NULL, longitude = NULL, radius = NULL,
                   page = NULL) {

    ####################################################
    # BUILD QUERY base URL
    urlAQ <- paste0(base_url(), "latest")

    argsList <- buildQuery(country = country, city = city,
                           location = location,
                           parameter = parameter,
                           has_geo = has_geo,
                           limit = limit,
                           latitude = latitude,
                           longitude = longitude,
                           radius = radius,
                           page = page)

    ####################################################
    # GET AND TRANSFORM RESULTS
    output <- getResults(urlAQ, argsList)
    tableOfResults <- output
    # if no results
    if (nrow(tableOfResults) != 0){
      tableOfResults$row <- 1:nrow(tableOfResults)
      tableOfResults <- split(tableOfResults, tableOfResults$row)
      tableOfResults <- lapply(tableOfResults, denest) %>% dplyr::bind_rows()
      tableOfResults <- dplyr::select_(tableOfResults, quote(- row))
    tableOfResults <- addCityURL(tableOfResults)
    tableOfResults <- addLocationURL(tableOfResults)

    tableOfResults <- functionTime(tableOfResults,
                                   "lastUpdated")

    names(tableOfResults) <- gsub("coordinates\\.", "", names(tableOfResults))

    }
    attr(tableOfResults, "meta") <- attr(output, "meta")
    attr(tableOfResults, "timestamp") <- attr(output, "timestamp")

    return(tableOfResults)
}

unlistaverage <- function(df){
  lapply(df$averagingPeriod, unlist)
}

# since tidyr::unnest doesn't work on the data.frame with two levels of nestedness
denest <- function(df){
  measurements <- df$measurements
  if("averagingPeriod" %in% names(measurements[[1]])){
    average <- lapply(measurements, dplyr::select_, "averagingPeriod")
    measurements <- lapply(measurements, dplyr::select_, quote(- averagingPeriod))
    average <- lapply(average, unlistaverage) %>%
      lapply(as.data.frame) %>%
      dplyr::bind_rows()
   names(average) <- paste0("averagingPeriod_", names(average))

   measurements <- dplyr::bind_cols(measurements, average)
   df <- dplyr::select_(df, quote(- measurements))
   df <- df[rep(1, nrow(measurements)),]
   dplyr::bind_cols(df, measurements)
  }else{
    tidyr::unnest_(df, "measurements")
  }

}
