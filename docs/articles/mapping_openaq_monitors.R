## ---- echo = FALSE, warning=FALSE, message=FALSE-------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = NOT_CRAN,
  eval = NOT_CRAN
)

## ---- warning=FALSE, message=FALSE---------------------------------------
library("ggplot2")
library("ropenaq")
library("dplyr")

## ---- warning=FALSE, message=FALSE---------------------------------------
dataGeo <- aq_locations()
dataGeo <- filter(dataGeo, location != "Test Prueba", location != "PA")

## ----fig.width=7, fig.height=4, warning=FALSE, message=FALSE-------------


library("rworldmap")

worldMap <- map_data(map="world")

gg <- ggplot() + geom_map(data=worldMap, map=worldMap,
                          aes(map_id=region, x=long, y=lat),
                          fill = "grey60")
gg

## ----fig.width=7, fig.height=4-------------------------------------------
plotMap <- gg +
  geom_point(data = dataGeo, aes(x=longitude, y=latitude), size=1, col = "#EE9F8E")+
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
       axis.text.y=element_blank(),axis.ticks=element_blank(),
       axis.title.x=element_blank(),
       axis.title.y=element_blank(),legend.position="none",
       panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
       panel.grid.minor=element_blank(),plot.background=element_blank())+
   ggtitle("OpenAQ data sources with geographical coordinates") +
  theme(plot.title = element_text(lineheight=1, face="bold"))
print(plotMap)


