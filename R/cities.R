#' Providing a simple listing of cities within the platform.
#'
#' @importFrom dplyr tbl_df
#' @importFrom httr GET content
#' @param country Limit results by a certain country.
#'
#' @return a data.table with locations, count, country, city columns,
#' and also an URL encoded string for the city.
#' @details Please note that if an argument is composed by several words,
#' e.g. 'RK Puram' as a location, it has to be written 'RK+Puram' as in a URL.
#' @export
#'
#' @examples
#' cities(country='IN')
cities <- function(country = NULL) {
    ####################################################
    # BUILD QUERY
    query <- "https://api.openaq.org/v1/cities"
    # country
    if (!is.null(country)) {
        if (!(country %in% countries()$code)) {
            stop("This country is not available within the platform.")
        }
        query <- paste0(query, "?country=", URLencode(country))
    }

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
   else{
        locations <- unlist(lapply(contentPage[[2]],
                                   function(x) x["locations"]))
        count <- unlist(lapply(contentPage[[2]],
                               function(x) x["count"]))
        country <- unlist(lapply(contentPage[[2]],
                                 function(x) x["country"]))
        city <- unlist(lapply(contentPage[[2]],
                              function(x) x["city"]))
        cityURL <- unlist(lapply(city, URLencode,
                                 reserved=TRUE))
        cityURL <- unlist(lapply(cityURL, gsub,
                                 pattern = "\\%20",
                                 replacement = "+"))

        citiesTable <- dplyr::tbl_df(data.frame(locations = locations,
                                                count = count,
                                                country = country,
                                                city = city,
                                                cityURL = cityURL))
        citiesTable <- dplyr::mutate(citiesTable,
                                     cityURL = as.character(cityURL))

        ####################################################
        # DONE!
        return(citiesTable)
    }


}
