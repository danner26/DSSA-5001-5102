library(devtools)
install_github("wmurphyrd/fiftystater")
library(tidyverse)
library(readr)
library(dplyr)
library(fiftystater)
library(viridis)
library(mapproj)
library(ggpubr)
library(ggmap)
library(chron)
library(lubridate)
library(list)

#setwd("/home/rstudio/dssa_workspace/DSSA5001/project3")

bikedata <- read_csv("data/indego_extracted/combined.csv")
bikedata <- transform(bikedata, start_date = as.Date(start_time))
bikedata <- transform(bikedata, end_date = as.Date(end_time))
bikedata <- bikedata %>% mutate(end_month = format(as.Date(end_date), "%m"))
bikedata <- bikedata %>% mutate(duration_hrs = duration * (1 / 60))
bikedata_lessthanday <- bikedata %>% filter(duration <= 1440)
dates <- bikedata %>% mutate(end_date = ymd(end_date)) %>%  summarise(min = format(as.Date(min(end_date)), "%Y"), max = format(as.Date(max(end_date)), "%Y"))

dates <- bikedata %>% mutate(end_date = ymd(end_date)) %>%  summarise(min = format(as.Date(min(end_date)), "%Y"), max = format(as.Date(max(end_date)), "%Y"))

bikedata_morethanday <- bikedata %>% filter(duration >= 1440)

plotData <- function(dataframe, year) {
  plotdata <- NULL
  plotdata <- ggplot(dataframe, aes(x=end_month, y=duration_hrs)) +
    geom_boxplot() + 
    stat_summary(fun=mean, geom="point", size=3, fill="tomato", aes(shape="mean")) +
    scale_shape_manual("", values=c("mean"=23)) +
    labs(x = "Month of Year", y = "Duration of Ride (Hours)", title = paste(year, "Ride Duration")) 
  ggsave(paste(getwd(), "/images/date", i, "plot.png", sep = ""), plot=plotdata, width = 20, height = 20, units = "cm")
  return(plotdata)
}

plotList <- c()
for (i in dates$min:dates$max) {
  assign(
    paste("date", i, sep = ""), 
    (
      bikedata_morethanday %>% 
        filter(end_date < as.Date(paste(toString(i+1), "01", "01", sep = "-"))) %>% 
        filter(end_date >= as.Date(paste(toString(i), "01", "01", sep = "-")))
    )
  )
  
  plotList[[paste("date", i, "plot", sep = "")]] <- plotData(get(paste("date", i, sep = "")), i)
}

register_google("AIzaSyDKtwhlFbnDQZVNGpSl36sELNF9nE6GTTs", "premium")
#USA State map
start_lon <- mean(bikedata_lessthanday$start_lon, na.rm = TRUE) 
start_lat <- mean(bikedata_lessthanday$start_lat, na.rm = TRUE) 
USA <- get_map(location = c(lon = start_lon, lat = start_lat), zoom=13, maptype = "terrain", source='google',color='color')

ggmap(USA) +
  geom_point(data=bikedata_lessthanday, aes(x=unlist(start_lon), y=unlist(start_lat), fill = "red", alpha = 0.8), size = 5, shape = 21) +
  guides(fill=FALSE, alpha=FALSE, size=FALSE) +
  labs(x = "", y = "", title = 
         paste("Ride Starting Locations (", format(min(bikedata$start_date), format="%Y"), " - ", format(max(bikedata$start_date), format="%Y"), ")", sep = "")) +
  ggthemes::theme_map()
ggsave(paste(getwd(), "/images/", "StartMap.png", sep = ""), width = 20, height = 20, units = "cm")

USA <- get_map(location = c(lon = start_lon, lat = start_lat), zoom=13, maptype = "terrain", source='google',color='color')
ggmap(USA) +
  geom_point(data=bikedata_lessthanday, aes(x=unlist(end_lon), y=unlist(end_lat), fill = "red", alpha = 0.8), size = 5, shape = 21) +
  guides(fill=FALSE, alpha=FALSE, size=FALSE) +
  labs(x = "", y = "", title = 
         paste("Ride Ending Locations (", format(min(bikedata$start_date), format="%Y"), " - ", format(max(bikedata$start_date), format="%Y"), ")", sep = "")) +
  ggthemes::theme_map()
ggsave(paste(getwd(), "/images/", "EndMap.png", sep = ""), width = 20, height = 20, units = "cm")

# Ref: https://5harad.com/mse125/r/visualization_code.html
addUnits <- function(n) {
  labels <- ifelse(n < 1000, n,  # less than thousands
                   ifelse(n < 1e6, paste0(round(n/1e3), 'k'),  # in thousands
                          ifelse(n < 1e9, paste0(round(n/1e6), 'M'),  # in millions
                                 ifelse(n < 1e12, paste0(round(n/1e9), 'B'), # in billions
                                        ifelse(n < 1e15, paste0(round(n/1e12), 'T'), # in trillions
                                               'too big!'
                                        )))))
  return(labels)
}

duration <- as.data.frame(table(bikedata$plan_duration))
ggplot(duration, aes(x=Var1, y=Freq)) +
  geom_bar(stat = "identity", position = 'dodge') +
  scale_y_continuous(label=addUnits) +
  geom_text(aes(label=prettyNum(Freq, big.mark = ",")), position=position_dodge(width=0.9), vjust=-0.25) +
  labs(x = "Rental Duration (Days)", y = "Amount of Rentals", title = 
         paste("Rental Durations (", format(min(bikedata$start_date), format="%Y"), " - ", format(max(bikedata$start_date), format="%Y"), ")", sep = ""))
ggsave(paste(getwd(), "/images/", "RentalDurations.png", sep = ""), width = 20, height = 20, units = "cm")

memberships <- as.data.frame(table(bikedata$passholder_type))
ggplot(memberships, aes(x=Var1, y=Freq)) +
  geom_bar(stat = "identity", position = 'dodge') +
  scale_y_continuous(label=addUnits) +
  geom_text(aes(label=prettyNum(Freq, big.mark = ",")), position=position_dodge(width=0.9), vjust=-0.25) +
  labs(x = "Passholder Types", y = "Amount of Passes", title = 
         paste("Pass Types (", format(min(bikedata$start_date), format="%Y"), " - ", format(max(bikedata$start_date), format="%Y"), ")", sep = "")) 
ggsave(paste(getwd(), "/images/", "PassTypes.png", sep = ""), width = 20, height = 20, units = "cm")

checkRange <- function(n) {
  durationRange <- ifelse(n < 5, "1-4",  #1-4 hours
                          ifelse(n < 9, "5-8",  # in thousands
                                 ifelse(n < 13, "9-12",  # in millions
                                        ifelse(n < 17, "13-16", # in billions
                                               ifelse(n < 21, "17-20", # in trillions
                                                      "21-24"
                                               )))))
  return(durationRange)
}

daypasses <- bikedata %>% group_by(passholder_type) %>% filter(passholder_type == "Day Pass") %>% mutate(duration_hours_range = checkRange(ceiling(duration_hrs)))
dayHours <- as.data.frame(table(daypasses$duration_hours_range))

ggplot(dayHours, aes(x=Var1, y=Freq)) +
  geom_bar(stat = "identity", position = 'dodge') +
  scale_y_continuous(label=addUnits) +
  geom_text(aes(label=prettyNum(Freq, big.mark = ",")), position=position_dodge(width=0.9), vjust=-0.25) +
  labs(x = "Rental Duration (4 Hour Increments)", y = "Amount of Rentals", title = 
         paste("Single Day Rental Usage Hours (", format(min(bikedata$start_date), format="%Y"), " - ", format(max(bikedata$start_date), format="%Y"), ")", sep = "")) 
ggsave(paste(getwd(), "/images/", "SingleDayRentalUsage.png", sep = ""), width = 20, height = 20, units = "cm")
