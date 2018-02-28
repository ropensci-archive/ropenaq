## ---- echo  =  FALSE, warning = FALSE, message = FALSE-------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse  =  TRUE,
  comment  =  "#>",
  purl  =  NOT_CRAN,
  eval  =  NOT_CRAN
)

## ---- warning = FALSE, message = FALSE-----------------------------------
library("ropenaq")
library("ggplot2")
library("dplyr")
library("viridis")


## ---- fig.width = 7, fig.height = 4--------------------------------------
tbHanoi <- aq_measurements(city = "Hanoi", parameter = "pm25", date_from = as.character(Sys.Date()-1), limit = 1000)

tbJakarta <- aq_measurements(city = "Jakarta", parameter = "pm25", date_from = as.character(Sys.Date()-1), limit = 1000)

tbChennai <- aq_measurements(city = "Chennai", location = "US+Diplomatic+Post%3A+Chennai", parameter = "pm25", date_from = as.character(Sys.Date()-1), limit = 1000)


tbPM <- rbind(tbHanoi,
            tbJakarta,
            tbChennai)
tbPM <- filter(tbPM, value >= 0)

ggplot() + geom_line(data = tbPM,
                     aes(x = dateLocal, y = value, colour = location),
                     size = 1.5) +
  ylab(expression(paste("PM2.5 concentration (", mu, "g/",m^3,")"))) +
  theme(text  =  element_text(size = 15)) +
   theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_color_viridis(discrete = TRUE)


## ---- fig.width = 7, fig.height = 4--------------------------------------
tbIndia <- aq_measurements(country = "IN", city = "Delhi", 
                           location = "US+Diplomatic+Post%3A+New+Delhi",
                           parameter = "pm25",
                           date_from = as.character(Sys.Date()-1), limit = 1000)
tbIndia <- filter(tbIndia, value >= 0)
ggplot() + geom_line(data = tbIndia,
                     aes(x = dateLocal, y = value),
                     size = 1.5) +
  ylab(expression(paste("PM2.5 concentration (", mu, "g/",m^3,")"))) +
  theme(text  =  element_text(size = 15))+
   theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

