library(shiny)

shinyUI(fluidPage(
  titlePanel("Word Prediction Text"),
  sidebarLayout(
    position="right",
    sidebarPanel(
      sliderInput("numSugs", "Number of Suggestions", min=1, max=5, value=3)
    ),
    
    mainPanel(
      p("Input text and see what words the algorithm suggests."),
      textInput("userInput", "Input Text Here"),
      textOutput("words"),
      h2("Suggested Words"),
      textOutput("preds")
    )
  )
))
