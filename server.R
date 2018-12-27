#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(geosphere)
library(dplyr)
library(plotly)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
     
     output$coords <- renderText({
          cities <- read.csv("world_cities.csv")
          
          lat <- input$lat_deg
          if (lat < 0) {
               lat <- lat - input$lat_min/60
          } else {
               lat <- lat + input$lat_min/60
          }
          lat <- min(90, lat)
          lat <- max(-90, lat)
          
          lon <- input$lon_deg
          if (lon < 0) {
               lon <- lon - input$lon_min/60
          } else {
               lon <- lon + input$lon_min/60
          }
          lon <- min(180, lon)
          lon <- max(-180, lon)
          
          paste("Your coordinates are:        LAT: ",round(lat, digits = 3),"    LON: ",round(lon, digits=3))

     })     
     
     
  output$cityplot <- renderPlotly({
       cities <- read.csv("world_cities.csv")
       
       lat <- input$lat_deg
       if (lat < 0) {
            lat <- lat - input$lat_min/60
       } else {
            lat <- lat + input$lat_min/60
       }
       lat <- min(90, lat)
       lat <- max(-90, lat)
       
       lon <- input$lon_deg
       if (lon < 0) {
            lon <- lon - input$lon_min/60
       } else {
            lon <- lon + input$lon_min/60
       }
       lon <- min(180, lon)
       lon <- max(-180, lon)
       
       
       distances <- distHaversine(c(lon,lat), as.matrix(cities[,c(5,4)]))/1000
       
       cities$Distances <- distances
       subcities <- arrange(cities, Distances)
       subcities <- subcities[1:input$numcities,]
       subcities$City <- as.character(subcities$City)
       subcities$Country <- as.character(subcities$Country)

       xlabel <- "Distance (in Kms)"
       if (input$units=="miles") {
            subcities$Distances <- subcities$Distances/(1.60934)
            xlabel <- "Distance (in miles)"
       }
       subcities$Distances <- round(subcities$Distances, digits = 1)
       
       
       ### Plot generation

       plot_ly(x = subcities$Distances, y = subcities$Population, type = 'scatter', mode = 'markers', 
               color = subcities$Country, size = subcities$Population, 
               text = paste("City: ",subcities$City,'<br>Country:', subcities$Country,'<br>Pop:', subcities$Population, 
                            '<br>Dist:', subcities$Distances,' ',input$units)) %>%
            layout(title = "Nearest cities to your point",
                   xaxis = list(title = xlabel),
                   yaxis = list(title = "Population"))
       
  })
})