#' AQI calculator
#'
#' @param data Data.frame with timedate, and one column for each parameter values.
#' @param version For now only "Canada", which version of the AQI to use?
#'
#' @return A data.frame (dplyr tbl_df) with timedate and AQI values
#' @export
#' @details For 'Canada', see https://en.wikipedia.org/wiki/Air_Quality_Health_Index_(Canada)
#' Needs hourly values for O3, NO2 and PM2.5. Difference with Wikipedia definition: no difference station/community,
#'  calculates per location for now.
#' @examples
aqi <- function(data, version){

  aqi <- NULL
  return(aqi)
}
