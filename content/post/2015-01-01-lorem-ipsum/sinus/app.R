library(tidyverse)
library(shiny)
library(gganimate)
theme_set(theme_bw())

ui <- basicPage(
  sliderInput("a", "amplitude :",
              min = 0, max = 10,
              value = 1),
  sliderInput("b", "period :",
              min = 0, max = 100,
              value = 1),
  sliderInput("c", "phase shift:",
              min = 0, max = 10,
              value = 0),
  sliderInput("d", " vertical shift :",
              min = 0, max = 1,
              value = 0),
  h5("y = A sin(B(x + C)) + D"), 
  
  imageOutput("plot"))

server <- function(input, output) {
  session <- reactiveValues()
  
  session$timer <- reactiveTimer(30)
  observeEvent(session$timer(),{
    forward()
  })
  
  session$i = 0
 forward = function(){
   session$tbl <- tibble(x = seq(0, 3*pi, l = 100)) %>% 
      mutate(x = session$i * 0.01  + x) %>%
      mutate(y = input$a * sin(input$b * (x + input$c)) + input$d)
   session$i = session$i + 1
     }
 
  output$plot <- renderPlot({

    plot(session$tbl, type = "l")
  })
    }

shinyApp(ui, server)

# renderImage