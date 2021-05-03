#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

devtools::install_github("wmurphyrd/fiftystater")

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
library(measurements)

#thematic::thematic_shiny(font = "auto")

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

getLog10 <- function(n) {
    value <- ifelse(n == 0, 0, log10(n))
}

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    # Only need to run this if you want to have the editor appear and allow testing of pallettes
    #bs_themer()

    beedata <- read_csv("./HoneyBees.csv")
    
    output$date_selection <- renderUI({
        start <- paste(c(min(beedata %>% group_by(year) %>% slice(1) %>% select(year)), "-01-01"), collapse = "")
        end <- paste(c(max(beedata %>% group_by(year) %>% slice(1) %>% select(year)), "-12-31"), collapse = "")
        print(end)
        dateRangeInput("dateRange",
                       "Date Range:",
                       start = start,
                       end = end,
                       min = start,
                       max = end,
                       startview="decade", format="yyyy")
    })
    
    output$select_field <- renderUI({
        states_to_select <- beedata %>% group_by(StateName) %>% filter(year >= lubridate::year(input$dateRange[1]) & year <= lubridate::year(input$dateRange[2])) %>% slice(1) %>% select(StateName)
        selectInput("stateSelection",
                    "States to Evaluate:",
                    choices = states_to_select, 
                    multiple = TRUE)
        
    })
    
    ####################
    # Logic for the main plot
    output$mainPlot <- renderPlot(execOnResize = TRUE, {
        width = session$clientData[["output_mainPlot_width"]]
        
        ##########
        # series of if statements to dynamically add components to the ggplot based on which variables the user selects with the checkboxes
        print(input$mainLegend)
        if(!is.null(input$stateSelection)) {
            print(input$stateSelection)
            beedata <- beedata %>% group_by(StateName) %>% filter(StateName == input$stateSelection)
        }
        if('total_pest_used' %in% input$mainLegend){
            total_pest_by_year <- beedata %>% group_by(state) %>% filter(year >= lubridate::year(input$dateRange[1]) & year <= lubridate::year(input$dateRange[2])) %>% mutate(nAllNeonic=sum(nAllNeonic, na.rm = TRUE)) %>% slice(1) %>% select(state, nAllNeonic)
            
            
            plot <- ggplot(total_pest_by_year, aes(state, nAllNeonic)) + geom_bar(stat="identity", color = "#ff0000", fill = "#FF6666") + stat_summary(fun.data=mean_cl_normal) + geom_smooth(method='lm', formula= y~x, color="black") +  scale_y_continuous(label=addUnits)
            
            plot <- plot + 
                labs(
                    title = "Total Pesticide Used",
                    caption = paste(c("Between the years of", lubridate::year(input$dateRange[1]), "and", lubridate::year(input$dateRange[2])), collapse = " ")
                ) +
                xlab("State") +
                ylab("Pounds of Pesticide") +
                theme(text=element_text(size=15 / 900 * width), axis.text.x = element_text(angle = 60, hjust = 1))
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
        if('total_honey_prod' %in% input$mainLegend){
            total_honey_prod <- beedata %>% group_by(state) %>% filter(year >= lubridate::year(input$dateRange[1]) & year <= lubridate::year(input$dateRange[2])) %>% mutate(totalprod=sum(totalprod, na.rm = TRUE)) %>% slice(1) %>% select(state, totalprod)
            
            
            plot <- ggplot(total_honey_prod, aes(state, totalprod)) + geom_bar(stat="identity", fill='gold', color='yellow') + stat_summary(fun.data=mean_cl_normal) + geom_smooth(method='lm', formula= y~x, color="black") +  scale_y_continuous(label=addUnits)
            
            plot <- plot + 
                labs(
                    title = "Total Honey Produced",
                    caption = paste(c("Between the years of", lubridate::year(input$dateRange[1]), "and", lubridate::year(input$dateRange[2])), collapse = " ")
                ) +
                xlab("State") +
                ylab("Pounds of Honey") +
                theme(text=element_text(size=15 / 900 * width), axis.text.x = element_text(angle = 60, hjust = 1))
        }
        if('pest_vs_honey' %in% input$mainLegend){
            total_pest_by_year <- beedata %>% group_by(state) %>% filter(year >= lubridate::year(input$dateRange[1]) & year <= lubridate::year(input$dateRange[2])) %>% mutate(nAllNeonic=conv_unit(sum(nAllNeonic, na.rm = TRUE), 'kg', 'lbs')) %>% slice(1) %>% select(state, nAllNeonic)
            total_honey_prod <- beedata %>% group_by(state) %>% filter(year >= lubridate::year(input$dateRange[1]) & year <= lubridate::year(input$dateRange[2])) %>% mutate(totalprod=sum(totalprod, na.rm = TRUE)) %>% slice(1) %>% select(state, totalprod)
            total_honey_and_pest <- left_join(total_pest_by_year, total_honey_prod, by = c("state" = "state"))
            
            plot <- ggplot(total_honey_and_pest, aes(x=state)) + geom_bar(aes(y=totalprod), stat="identity", position="identity", alpha=.3, fill='gold', color='yellow') +
                    geom_bar(aes(y=nAllNeonic), stat="identity", position="identity", alpha=.8, color = "#ff0000", fill = "#FF6666") +  scale_y_continuous(label=addUnits)
            
            plot <- plot + 
                labs(
                    title = "Total Pesticide Used VS Total Honey Produced",
                    caption = paste(c("Between the years of", lubridate::year(input$dateRange[1]), "and", lubridate::year(input$dateRange[2])), collapse = " ")
                ) +
                xlab("State") +
                ylab("Pounds") +
                theme(text=element_text(size=15 / 900 * width), axis.text.x = element_text(angle = 60, hjust = 1))
        }

        ##########
        # Some formatting to be done to the plot regardless of which variables are selected
        plot + 
            theme(
                plot.title = element_text( size = 14),    # Center title position and size
                plot.subtitle = element_text(size = 12),            # Center subtitle
                plot.caption = element_text(size = 20, face = "italic")# move caption to the left
            )
            
    })

})
