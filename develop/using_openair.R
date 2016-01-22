library("Ropenaq")
# I installed openair from github
# library("devtools")
# devtools::install_github("davidcarslaw/openair")
library("openair")
library("dplyr")

measurementsNL <- NULL
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
measurementsNL <- dplyr::mutate(measurementsNL, date=dateLocal,
                                pm25=value) %>%
  filter(value>=0)

# for now openair functions do not work with tbl_df objects
measurementsNL <- as.data.frame(measurementsNL)

calendarPlot(mydata=measurementsNL, pollutant = "pm25", year =2015)

timePlot(mydata=measurementsNL, pollutant = "pm25")

