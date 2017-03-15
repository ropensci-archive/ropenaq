#' @importFrom stats setNames
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
                       value_to = NULL, limit = NULL,
                       latitude = NULL, longitude = NULL,
                       attribution = NULL,
                       averaging_period = NULL,
                       source_name = NULL,
                       radius = NULL,
                       page = NULL){
  # limit
  if (!is.null(limit)) {
    if (limit > 10000) {
      stop(call. = FALSE, "limit cannot be more than 10,000")
    }
  }

  # location
  if (!is.null(location)) {

    locations <- aq_locations(country = country,
                           city = city)

    if (!(location %in% locations$locationURL)) {# nolint
      stop(call. = FALSE, "This location/city/country combination is not available within the platform. See ?locations")# nolint
    }
    # make sure it won't be re-encoded
    Encoding(location) <- "UTF-8"
    class(location) <- c("character", "AsIs")
  }


  # city
  if (!is.null(city)) {
    cities <-  aq_cities(country = country)

    if (!(city %in% cities$cityURL)) {# nolint
      stop(call. = FALSE, paste0("This city/country combination is not available within the platform. See ?cities."))# nolint
    }
    # make sure it won't be re-encoded
    Encoding(city) <- "UTF-8"
    class(city) <- c("character", "AsIs")
  }

  # country
  if (!is.null(country)) {

    if (!(country %in% aq_countries()$code)) {# nolint
      stop(call. = FALSE, "This country is not available within the platform. See ?countries")
    }
  }

  # parameter
  if (!is.null(parameter)) {
    if (!(parameter %in% c("pm25", "pm10", "so2",
                           "no2", "o3", "co", "bc"))) {
      stop(call. = FALSE, "You asked for an invalid parameter: see list of valid parameters in the Arguments section of the function help")# nolint
    }

  locations <-  aq_locations(country = country,
                         city = city,
                         location = location)

    if (apply(locations[, parameter], 2, sum) == 0) {
      stop(call. = FALSE, "This parameter is not available for any location corresponding to your query. See ?locations")# nolint
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
      stop(call. = FALSE, "date_from and date_to have to be inputed as year-month-day.")
    }
  }
  # date_to
  if (!is.null(date_to)) {
    if (is.na(lubridate::ymd(date_to))) {
      stop(call. = FALSE, "date_from and date_to have to be inputed as year-month-day.")
    }
  }

  # check dates
  if (!is.null(date_from) & !is.null(date_to)) {
    if (ymd(date_from) > ymd(date_to)) {
      stop(call. = FALSE, "The start date must be smaller than the end date.")
    }

  }

  # value_from
  if (!is.null(value_from)) {
    if (value_from < 0) {
      stop(call. = FALSE, "No negative value for value_from please!")
    }
  }

  # value_to
  if (!is.null(value_to)) {
    if (value_to < 0) {
      stop(call. = FALSE, "No negative value for value_to please!")
    }
  }

  # check values
  if (!is.null(value_from) & !is.null(value_to)) {
    if (value_to < value_from) {
      stop(call. = FALSE, "The max value must be bigger than the min value.")
    }

  }

  if(!is.null(latitude)|!is.null(longitude)){
    if(is.null(latitude)|is.null(longitude)){
      stop(call. = FALSE, "If you input a latitude or longitude, you have to input the other coordinate")
    }
    if (!dplyr::between(latitude, -90, 90)){
      stop(call. = FALSE, "Latitude should be between -90 and 90.")
    }
    if (!dplyr::between(longitude, -180, 180)){
      stop(call. = FALSE, "Longitude should be between -180 and 180.")
    }
    coordinates <- paste(latitude, longitude, sep = ",")
  }else{
    coordinates <- NULL
  }

  if(!is.null(radius)){
    if(is.null(latitude)){
      stop(call. = FALSE,
           "Radius has to be used with latitude and longitude.")
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
                   limit = limit,
                   coordinates = coordinates,
                   radius = radius,
                   page = page)

  # argument only for measurements
  include_fields <- c(attribution,
                      averaging_period,
                      source_name)
  if(any(!is.null(include_fields))){

    fields <-  c("attribution",
                 "averagingPeriod",
                 "sourceName")
    fields <- fields[include_fields]
    fields <- toString(fields)
    fields <- gsub(", ", ",", fields)
    argsList[["include_fields"]] <- fields

  }

  return(argsList)
}

############################################################
#                                                          #
#                       check status                       ####
#                                                          #
############################################################
get_status <- function(){
  client <- crul::HttpClient$new(url = "https://api.openaq.org/status")
  status <- client$get()
  status <- suppressMessages(status$parse())
  status <- jsonlite::fromJSON(status)
  return(status$results$healthStatus)
  }

######################################################################################
# gets and parses
getResults <- function(urlAQ, argsList){
  if(!is.null(argsList$page)){
    getResults_bypage(urlAQ, argsList)
  }else{
    getResults_bymorepages(urlAQ, argsList)
  }

}
getResults_bypage <- function(urlAQ, argsList){

  client <- crul::HttpClient$new(url = urlAQ)
  argsList <- Filter(Negate(is.null), argsList)
  res <- client$get(query = argsList)
  try_number <- 1
  while(res$status_code >= 400 && try_number < 6) {status <- get_status()
  if(status %in% c("green", "yellow")){
    message(paste0("Server returned nothing, trying again, try number", try_number))
    Sys.sleep(2^try_number)
    res <- client$get(query = argsList)
    try_number <- try_number + 1
  }else{
    stop("uh oh, the OpenAQ API seems to be having some issues, try again later")
  }

  }
  results <- treat_res(res)
  return(results)

  }

getResults_bymorepages <- function(urlAQ, argsList){
  argsList <- Filter(Negate(is.null), argsList)
  # find number of total pages
  argsList2 <- argsList
  argsList2$page <- 1
  count <- getResults_bypage(urlAQ, argsList2)
  count <- attr(count, "meta")$found
  no_pages <- ceiling(count/10000)
  if(no_pages == 1){
    return(getResults_bypage(urlAQ, argsList))
  }else{
    queries <- lapply(1:no_pages,
                      add_page,
                      query = argsList)
    # 10 urls by request
    requests <- lapply(queries, create_request,
                       urlAQ = urlAQ)
    requests <- split(requests, ceiling(seq_along(requests)/10))

    res_list <- lapply(requests, get_res)
    dplyr::bind_rows(res_list)
  }
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
# transform a given column in POSIXct
functionTime <- function(resTable, newColName) {
  mutateCall <- lazyeval::interp( ~ lubridate::ymd_hms(a),
                                  a = as.name(newColName))

  resTable %>% dplyr::mutate_(.dots = setNames(list(mutateCall),
                                               newColName))
}

######################################################################################
# create the parameters column
functionParameters <- function(resTable) {
  mutateCall <- lazyeval::interp( ~ unlist(lapply(a, toString)),
                                  a = as.name("parameters")) %>%
    lazyeval::interp( ~ gsub(.dot, pattern = "\"", sub = "")) %>%
    lazyeval::interp( ~ gsub(.dot, pattern = "\\(", sub = "")) %>%
    lazyeval::interp( ~ gsub(.dot, pattern = "c\\)", sub = "")) %>%
    lazyeval::interp( ~ .dot)

  resTable <- resTable %>% dplyr::mutate_(.dots = setNames(list(mutateCall),
                                                           "parameters"))
  resTable$pm25 <-  grepl("pm25", resTable$parameters)
  resTable$pm10 <-  grepl("pm10", resTable$parameters)
  resTable$no2 <-  grepl("no2", resTable$parameters)
  resTable$so2 <-  grepl("so2", resTable$parameters)
  resTable$o3 <-  grepl("o3", resTable$parameters)
  resTable$co <-  grepl("co", resTable$parameters)
  resTable$bc <-  grepl("bc", resTable$parameters)
  resTable <- resTable %>% select_(~ - parameters)
}


# dates abbreviation
func_date_headers <- function(date){
  date <- strsplit(date, ",")[[1]][2]
  date <- gsub("Jan", "01", date)
  date <- gsub("Feb", "02", date)
  date <- gsub("Mar", "03", date)
  date <- gsub("Apr", "04", date)
  date <- gsub("May", "05", date)
  date <- gsub("Jun", "06", date)
  date <- gsub("Jul", "07", date)
  date <- gsub("Aug", "08", date)
  date <- gsub("Sep", "09", date)
  date <- gsub("Oct", "10", date)
  date <- gsub("Nov", "11", date)
  date <- gsub("Dec", "12", date)
  lubridate::dmy_hms(date, tz = "GMT")
}


add_page <- function(page, query){
  query$page <- page
  return(query)
}

treat_res <- function(res){
  contentPage <- suppressMessages(res$parse())
  # parse the data
  output <- jsonlite::fromJSON(contentPage)

  coordinates <- output$results$coordinates
  date <- output$results$date
  averagingPeriod <- output$results$averagingPeriod

  if(!is.null(date)){
    date <- rename_(date, date.utc = "utc")
    date <- rename_(date, date.local = "local")

  }
  if(!is.null(averagingPeriod)){
    averagingPeriod <- rename_(averagingPeriod, averagingPeriod.unit = "unit")
    averagingPeriod <- rename_(averagingPeriod, averagingPeriod.value = "value")

  }
  results <- output$results

  if("averagingPeriod" %in% names(results)){
    results <- dplyr::select_(results, quote(- averagingPeriod))
  }
  if("coordinates" %in% names(results)){
    results <- dplyr::select_(results, quote(- coordinates))
  }
  if("date" %in% names(results)){
    results <- dplyr::select_(results, quote(- date))
  }
  results <- dplyr::bind_cols(results, coordinates)
  results <- dplyr::bind_cols(results, date)
  results <- dplyr::bind_cols(results, averagingPeriod)

  results <- dplyr::tbl_df(results)

  # get the meta
  meta <- dplyr::tbl_df(
    as.data.frame(output$meta))
  #get the time stamps
  timestamp <- dplyr::tbl_df(data.frame(
    queriedAt = func_date_headers(res$response_headers$date)))

  attr(results, "meta") <- meta
  attr(results, "timestamp") <- timestamp
  attr(results, "url") <- res$url
  return(results)
}


create_request <- function(query, urlAQ){
  crul::HttpRequest$new(url = urlAQ)$get(query = query)
}

# get results for an
get_res <- function(async){
  res <- crul::AsyncVaried$new(.list = async)
  output <- res$request()
  try_number <- 1
  while(any(res$status_code() >= 400) && try_number < 6) {status <- get_status()
  if(status %in% c("green", "yellow")){
    message(paste0("Server returned nothing, trying again, try number", try_number))
    Sys.sleep(2^try_number)
    output <- res$request()
    try_number <- try_number + 1
  }else{
    stop("uh oh, the OpenAQ API seems to be having some issues, try again later")
  }

  }

  lapply(output, treat_res) %>% bind_rows()
}
