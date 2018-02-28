## ---- echo = FALSE, warning=FALSE, message=FALSE-------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = NOT_CRAN,
  eval = NOT_CRAN
)

## ---- warning=FALSE, message=FALSE---------------------------------------
library("ropenaq")
library("openair")
library("dplyr")


## ------------------------------------------------------------------------
measurementsNL <- aq_measurements(location="Amsterdam-Einsteinweg", parameter="pm25",
                                       date_from = as.character(Sys.Date() - 100),
                                       date_to = as.character(Sys.Date()))

# filter negative values
# and rename columns for compatibilities with openair
# I do not drop the old columns though
measurementsNL <- dplyr::mutate(measurementsNL, date=dateLocal,
                                pm25=value) %>%
  filter(value>=0)

# for now openair functions do not work with tbl_df objects
# on MY computer
measurementsNL <- as.data.frame(measurementsNL)

## ---- fig.width=7, fig.height=4------------------------------------------
# useful timeplot
timePlot(mydata = measurementsNL, pollutant = "pm25")


## ---- fig.width=7, fig.height=4------------------------------------------
# cool calendar plot 
if(as.numeric(format(Sys.Date(), "%m")) < 2){
  calendarPlot(mydata=measurementsNL, pollutant = "pm25",
             year = as.numeric(format(Sys.Date(), "%Y")) - 1)
}else{
  calendarPlot(mydata=measurementsNL, pollutant = "pm25",
             year = as.numeric(format(Sys.Date(), "%Y")))
}



