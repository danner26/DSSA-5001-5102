#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
#thematic::thematic_shiny(font = "auto")
library(bslib)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # Load theme
    theme = bs_theme(bootswatch = "darkly"),

    # Application title
    titlePanel("US Honey & Pesticides"),


    
    ####################
    # Split between the main plot and radio buttons on the right to toggle features
    fluidRow(
        column(
               width = 10,
               plotOutput('mainPlot')),
        column(
               width = 2,
               radioButtons("mainLegend", "Graph Type:",
                            c('Pesticide Used'='avg_pest_used',  'Pesticide Used Map'='total_all_neonic_map', 'Total Honey Prod Map'='total_honey_prod_map')))
    ),
    
    
    ####################
    # The date range widget, dynamically effects all other widgets
    fluidRow(
        column(6,
               dateRangeInput("dateRange",
                              "Date Range:",
                              start = "1995-01-01",
                              startview="decade", format="yyyy"))
    ),
    
    ####################
    # The Indoor vs Outdoor Speed plot
    #fluidRow(
    #    column(12,
    #           plotOutput('indoor_vs_outdoor_plot'))
    #)
))
