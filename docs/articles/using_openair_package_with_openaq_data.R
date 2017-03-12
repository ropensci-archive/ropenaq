## ---- echo = FALSE, warning=FALSE, message=FALSE-------------------------
NOT_CRAN <- !identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = TRUE,
  eval = TRUE
)

## ---- warning=FALSE, message=FALSE---------------------------------------
library("ropenaq")
library("openair")
library("dplyr")


## ------------------------------------------------------------------------
measurementsNL <- aq_measurements(location="Amsterdam-Einsteinweg", parameter="pm25",
                                       date_from="2015-09-01",
                                       date_to="2015-12-31")

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
timePlot(mydata=measurementsNL, pollutant = "pm25")


## ---- fig.width=7, fig.height=4------------------------------------------
# cool calendar plot
calendarPlot(mydata=measurementsNL, pollutant = "pm25", year =2015)


