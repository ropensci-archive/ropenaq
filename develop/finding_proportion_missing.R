###########################################
# LOADING PACKAGES
##########################################
library("Ropenaq")
library("openair")
library("dplyr")

###########################################
# RESULTS FOR ONE LOCATION
##########################################

locIN <- locations(country="IN")
locationURL <- locIN[4,]$locationURL
locationName <- locIN[4,]$location
firstUpdated <- locIN[4,]$firstUpdated

measurementsForPlot <- findMissing2015(locationURL,
                                       locationName,
                                       firstUpdated,
                                       parameter="pm25")

calendarPlot(measurementsForPlot, pollutant="propNA",
             main=paste0("Proportion of missing PM2.5 values in ",
                         locationName),
             limits = c(0, 1), cols="heat")

###########################################
# POSSIBLE NEW FUNCTIONS
##########################################
# function for calculating the percentage of NA
propNA <- function(x){
  return(sum(x<0)/length(x))
}
# main function
findMissing2015 <- function(locationURL,
                            locationName,
                            firstUpdated,
                            parameter){

  seqDays <- seq(from=ymd(format(firstUpdated, "%Y-%m-%d")),
                 to=ymd("2015-12-31"),
                 by="1 day")
  seqDays <- format(seqDays, "%Y-%m-%d")
  measurementsLoc <- NULL
  for(i in 1:(length(seqDays)-1)){
    measurementsLocTemp <- try(Ropenaq::measurements(location=locationURL,
                                                     parameter=parameter,
                                                     limit=1000,
                                                     date_from=seqDays[i],
                                                     date_to=seqDays[i+1]), silent=TRUE)
    print(seqDays[i])

    if(class(measurementsLocTemp)[1]!="try-error"){
      measurementsLoc <- rbind(measurementsLoc,
                               measurementsLocTemp)
    }

  }

  # might be useful later
  measurementsLoc <- unique(measurementsLoc)

  measurementsLoc <- dplyr::mutate(measurementsLoc,
                                   day=format(dateLocal, "%Y-%m-%d"),
                                   pm25=value)

  # group by day and calculate the proportion is missing
  measurementsGrouped <- dplyr::group_by(measurementsLoc, day)
  measurementsSummary <- dplyr::summarise(measurementsGrouped,
                                          propNA=propNA(pm25))

  measurementsSummary <- dplyr::mutate(measurementsSummary,
                                       date=ymd(day))

  # the problem is that is there are no measures for the day
  # the day is not in the data!


  measurementsForPlot <- data.frame(date=seqDays,
                                    propNA=rep(1, length(seqDays)))

  measurementsForPlot$date <- ymd(measurementsForPlot$date)
  measurementsForPlot$propNA[ymd(seqDays)%in%measurementsSummary$date] <-
    measurementsSummary$propNA
  return(measurementsForPlot)

}




