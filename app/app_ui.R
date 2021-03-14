library(stringr)
library(tidyr)
library(tidyverse)
library(ggplot2)
library(lintr)
library(styler)
library(plotly)
style_file("app_ui.R")
lint("app_ui.R")

stock_data <- read.csv("TSLDATA.csv")

chosen_stock <- unique(stock_data$Name)
chosen_stock_pg3 <- unique(stock_data$Name)

moving_average_choices <- c(
  "ten_day_MA", "twenty_day_MA",
  "fifty_day_MA", "hundred_day_MA",
  "two_hundred_day_MA"
)

# Making the color choices for the first page
color_choices <- c(
  "red", "blue", "pink", "forestgreen",
  "grey", "black", "yellow", "purple"
)


# Introduction page
page_one <- tabPanel(
  "Introduction Page",

  titlePanel("Introduction"),
)

page_two <- tabPanel(
  "Second Page",
  titlePanel("Candlestick Chart"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "stock",
        label = "Please Select a Stock:",
        choices = chosen_stock
      ),
      selectInput(
        inputId = "color",
        label = "Color Choice: ",
        choices = color_choices
      )
    ),

    mainPanel(
      h3("Stock Data"),
      plotlyOutput("stockData"),
      plotlyOutput("stockhighlow")
    )
  )
)

page_three <- tabPanel(
  "Third Page",
  titlePanel("Moving Averages Plot"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "stock3",
        label = "Choose a stock",
        choices = chosen_stock_pg3
      ),
      selectInput(
        inputId = "moving_avg1",
        label = "choose moving averages ",
        choices = moving_average_choices
      )
    ),

    mainPanel(
      plotlyOutput("third_plot"),
      tableOutput("table")
    )
  )
)

page_four <-
  tabPanel(
    "Forth Page",
    titlePanel("stock variable bar plot"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "variable",
          label = "variable displayed",
          choices = col_names
        ),
        selectInput(
          inputId = "color_var",
          label = "color of bar",
          choices = c("blue", "red", "green", "purple")
        )
      ),
      mainPanel(
        h3("stock variable"),
        plotlyOutput(outputId = "plot_data")
      )
    )
  )



ui <- navbarPage(
  "Final Deliverable",
  page_one,
  page_two,
  page_three,
  page_four
)
