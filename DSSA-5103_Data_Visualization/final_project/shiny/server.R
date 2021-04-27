#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(devtools)
install_github("wmurphyrd/fiftystater")

library(rsconnect)
library(shiny)
library(tidyverse)
library(bslib)
library(lubridate)
library(readr)
library(dplyr)
library(fiftystater)
library(Hmisc)
library(viridis)
library(mapproj)
library(ggpubr)
library(ggpmisc)
library(ggrepel)

#thematic::thematic_shiny(font = "auto")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    # Only need to run this if you want to have the editor appear and allow testing of pallettes
    #bs_themer()

    beedata <- NULL
        
    ####################
    # Logic for the main plot
    output$mainPlot <- renderPlot({
        # Import the strava activities file provided by User
        beedata <- read_csv("./HoneyBees.csv")

        # So errors dont come up prior to the user importing their file
        #req(beedata)
        
        # Since input file gives the metadata for the file, need to actually read in the data from the datapath var
        #beedata <- read.csv(beedata$datapath)
        
        ##########
        # parse the activity date
        #beedata$Activity.Date <- as.Date(strava$Activity.Date, format="%b %d, %Y, %I:%M:%S %p")
        
        ##########
        # filter the activities data dynamically based on the data
        plot <- filter(beedata, 
                     year >= lubridate::year(input$dateRange[1]) & year <= lubridate::year(input$dateRange[2])) %>%
            ggplot()
        ##########
        # series of if statements to dynamically add components to the ggplot based on which variables the user selects with the checkboxes
        print(input$mainLegend)
        if('avg_pest_used' %in% input$mainLegend){
            total_pest_by_year <- beedata %>% group_by(state) %>% filter(year >= lubridate::year(input$dateRange[1]) & year <= lubridate::year(input$dateRange[2])) %>% mutate(nAllNeonic=sum(nAllNeonic, na.rm = TRUE)) %>% slice(1) %>% select(state, nAllNeonic)
            
            
            plot <- ggplot(total_pest_by_year, aes(state, nAllNeonic)) + geom_bar(stat="identity") + stat_summary(fun.data=mean_cl_normal) + geom_smooth(method='lm', formula= y~x, color="black") +  scale_y_continuous(label=addUnits)
        }
        if('total_all_neonic_map' %in% input$mainLegend){
            beedata_latest <- beedata %>% group_by(state) %>% filter(year >= lubridate::year(input$dateRange[1]) & year <= lubridate::year(input$dateRange[2])) %>% mutate(nAllNeonic = (2.2 * nAllNeonic)) %>% mutate(nAllNeonic = coalesce(nAllNeonic, 0)) %>% select(state, StateName, year, nAllNeonic, totalprod)
            na.omit(beedata_latest)
            #USA State map
            USA <- map_data("state")
            
            
            plot <- ggplot(beedata_latest) +
                geom_map(map = fifty_states, aes(map_id = str_to_lower(StateName), fill = getLog10(nAllNeonic))) +
                labs(fill = "Total Pesticide (lbs)") +
                expand_limits(x = fifty_states$long, y = fifty_states$lat) +
                borders("state") +
                coord_map() +
                geom_text(
                    data = fifty_states %>%
                        group_by(id) %>%
                        summarise(lat = mean(c(max(lat), min(lat))),
                                  long = mean(c(max(long), min(long)))) %>%
                        mutate(state = id) %>%
                        left_join(beedata_latest, by = c("state" = "state")),
                    aes(x = long, y = lat, label = getLog10(nAllNeonic))
                ) +
                scale_fill_gradient(low="#00ff00", high="#ff0000") +
                scale_x_continuous(breaks = NULL) +
                scale_y_continuous(breaks = NULL) +
                labs(x = "", y = "", title = "Pesticide Used Per State", subtitle = "Normalized with log10") + theme(legend.position = "bottom", 
                                                                                                                     panel.background = element_blank())
        }
        if('total_honey_prod_map' %in% input$mainLegend){
            beedata_latest <- beedata %>% group_by(state) %>% filter(year >= lubridate::year(input$dateRange[1]) & year <= lubridate::year(input$dateRange[2])) %>% mutate(nAllNeonic = (2.2 * nAllNeonic)) %>% mutate(nAllNeonic = coalesce(nAllNeonic, 0)) %>% select(state, StateName, year, nAllNeonic, totalprod)
            na.omit(beedata_latest)
            #USA State map
            USA <- map_data("state")
            
            
            plot <- ggplot(beedata_latest) + 
                geom_map(map = fifty_states, aes(map_id = str_to_lower(StateName), fill = getLog10(totalprod))) + 
                labs(fill = "Total Production (lbs)" ) + 
                expand_limits(x = fifty_states$long, y = fifty_states$lat) +
                borders("state") +
                coord_map() +
                geom_text(
                    data = fifty_states %>%
                        group_by(id) %>%
                        summarise(lat = mean(c(max(lat), min(lat))),
                                  long = mean(c(max(long), min(long)))) %>%
                        mutate(state = id) %>%
                        left_join(beedata_latest, by = c("state" = "state")),
                    aes(x = long, y = lat, label = getLog10(totalprod) )
                ) +
                scale_fill_gradient(low="#22c1c3", high="#fdd42d") +
                scale_x_continuous(breaks = NULL) +
                scale_y_continuous(breaks = NULL) +
                labs(x = "", y = "", title = "Honey Produced Per State", subtitle = "Normalized with log10") + theme(legend.position = "bottom", 
                                                                                                                     panel.background = element_blank())
        }
        #if('Distance' %in% input$mainLegend){
        #    sp <- sp + geom_line(aes(Activity.Date, Distance), color="Green")
        #}
        #if('Elevation' %in% input$mainLegend){
        #    sp <- sp + geom_line(aes(Activity.Date, Elevation.Gain), color='Red')
        #}

        ##########
        # Some formatting to be done to the plot regardless of which variables are selected
        plot + 
            labs(
                title = "Pesticide Used",
                subtitle = "Subtitle test",
                caption = "Caption test"
            ) +
            xlab("Activity Date") +
            ylab("")
            
    })
    
    ####################
#    output$indoor_vs_outdoor_plot <- renderPlot({
        # 

#        req(strava)
#    })
    
    ####################
    #output$avg_watts_snapshot <- renderText({
    #    

#        req(strava)
        
        # Just making the snapshot widget dynamically filtered by the date
#        avg_ftp <- filter(strava,
#                          Activity.Date >= date(input$dateRange[1]) & Activity.Date < date(input$dateRange[2])
#            )
        
        #avg_ftp$avg_ftp[is.na(avg_ftp$avg_ftp)] <- 0
#        avg_ftp <- mean(avg_ftp$avg_ftp, 
#                        na.rm = TRUE)
#    })
    
    ####################
#    observe({
#        if(input$delete_data){
#            # Delete the three data frames of the imported dataset
#            remove(strava_data)
#            remove(strava)
#            remove(sp)
            
            # Reset the widgets that cached the data frames
#            output$avg_watts_snapshot <- NULL
#            output$avg_dist_snapshot <- NULL
#            output$avg_ele_snapshot <- NULL
#            output$avg_dur_snapshot <- NULL
#            output$avg_cad_snapshot <- NULL
#            output$mainPlot <- NULL
#            output$indoor_vs_outdoor_plot <- NULL
            
            # Otherwise errors will be thrown
#            strava <- NULL
            
            # Notify the User their data has been cleared
#            showModal(modalDialog(
#                title="Attention!",
#                "Your Strava 'Activities.csv' file has been deleted from memory.",
#                easyClose=TRUE
#            ))
#        }
#    })
})

#remove(a, x, t, test, total_dist, main_byDate, main_legend, mainLegend, sp, strava)
