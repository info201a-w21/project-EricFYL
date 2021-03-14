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

# choices for 2nd page widget
chosen_stock <- unique(stock_data$Name)

# choices for 3rd page widget
chosen_stock_pg3 <- unique(stock_data$Name)


# Making the color choices for the first page
color_choices <- c(
  "red", "blue", "pink", "forestgreen",
  "grey", "black", "yellow", "purple"
)


# Introduction page
page_one <- tabPanel(
  "Introduction Page",

  titlePanel("Introduction"),
  p("     With the movement in the stock market in the past few months,
    we thought that it might be interesting to analyze some of the
    patterns that occur in the data. Analyzing historic stock data
    is common in the financial sector, and is called technical
    analysis, or TA. There are a variety of indicators that people use
    to find a good entry point in different stocks, so we decided to take
    a look at those and try it ourselves."),
  p("     The first of indicators we took a look at is called the ."),
  p("     The second indicator we took a look at is called a moving average, 
    which is an average of the stock price over a certain period of time.
    These can be short-term, like over the span of a couple days, which makes
    the line more jagged and follow every single change in the stock. They
    can also be longer term, like over the span of 200 days or more.
    These longer tend to be less changed by daily movements and are more
    smooth, which makes sense because each data point has less potential to
    change the entire average. What is interesting is when two cross,
    which is either called a golden cross or a death cross. The reason for
    this being that they are both long term bullish and bearish indicators
    respectively. When a short term moving average crosses the longer 
    moving average on an uptrend, this is called a golden cross, and indicates
    that selling is mostly depleted and that there is a long bull market
    incoming. The death cross is the opposite of this, and indicates a bear
    market for that particular security. In the second page of analysis,
    we take a look at the moving averages and specifically which ones are
    close."),
  p("")
)

# 2nd page
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
      plotlyOutput("stock_data1"),
      plotlyOutput("stockhighlow")
    )
  )
)


# 3rd page
page_three <- tabPanel(
  "Third Page",
  titlePanel("Moving Averages Plot"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "stock3",
        label = "Please Select a Stock",
        choices = chosen_stock_pg3
      ),
      sliderInput(
        inputId = "moving_avg1",
        label = "Please Select a Moving Average:",
        min = 1, max = 500, value = 50
      ),
      sliderInput(
        inputId = "moving_avg2",
        label = "Please Select a Second Moving Average:",
        min = 1, max = 500, value = 200
      )
    ),

    mainPanel(
      plotlyOutput("third_plot"),
      tableOutput("table")
    )
  )
)

chart2data <- toptech %>%
  arrange(desc(Price)) %>%
  slice(1:5, 96:100) %>%
  select(
    Name, Price, Volume, PE.Ratio, Change
  )
choice <- chart2data %>%
  select(
    Price, Volume, PE.Ratio, Change
  )
col_names <- colnames(choice)
page_four <- tabPanel(
  "Fourth Page",
  titlePanel("Stock Variable Bar Plot"),
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

page_five <- tabPanel(
  "Summary Takeaways",
  titlePanel("Takeaways"),
  p(""),
  p("With the dataframe that we created, we are able to see which stocks
    have 50 Day and 200 Day moving averages that are closest together, and
    with the chart we are able to look at those stocks and see if they are
    on the uptrend or downtrend. With up to date data, we could use this to
    find good entry points on stocks that are on the uptrend, or to short
    stocks that have made a death cross. Using one of the top tickers on our
    list K as an example, we can see whether the uptrend continued because 
    the latest datapoint was from 2018, to see whether this was a good buy.
    If we bought this at the closing price of 66.84 on 02/07/2018, we could
    have had the opportunity to sell at 75 only a couple months later,
    which is a decent return. While I would have liked to see a larger
    % change, this shows that it can be a powerful tool."),
  p("")
)

# Building navbar with all pages
ui <- navbarPage(
  "Final Deliverable",
  page_one,
  page_two,
  page_three,
  page_four,
  page_five
)
