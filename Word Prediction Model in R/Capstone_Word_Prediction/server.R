library(shiny)
library(RWeka)
library(dplyr)
library(ggplot2)
library(stringr)
library(markovchain)

set.seed(423)

unitbl <- read.csv("data/unitbl.csv")
bitbl <- read.csv("data/bitbl.csv")
tritbl <- read.csv("data/tritbl.csv")
source("helper.R")

## ----------------------------
shinyServer(function(input, output, session){
  
  output$words <- {(
    renderText(input$userInput)
  )}
  
  preds <- reactive({
    ngram <- trimws(input$userInput)
    preds <- model2(ngram, unitbl, bitbl, tritbl, input$numSugs)
    preds
  })
  
  output$preds <- renderText({
    preds()
  })
  
}
)