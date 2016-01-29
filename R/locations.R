#' Providing data about distinct measurement locations.
#'
#' @importFrom dplyr tbl_df mutate "%>%"
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
#' @return A data.frame (dplyr "tbl_df") with for each location: its name, the city and the country it is in, the number of measures for this location,
#'  the name of the source, and the dates and times at which it was first and last updated, respectively. City and location are
#'  also provided as URL encoded strings which makes further queries easier.
#'  @details Please note that if an argument is composed by several words, e.g. 'RK Puram' as a location, it has to be written 'RK+Puram' as in a URL.
#'  You can query any combination of country/location/city, but only one of them at the same time.
#'   If you write inconsistent combination such as city="Paris" and country="IN", an error message will be returned.
#' @export
#'
#' @examples
#' locations(country='IN')
#' locations(city='Houston', parameter='co')
locations <- function(country = NULL, city = NULL, location = NULL,
                      parameter = NULL, has_geo = NULL, value_from = NULL,
                      value_to = NULL, date_from = NULL, date_to = NULL) {
    ##################################################### BUILD QUERY
    query <- paste0(base_url(), "locations?")

    query <- buildQuery(country = country, city = city,
                        location = location,
                        parameter = parameter, has_geo = has_geo,
                        value_from = value_from,
                        value_to = value_to, date_from = date_from,
                        date_to = date_to,
                        query = query)
    ####################################################
    # GET AND TRANSFORM RESULTS

    page <- httr::GET(query)

    contentPage <- httr::content(page)
    contentPageText <- httr::content(page, as = "text")
    if (grepl("Gateway time-out", toString(contentPageText))){
            stop("Gateway time-out, but try again in a few minutes.")
        }  # nocov
    if (length(contentPage[[2]]) == 0){
            stop("No results for this query")
        }  # nocov
 else {
        location <- unlist(lapply(contentPage[[2]],
                                  function(x) x["location"]))
        locationURL <- unlist(lapply(location, URLencode,
                                     reserved = TRUE))
        locationURL <- unlist(lapply(locationURL, gsub,
                                     pattern = "\\%20", replacement = "+"))

        city <- as.character(unlist(lapply(contentPage[[2]],
                              function(x) x["city"])))
        cityURL <- unlist(lapply(city, URLencode,
                                     reserved = TRUE))
        cityURL <- unlist(lapply(cityURL, gsub,
                                     pattern = "\\%20",
                                 replacement = "+"))

        country <- unlist(lapply(contentPage[[2]],
                                 function(x) x["country"]))
        count <- unlist(lapply(contentPage[[2]],
                               function(x) x["count"]))
        sourceName <- unlist(lapply(contentPage[[2]],
                                    function(x) x["sourceName"]))
        firstUpdated <- unlist(lapply(contentPage[[2]],
                                      function(x) x["firstUpdated"]))
        lastUpdated <- unlist(lapply(contentPage[[2]],
                                     function(x) x["lastUpdated"]))
        parameters <- unlist(lapply(contentPage[[2]],
                                    function(x) toString(
                                      unlist(x["parameters"]))))
        locationsTable <- dplyr::tbl_df(data.frame(location = location,
                                                   locationURL = locationURL,
                                                   city = city,
                                                   cityURL = cityURL,
                                                   country = country,
                                                   count = count,
                                                   sourceName = sourceName,
                                                   firstUpdated = firstUpdated,
                                                   lastUpdated = lastUpdated,
                                                   parameters = parameters)) %>%
            dplyr::mutate(firstUpdated = lubridate::ymd_hms(firstUpdated),
                          lastUpdated = lubridate::ymd_hms(lastUpdated),
                          locationURL = as.character(locationURL),
                          cityURL = as.character(cityURL))

        geoCoordLat <- function(x) {
            if (is.null(x$coordinates$latitude)) {
                return(NA)
            } else (return(x$coordinates$latitude))
        }

        geoCoordLong <- function(x) {
            if (is.null(x$coordinates$longitude)) {
                return(NA)
            } else (return(x$coordinates$longitude))
        }

        if (!is.null(unlist(lapply(contentPage[[2]],
                                   function(x) x$coordinates$latitude)))) {
          latitude <- unlist(lapply(contentPage[[2]], geoCoordLat))
          longitude <- unlist(lapply(contentPage[[2]], geoCoordLong))

        } else {
          latitude <- rep(NA, nrow(locationsTable))
          longitude <- rep(NA, nrow(locationsTable))
        }
        locationsTable <- dplyr::mutate(locationsTable,
                                     latitude = latitude,
                                     longitude = longitude)

        ##################################################### DONE!
        return(locationsTable)
    }
}
