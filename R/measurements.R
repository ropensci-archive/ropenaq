#' Function for getting measurements table from the openAQ API
#'
#' @importFrom dplyr tbl_df mutate arrange "%>%"
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

#'
#' @return A data.frame (dplyr "tbl_df") with UTC date and time, local date and time, country, location, city, parameter, unit, measure,
#' and geographical coordinates if they were available (otherwise the columns latitude and longitude are full of NA).
#' @details The sort and sort_by parameters from the API were not included because one can still re-order the table in R.
#' Regarding the number of page, similarly here it does not make any sense to have it.
#' include_fields was not included either.
#' Please note that if an argument is composed by several words, e.g. 'RK Puram' as a location, it has to be written 'RK+Puram' as in a URL.
#'
#' #'
#' @examples
#' \dontrun{
#' measurements(country='IN', limit=9, city='Chennai')
#' measurements(country='US', has_geo=TRUE)
#' }
#' @export

measurements <- function(country = NULL, city = NULL, location = NULL,
                         parameter = NULL, has_geo = NULL, date_from = NULL,
                         date_to = NULL, limit = 100, value_from = NULL,
                         value_to = NULL) {

    ##################################################### BUILD QUERY base URL
    query <- paste0(base_url(), "measurements?page=1")

    # limit
    if (is.null(limit)) {
        limit <- 100
    }
    if (limit > 1000) {
        stop("limit cannot be more than 1000")
    }

    query <- paste0(query, "&limit=", limit)

    query <- buildQuery(country, city, location,
                        parameter, has_geo, date_from,
                        date_to, value_from,
                        value_to, query)

    ####################################################
    # GET AND TRANSFORM RESULTS

    page <- httr::GET(query)

    contentPage <- httr::content(page)
    contentPageText <- httr::content(page, as = "text")

    if (grepl("Gateway time-out", toString(contentPageText))){
            stop("Gateway time-out, but try again in a few minutes.")# nolint
        }  # nocov
    if (length(contentPage[[2]]) == 0){
            stop("No results for this query")
        }  # nocov
 else {
        # Extract all future columns
        value <- unlist(lapply(contentPage[[2]],
                               function(x) x["value"]))
        dateUTC <- unlist(lapply(contentPage[[2]],
                                 function(x) x$date$utc))
        dateLocal <- unlist(lapply(contentPage[[2]],
                                   function(x) x$date$local))
        parameter <- unlist(lapply(contentPage[[2]],
                                   function(x) x["parameter"]))
        location <- unlist(lapply(contentPage[[2]],
                                  function(x) x["location"]))
        locationURL <- unlist(lapply(location, URLencode,
                                     reserved = TRUE))
        locationURL <- unlist(lapply(locationURL, gsub,
                                     pattern = "\\%20", replacement = "+"))
        unit <- unlist(lapply(contentPage[[2]],
                              function(x) x["unit"]))
        city <- unlist(lapply(contentPage[[2]],
                              function(x) x["city"]))
        country <- unlist(lapply(contentPage[[2]],
                                 function(x) x["country"]))

        # create the data.table, transforming dates using lubridate
        tableOfData <- dplyr::tbl_df(data.frame(dateUTC = dateUTC,
                                                dateLocal = dateLocal,
                                                parameter = parameter,
                                                location = location,
                                                locationURL = locationURL,
                                                value = value,
                                                unit = unit,
                                                city = city,
                                                country = country))

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
            latitude <- rep(NA, nrow(tableOfData))
            longitude <- rep(NA, nrow(tableOfData))
        }
        tableOfData <- dplyr::mutate(tableOfData,
                                     latitude = latitude,
                                     longitude = longitude)

        tableOfData <- dplyr::mutate(tableOfData,
                                     locationURL = as.character(locationURL),
                                     dateUTC = lubridate::ymd_hms(dateUTC),
                                     dateLocal =
                                       lubridate::ymd_hms(
                                         substr(dateLocal, 1, 19)))
        tableOfData <- dplyr::arrange(tableOfData, dateUTC)

        ##################################################### DONE!
        return(tableOfData)
    }


}
