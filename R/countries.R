#' Providing a simple listing of countries within the platform.
#'
#' @importFrom dplyr tbl_df "%>%"
#' @importFrom httr GET content
#' @return data.frame (dplyr "tbl_df") with code and name for each country,
#' as well as the number of sources in each country.
#' @export
#'
#' @examples
#' countries()
countries <- function() {
    ####################################################
  # BUILD QUERY
    query <- paste0(base_url(), "countries")

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
        code <- unlist(lapply(contentPage[[2]], function(x) x["code"]))
        name <- unlist(lapply(contentPage[[2]], function(x) x["name"]))
        count <- unlist(lapply(contentPage[[2]], function(x) x["count"]))

        countriesTable <- dplyr::tbl_df(data.frame(code = code,
                                                   name = name, count = count))
        ####################################################
        # DONE!
        return(countriesTable)
    }

}
