#' Function for getting measurements table from the openAQ API
#'
#' @importFrom lubridate ymd ymd_hms
#' @importFrom jsonlite fromJSON
#' @template country
#' @template city
#' @template location
#' @template parameter
#' @param value_from Show results above value threshold, useful in combination with `parameter`.
#' @param value_to Show results below value threshold, useful in combination with `parameter`.
#' @template has_geo
#' @template latitude
#' @template longitude
#' @template radius
#' @param date_from Show results after a certain date. (character year-month-day, ex. '2015-12-20'). Note, since November 2017 the API only provides access to the last three months so if you need more data you need to fetch it via Amazon S3 (https://medium.com/@openaq/changes-to-the-openaq-api-and-how-to-access-the-full-archive-of-data-3324b136da8c), potentially using the aws.s3 package.
#' @param date_to Show results before a certain date. (character year-month-day, ex. '2015-12-20')
#' @param attribution Logical, whether to add a column with attribution information
#' @param averaging_period Logical, whether to add a column with averaging_period information
#' @param source_name Logical, whether to add a column with source_name information
#' @template limit
#' @template page

#'
#' @return A results data.frame (dplyr "tbl_df") with at least 12 columns:
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

#' @details For queries involving a city or location argument,
#' the URL-encoded name of the city/location (as in cityURL/locationURL),
#' not its name, should be used.
#'  You can query any nested combination of country/location/city (level 1, 2 and 3),
#'  with only one value for each argument.
#'   If you write inconsistent combination such as city="Paris" and country="IN", an error message will be returned.
#'   If you write city="Delhi", you do not need to write the code of the country, unless
#'   one day there is a city with the same name in another country.
#'
#'   If you choose to get the attribution in the output, lines might be repeated as there might be several attributions.
#'
#' @examples
#' \dontrun{
#' output <- aq_measurements(country='IN', limit=9, city='Chennai',
#'                           page = 1)
#' output
#' attr(output, "meta")
#' attr(output, "timestamp")
#' }
#' @export

aq_measurements <- function(country = NULL, city = NULL, location = NULL,# nolint
                         parameter = NULL, has_geo = NULL, date_from = NULL,
                         date_to = NULL, limit = 10000, value_from = NULL,
                         latitude = NULL, longitude = NULL, radius = NULL,
                         attribution = FALSE, averaging_period = FALSE,
                         source_name = FALSE,
                         value_to = NULL, page = NULL) {

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
                          latitude = latitude,
                          longitude = longitude,
                          radius = radius,
                          attribution = attribution,
                          averaging_period = averaging_period,
                          source_name = source_name,
                          page = page)

    ####################################################
    # GET AND TRANSFORM RESULTS
    output <- getResults(urlAQ, argsList)
    tableOfResults <- output
    # if no results
    if (nrow(tableOfResults) != 0){

        tableOfResults <- tableOfResults %>%
            addCityURL() %>%
            addLocationURL()

        tableOfResults <- dplyr::mutate(tableOfResults,
            dateUTC = lubridate::ymd_hms(.data$date.utc),
            data.utc = NULL
        )

        if (!is.null(tableOfResults[["date.local"]])) {
            tableOfResults <- dplyr::mutate(tableOfResults,
                dateLocal = lubridate::ymd_hms(
                    strftime(
                        .data$date.local, "%Y-%m-%dT%H:%M:%S")
                    ),
                date.local = NULL
            )
        }

        names(tableOfResults) <- gsub("coordinates\\.", "", names(tableOfResults))
    }
    ####################################################
    # DONE!
    attr(tableOfResults, "meta") <- attr(output, "meta")
    attr(tableOfResults, "timestamp") <- attr(output, "timestamp")

    return(tableOfResults)
}
