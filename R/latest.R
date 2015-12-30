#' Provides the latest value of each available parameter for every location in the system.
#'
#' @param city 	Limit results by a certain city.
#' @param country Limit results by a certain country.
#' @param location Limit results by a certain location.
#' @param parameter  Limit to only a certain parameter (valid values are "pm25", "pm10", "so2", "no2", "o3", "co" and "bc").
#' If no parameter is given, all parameters are retrieved.
#' @param has_geo has_geo Filter out items that have or do not have geographic information.Can only be TRUE for now.
#' @param value_from Show results above value threshold, useful in combination with \code{parameter}.
#' @param value_to Show results below value threshold, useful in combination with \code{parameter}.
#'
#' @return
#' @export
#'
#' @examples
latest <- function(city=NULL,
                   country=NULL,
                   location=NULL,
                   parameter=NULL,
                   has_geo=NULL,
                   value_from=NULL,
                   value_to=NULL){

  query <- "https://api.openaq.org/v1/latest?"

  # country
  if(!is.null(country)){
    if(!(country%in%countries()$code)){stop("This country is not available within the platform.")}
    query <- paste0(query, "&country=", country)
  }

  # city
  if(!is.null(city)){
    query <- paste0(query, "&city=", city)
  }

  # location
  if(!is.null(location)){
    query <- paste0(query, "&location=", location)
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

  # check values
  if(!is.null(value_from)&!is.null(value_to)){
    if(value_to<value_from){
      stop("The max value must be bigger than the min value.")
    }

  }
  # value_from
  if(!is.null(value_from)){
    if(value_from<0){stop("No negative values please!")}
    query <- paste0(query, "&value_from=", value_from)
  }

  # value_to
  if(!is.null(value_to)){
    if(value_to<0){stop("No negative values please!")}
    query <- paste0(query, "&value_to=", date_to)
  }

  if(query=="https://api.openaq.org/v1/latest?"){
    query <- "https://api.openaq.org/v1/latest"
  }
  # get results

  page <- httr::GET(query)

  contentPage <- httr::content(page)
  if(length(contentPage[[2]])==0){stop("No results for this query")}
  else{
    location <- unlist(lapply(contentPage[[2]], function (x) x['location']))
    city <- unlist(lapply(contentPage[[2]], function (x) x['city']))
    country <- unlist(lapply(contentPage[[2]], function (x) x['country']))

    # repeat for each parameters
    noOfParameters <- 7
    location <- rep(location, each=noOfParameters)
    city <- rep(city, each=noOfParameters)
    country <- rep(country, each=noOfParameters)
    parameter <- rep(NA, length(country))
    value <- rep(NA, length(country))
    lastUpdated <- rep(NA, length(country))
    unit <- rep(NA, length(country))

    # Here this is slow
    for (loc in 1:length(contentPage[[2]])){
      for (param in 0:(length(contentPage[[2]][[loc]]$measurements)-1)){
        parameter[loc+param] <- contentPage[[2]][[loc]]$measurements[[param+1]]$parameter
        value[loc+param] <- contentPage[[2]][[loc]]$measurements[[param+1]]$value
        lastUpdated[loc+param] <- contentPage[[2]][[loc]]$measurements[[param+1]]$lastUpdated
        unit[loc+param] <- contentPage[[2]][[loc]]$measurements[[param+1]]$unit

      }
    }

    latestTable <- dplyr::tbl_df(
      data.frame(location=location,
                 city=city,
                 country=country,
                 parameter=parameter,
                 value=value,
                 lastUpdated=lastUpdated,
                 unit=unit))

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
      latitude <- rep(latitude, noOfParameters)
      longitude <- unlist(lapply(contentPage[[2]], geoCoordLong))
      longitude <- rep(longitude, noOfParameters)
      latestTable <- dplyr::mutate(latestTable, latitude=latitude, longitude=longitude)
    }

    # ditch empty lines and transforme date time
    latestTable <- dplyr::filter(latestTable, !is.na(parameter))
    latestTable <- dplyr::mutate(latestTable, lastUpdated=lubridate::ymd_hms(lastUpdated))

return(latestTable)
  }
}