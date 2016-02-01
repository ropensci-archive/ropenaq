
######################################################################################
# base URL for all queries
base_url <- function() {
  "https://api.openaq.org/v1/"
}

######################################################################################
# checks arguments
# and if no error returns their list
buildQuery <- function(country = NULL, city = NULL, location = NULL,
                       parameter = NULL, has_geo = NULL, date_from = NULL,
                       date_to = NULL, value_from = NULL,
                       value_to = NULL, limit = NULL){
  # limit
  if (!is.null(limit)) {
    if (limit > 1000) {
      stop("limit cannot be more than 1000")
    }
  }


  # country
  if (!is.null(country)) {
    if (!(country %in% aq_countries()$code)) {# nolint
      stop("This country is not available within the platform. See ?countries")
    }
  }

  # city
  if (!is.null(city)) {
    if (!is.null(country)) {
      if (!(city %in% aq_cities(country = country)$cityURL)) {# nolint
        stop("This city is not available within the platform for this country. See ?cities.")# nolint
      }
    } else {
      if (!(city %in% aq_cities()$cityURL)) {# nolint
        stop("This city is not available within the platform. See ?cities")
      }
    }
    # make sure it won't be re-encoded by httr
    Encoding(city) <- "UTF-8"
    class(city) <- c("character", "AsIs")
  }

  # location
  if (!is.null(location)) {
    if (!is.null(country)) {
      if (!is.null(city)) {
        if (!(location %in%
              aq_locations(country = country, city = city)$locationURL)) {# nolint
          stop("This location is not available within the platform for this country and this city. See ?locations")# nolint
        }
      } else {
        if (!(location %in%
              aq_locations(country = country)$locationURL)) {# nolint
          stop("This location is not available within the platform for this country. See ?locations")# nolint
        }
      }
    }
    else {
      if (!is.null(city)) {
        if (!(location %in%
              aq_locations(city = city)$locationURL)) {# nolint
          stop("This location is not available within the platform for this city. See ?locations")# nolint
        }
      }
      else {
        if (!(location %in% aq_locations()$locationURL)) {# nolint
          stop("This location is not available within the platform. See ?locations")# nolint
        }
      }
    }
    # make sure it won't be re-encoded by httr
    Encoding(location) <- "UTF-8"
    class(location) <- c("character", "AsIs")
  }

  # parameter
  if (!is.null(parameter)) {
    if (!(parameter %in% c("pm25", "pm10", "so2",
                           "no2", "o3", "co", "bc"))) {
      stop("You asked for an invalid parameter: see list of valid parameters in the Arguments section of the function help")# nolint
    }


    locationsTable <- aq_locations(country = country,# nolint
                                city = city,
                                location = location)
    if (sum(grepl(parameter, locationsTable$parameters)) == 0) {
      stop("This parameter is not available for any location corresponding to your query. See ?locations")# nolint
    }
  }

  # has_geo
  if (!is.null(has_geo)) {
    if (has_geo == TRUE) {
      has_geo <- "1"
    }
    if (has_geo == FALSE) {
      has_geo <- "false"
    }

  }

  # date_from
  if (!is.null(date_from)) {
    if (is.na(lubridate::ymd(date_from))) {
      stop("date_from and date_to have to be inputed as year-month-day")
    }
  }
  # date_to
  if (!is.null(date_to)) {
    if (is.na(lubridate::ymd(date_to))) {
      stop("date_from and date_to have to be inputed as year-month-day")
    }
  }

  # check dates
  if (!is.null(date_from) & !is.null(date_to)) {
    if (ymd(date_from) > ymd(date_to)) {
      stop("The start date must be smaller than the end date.")
    }

  }

  # value_from
  if (!is.null(value_from)) {
    if (value_from < 0) {
      stop("No negative value for value_from please!")
    }
  }

  # value_to
  if (!is.null(value_to)) {
    if (value_to < 0) {
      stop("No negative value for value_to please!")
    }
  }

  # check values
  if (!is.null(value_from) & !is.null(value_to)) {
    if (value_to < value_from) {
      stop("The max value must be bigger than the min value.")
    }

  }

  argsList <- list(country = country,
                   city = city,
                   location = location,
                   parameter = parameter,
                   has_geo = has_geo,
                   date_from = date_from,
                   date_to = date_to,
                   value_from = value_from,
                   value_to = value_to,
                   limit = limit)

  return(argsList)
}
######################################################################################
# does the query and then parses it
getResults <- function(urlAQ, argsList){
  page <- httr::GET(url = urlAQ,
                    query = argsList)

  # convert the http error to a R error
  httr::stop_for_status(page)
  contentPage <- httr::content(page, as = "text")

  # parse the data
  resTable <- jsonlite::fromJSON(contentPage)$results
  resTable <- dplyr::tbl_df(resTable)
  return(resTable)
}

######################################################################################
# for getting URL encoded versions of city and locations
functionURL <- function(resTable, col1, newColName) {
  mutateCall <- lazyeval::interp( ~ gsub(sapply(a, URLencode,
                                                reserved = TRUE),
                                         pattern = "\\%20",
                                         replacement = "+"),
                                  a = as.name(col1))

  resTable %>% dplyr::mutate_(.dots = setNames(list(mutateCall),
                                               newColName))
}

# encoding city name
addCityURL <- function(resTable){
  resTable <- functionURL(resTable,
                col1 = "city",
                newColName = "cityURL")

  return(resTable)
}

# encoding location name
addLocationURL <- function(resTable){
  resTable <- functionURL(resTable,
                          col1 = "location",
                          newColName = "locationURL")
  return(resTable)
}
######################################################################################
# here I get coordinates
# when there are some
functionGeo <- function(resTable, newColName) {
  mutateCall <- lazyeval::interp( ~ a$newColName,
                                   a = as.name("coordinates"))
  resTable %>% dplyr::mutate_(.dots = setNames(list(mutateCall),
                                               newColName))
}
# where there are not any
functionNotGeo <- function(resTable, newColName) {
  mutateCall <- lazyeval::interp( ~ NA)
  resTable %>% dplyr::mutate_(.dots = setNames(list(mutateCall),
                                               newColName))
}
# transform the table,
# adding latitude and longitude columns
addGeo <- function(resTable){
  if ("coordinates" %in% names(resTable)){
    resTable <- functionGeo(resTable, "longitude")
    resTable <- functionGeo(resTable, "latitude")
    resTable <- dplyr::select_( resTable,
                                quote(- coordinates))
  }
  else{
    resTable <- functionNotGeo(resTable, "latitude")
    resTable <- functionNotGeo(resTable, "longitude")
  }
  return(resTable)
}
######################################################################################
# transform a given column in POSIXct
functionTime <- function(resTable, newColName) {
  mutateCall <- lazyeval::interp( ~ lubridate::ymd_hms(a),
                                   a = as.name(newColName))

  resTable %>% dplyr::mutate_(.dots = setNames(list(mutateCall),
                                               newColName))
}

# transform the date column
# in two distinct POSIXct columns
functionTime2 <- function(resTable) {
  mutateCall1 <- lazyeval::interp( ~ lubridate::ymd_hms(a[, "utc"]),
                                   a = as.name("date"))
  mutateCall2 <- lazyeval::interp( ~ lubridate::ymd_hms(a[, "local"]),
                                   a = as.name("date"))
  resTable %>% dplyr::mutate_(.dots = setNames(list(mutateCall1),
                                               "dateUTC")) %>%
    dplyr::mutate_(.dots = setNames(list(mutateCall2),
                                    "dateLocal"))
}
######################################################################################
# create the parameters column
functionParameters <- function(resTable) {
  mutateCall <- lazyeval::interp( ~ lapply(a, toString),
                                  a = as.name("parameters")) %>%
    lazyeval::interp( ~ gsub(.dot, pattern = "\"", sub = "")) %>%
    lazyeval::interp( ~ gsub(.dot, pattern = "\\(", sub = "")) %>%
    lazyeval::interp( ~ gsub(.dot, pattern = "c\\)", sub = "")) %>%
    lazyeval::interp( ~ .dot)

  resTable %>% dplyr::mutate_(.dots = setNames(list(mutateCall),
                                               "parameters"))
}
