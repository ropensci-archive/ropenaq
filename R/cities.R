#' Providing a simple listing of cities within the platform.
#'
#' @import dplyr
#' @import httr
#' @param country
#'
#' @return a data.table with locations, count, country, city columns.
#' @export
#'
#' @examples
#' cities(country="IN")
cities <- function(country=NULL){

  query <- "https://api.openaq.org/v1/cities"
  # country
  if(!is.null(country)){
    query <- paste0(query, "?country=", country)
  }

  # get results

  page <- httr::GET(query)

  contentPage <- httr::content(page)

  if(length(contentPage[[2]])==0){stop("No results for this query")}

  else{
    locations <- unlist(lapply(contentPage[[2]], function (x) x['locations']))
    count <- unlist(lapply(contentPage[[2]], function (x) x['count']))
    country <- unlist(lapply(contentPage[[2]], function (x) x['country']))
    city <- unlist(lapply(contentPage[[2]], function (x) x['city']))

    citiesTable <- dplyr::tbl_df(
      data.frame(locations=locations,
                 count=count,
                 country=country,
                 city=city))


    return(citiesTable)
  }


}

