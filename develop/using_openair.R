library("Ropenaq")
# I installed openair from github
# library("devtools")
# devtools::install_github("davidcarslaw/openair")
library("openair")
library("dplyr")


#####################################
# TIMEPLOT, CALENDARPLOT
#####################################
measurementsNL <- NULL
# get all measurements for 2015
# not very nice code regarding date sequences
# but this way I get everything despite the limit
# of 1000 measurements per call
for(month in 9:12){
  dateFrom <- paste0("2015-", month, "-01")
  dateTo <- paste0("2015-", month+1, "-01")
  if(month == 12){
    dateTo <- "2015-12-31"
  }
  measurementsNL <- rbind(measurementsNL,
                          measurements(location="Amsterdam-Einsteinweg",
                                       limit=1000,
                                       parameter="pm25",
                                       date_from=dateFrom,
                                       date_to=dateTo))
}

# filter negative values
# and rename columns for compatibilities with openair
# I do not drop the old columns though
measurementsNL <- dplyr::mutate(measurementsNL, date=dateLocal,
                                pm25=value) %>%
  filter(value>=0)

# for now openair functions do not work with tbl_df objects
# on MY computer
measurementsNL <- as.data.frame(measurementsNL)

# cool calendar plot
calendarPlot(mydata=measurementsNL, pollutant = "pm25", year =2015)

# useful timeplot
timePlot(mydata=measurementsNL, pollutant = "pm25")

#####################################
# GoogleMapsPlot
#####################################
measurementsNL2 <- measurements(country="NL",
                                parameter="pm25",
                                limit=1000,
                                date_from="2016-01-21",
                                date_to="2016-01-22")

measurementsNL2 <-  dplyr::mutate(measurementsNL2, date=dateLocal,
                                     pm25=value) %>%
  filter(value>=0)
# for now openair functions do not work with tbl_df objects
# on MY computer
measurementsNL2 <- as.data.frame(measurementsNL2)

GoogleMapsPlot(measurementsNL2, lat = "latitude", long = "longitude",
               pollutant = "pm25", cex=3,
               type = "date", maptype = "roadmap", col = "jet")
