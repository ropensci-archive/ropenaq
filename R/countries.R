#' Providing a simple listing of countries within the platform.
#'
#' @return
#' @export
#'
#' @examples
#' countries()
countries <- function(){
  query <- "https://api.openaq.org/v1/countries"

  # get results

  page <- httr::GET(query)

  contentPage <- httr::content(page)
  if(length(contentPage[[2]])==0){stop("No results for this query")}
  else{
    code <- unlist(lapply(contentPage[[2]], function (x) x['code']))
    name <- unlist(lapply(contentPage[[2]], function (x) x['name']))
    count <- unlist(lapply(contentPage[[2]], function (x) x['count']))

    countriesTable <- dplyr::tbl_df(
      data.frame(code=code,
                 name=name,
                 count=count))

    return(countriesTable)
  }

}
