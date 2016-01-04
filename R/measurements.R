#' Function for getting measurements table from the openAQ API
#'
#' @import dplyr
#' @import lubridate
#' @import httr
#' @param country Limit results by a certain country.
#' @param city 	Limit results by a certain city.
#' @param location Limit results by a certain location.
#' @param parameter Limit to only a certain parameter (valid values are "pm25", "pm10", "so2", "no2", "o3", "co" and "bc").
#' If no parameter is given, all parameters are retrieved.
#' @param has_geo Filter out items that have or do not have geographic information.Can only be TRUE for now.
#' @param date_from Show results after a certain date. (ex. "2015-12-20")
#' @param date_to Show results before a certain date. (ex. "2015-12-20")
#' @param limit Change the number of results returned, max is 1000.

#'
#' @return A data.table with UTC date and time, local date and time, country, location, city, parameter, unit, measure,
#' and geographical coordinates if they were available.
#' @details The sort and sort_by parameters from the API were not included because one can still re-order the table in R.
#' Regarding the number of page, similarly here it does not make any sense to have it.
#' include_fields was not included either.
#' value_from and value_to were not included because one could filter the output table in R directly.
#' #'
#' @examples
#' measurements(country="IN", limit=9, city="Chennai")
#' measurements(country="US", has_geo=TRUE)
#' @export

measurements <- function(country=NULL, city=NULL, location=NULL,
                         parameter=NULL,
                         has_geo=NULL,
                         date_from=NULL, date_to=NULL,
                         limit=100){
  # base URL
  query <- "https://api.openaq.org/v1/measurements?page=1"

  # limit
  if(is.null(limit)){
    limit <- 100
  }
  if(limit>1000){
    stop("limit cannot be more than 1000")
  }

  query <- paste0(query, "&limit=", limit)

  # country
  if(!is.null(country)){
    if(!(country%in%countries()$code)){stop("This country is not available within the platform.")}
    query <- paste0(query, "&country=", country)
  }

  # city
  if(!is.null(city)){
    if(!is.null(country)){
      if(!(city%in%cities(country=country)$city)){stop("This city is not available within the platform for this country.")}
    }
    else{
      if(!(city%in%cities()$city)){stop("This city is not available within the platform.")}
    }
    query <- paste0(query, "&city=", city)

  }

  # location
  if(!is.null(location)){
    query <- paste0(query, "&location=", location)
    if(!is.null(country)){
      if(!is.null(city)){
        if(!(location%in%gsub(" ", "+",locations(country=country, city=city)$location))){
          stop("This location is not available within the platform for this country and this city.")
        }
      }
      else{
        if(!(location%in%gsub(" ", "+",locations(country=country)$location))){
          stop("This location is not available within the platform for this country.")
        }
      }

    }

    else{
      if(!is.null(city)){
        if(!(location%in%gsub(" ", "+",locations( city=city)$location))){
          stop("This location is not available within the platform for this city.")
           }
      }
      else{
        if(!(location%in%gsub(" ", "+",locations(country=country, city=city)$location))){
          stop("This location is not available within the platform.")
      }
      }
    }
  }

  # parameter
  if(!is.null(parameter)){
    if(!(parameter%in%c("pm25", "pm10", "so2", "no2", "o3", "co", "bc"))){
      stop("You asked for an invalid parameter: see list of valid parameters in the Arguments section of the function help")
    }
    query <- paste0(query, "&parameter=", parameter)
  }
  # has_geo
  if(!is.null(has_geo)){
    if(has_geo==TRUE){
      query <- paste0(query, "&has_geo=1")
    }

  }

  # check dates
  if(!is.null(date_from)&!is.null(date_to)){
    if(ymd(date_from)>ymd(date_to)){
      stop("The start date must be smaller than the end date.")
    }

  }

  # date_from
  if(!is.null(date_from)){
    query <- paste0(query, "&date_from=", date_from)
  }
  # date_to
  if(!is.null(date_from)){
    query <- paste0(query, "&date_to=", date_to)
  }
  # get results

  page <- httr::GET(query)

  contentPage <- httr::content(page)
  contentPageText <- httr::content(page,as = "text")
  if(grepl("Gateway time-out", toString(contentPageText))){stop("Gateway time-out, but try again in a few minutes.")}
  if(length(contentPage[[2]])==0){stop("No results for this query")}
  else{
    # Extract all future columns
    value <- unlist(lapply(contentPage[[2]], function (x) x['value']))
    dateUTC <- unlist(lapply(contentPage[[2]], function (x) x$date$utc))
    dateLocal <- unlist(lapply(contentPage[[2]], function (x) x$date$local))
    parameter <- unlist(lapply(contentPage[[2]], function (x) x['parameter']))
    location <- unlist(lapply(contentPage[[2]], function (x) x['location']))
    unit <- unlist(lapply(contentPage[[2]], function (x) x['unit']))
    city <- unlist(lapply(contentPage[[2]], function (x) x['city']))
    country <- unlist(lapply(contentPage[[2]], function (x) x['country']))

    # create the data.table, transforming dates using lubridate
    tableOfData <- dplyr::tbl_df(
      data.frame(dateUTC=dateUTC,
                 dateLocal=dateLocal,
                 parameter=parameter,
                 location=location,
                 value=value,
                 unit=unit,
                 city=city,
                 country=country))

    geoCoordLat <- function(x){
      if(is.null(x$coordinates$latitude)){
        return(NA)
      }
      else(return(x$coordinates$latitude))
    }

    geoCoordLong <- function(x){
      if(is.null(x$coordinates$longitude)){
        return(NA)
      }
      else(return(x$coordinates$longitude))
    }

    if(!is.null(unlist(lapply(contentPage[[2]], function (x) x$coordinates$latitude)))){
      latitude <- unlist(lapply(contentPage[[2]], geoCoordLat))
      longitude <- unlist(lapply(contentPage[[2]], geoCoordLong))
      tableOfData <- dplyr::mutate(tableOfData, latitude=latitude, longitude=longitude)
    }

    tableOfData <- dplyr::mutate(tableOfData,dateUTC=lubridate::ymd_hms(dateUTC),
                                 dateLocal=lubridate::ymd_hms(substr(dateLocal, 1, 19)))
    tableOfData <- dplyr::arrange(tableOfData, dateUTC)

    # DONE!
    return(tableOfData)
  }


}
