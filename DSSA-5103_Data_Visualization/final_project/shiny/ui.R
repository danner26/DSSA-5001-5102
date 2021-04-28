#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
thematic::thematic_shiny(font = "auto")
library(bslib)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # Load theme
    theme = bs_theme(bootswatch = "darkly"),
    tags$head(tags$style('body {color:#FFD700; font-size: 15px;}')),

    # Application title
    titlePanel("US Honey & Pesticide Data"),
    
    #Right side toggles (radio buttons)
    fluidRow(
        column(
               width = 10,
               plotOutput('mainPlot')),
        column(
               width = 2,
               radioButtons("mainLegend", "Graph Type:",
                            c('Pesticide Used'='total_pest_used', 'Total Honey Production'='total_honey_prod', 'Pesticide Used VS Honey Production'='pest_vs_honey', 'Pesticide Used Map'='total_all_neonic_map', 'Total Honey Prod Map'='total_honey_prod_map')))
    ),
    
    #Date Range (using decades to only show years)
    #TODO: Find a way to make selection only for year
    fluidRow(
        column(6,
               uiOutput('date_selection')),
        column(6, uiOutput('select_field'))
    )
))
