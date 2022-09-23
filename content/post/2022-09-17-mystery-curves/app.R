library(tidyverse)
library(shiny)
#library(gganimate)
#library(gifski)

theme_set(theme_bw())

ui <- basicPage(
  sliderInput("a", "amplitude :",
              min = 0, max = 1,
              value = 1),
  sliderInput("b", "frequency :",
              min = 0, max = 1,
              value = 1),
  sliderInput("c", "phase:",
              min = 0, max = 1,
              value = 0),
  h5("circle <- function(amp, freq, phase) amp*1i^(freq*seq(0,600,l=260)+phase)"), 
  
  imageOutput("plot"))

server <- function(input, output) {
  circle <- function(amp, freq, phase) amp*1i^(freq*seq(0, 600, l=260) + phase)

  session <- reactiveValues()
  session$step = 0
  session$timer <- reactiveTimer(30)
  observeEvent(session$timer(),{
    forward()
  })

  forward = function(){
    session$step = session$step + 1/500
    session$arg = session$step*5
    len = sin(pi*(2*session$arg - .5)) + 1
    session$z <- circle(input$a, input$b, input$c) + 
      circle(len, ceiling(session$arg), -8*session$arg) + 
      circle(len/2-1, ceiling(((-session$arg+2.5)%%5)-5), -4*session$arg) 
  }
  
  #output$plot <- renderPlot({
   # limits = 3.5*c(-1,1)
    #par(mar=c(0,0,0,0), bg="#000000")
    #hue = (session$arg + (Re(session$z/10)))%%1
    #plot(session$z, 
    #     col = hsv(hue, 0.65, 1), 
    #     pch=20, lwd=1, cex=1.5, type="p", axes=F, 
    #     xlim = limits, ylim = limits)
    #z2 <- c(session$z[-1], session$z[1])
    #segments(Re(session$z), Im(session$z), Re(z2), Im(z2), col = hsv(hue, 0.65,1,.1), pch=20, lwd=1)
  #})
  
  output$plot <- renderPlot({
    hue = (session$arg + (Re(session$z/10)))%%1
    session$z %>% as.tibble() %>%
      mutate(x = Re(value)) %>%
      mutate(y = Im(value)) %>% ggplot() +
      aes(x = x, y = y, colour = hsv(hue, 0.65, 1)) +
      scale_colour_identity() +
      geom_point()
    #limits = 3.5*c(-1,1)
    #par(mar=c(0,0,0,0), bg="#000000")
    #
    #plot(, 
    #     col = hsv(hue, 0.65, 1), 
    #     pch=20, lwd=1, cex=1.5, type="p", axes=F, 
    #     xlim = limits, ylim = limits)
    #z2 <- c(session$z[-1], session$z[1])
    #segments(Re(session$z), Im(session$z), Re(z2), Im(z2), col = hsv(hue, 0.65,1,.1), pch=20, lwd=1)
  })
}

shinyApp(ui, server)

# renderImage