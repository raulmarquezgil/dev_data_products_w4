#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Find the nearest cities to your location"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(width = 4,
       sliderInput("lat_deg",
                   "Latitude Degress:",
                   min = -90,
                   max = 90,
                   value = 0,
                   step=1),
       sliderInput("lat_min",
                   "Latitude Minutes:",
                   min = 0,
                   max = 59,
                   value = 0,
                   step=1),
       br(),br(),
       sliderInput("lon_deg",
                   "Longitude Degress:",
                   min = -180,
                   max = 180,
                   value = 0,
                   step=1),
       sliderInput("lon_min",
                   "Longitude Minutes:",
                   min = 0,
                   max = 59,
                   value = 0,
                   step=1),
       br(),br(),
       numericInput(inputId = "numcities",
                    label = "Number of cities to show:",
                    value = 10,
                    min=1,
                    max=20,
                    step=1),
       selectInput(inputId = "units",
                   label = "Choose units:",
                   choices = c("kms", "miles"))
    ),

    # Show a plot of the generated distribution
    mainPanel(width = 8,
    textOutput("coords"),
    br(),
    plotlyOutput("cityplot", height = "650px")
    )
  )
))
