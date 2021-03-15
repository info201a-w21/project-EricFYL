library(stringr)
library(tidyr)
library(tidyverse)
library(ggplot2)
library(lintr)
library(styler)
library(plotly)
library(shinythemes)
lint("app_ui.R")
stock_data <- read.csv("TSLDATA.csv")
toptech <- read.csv("TSL.csv")

# choices for 1st page widget
chosen_stock <- unique(stock_data$Name)

# choices for 2nd page widget
chosen_stock_pg3 <- unique(stock_data$Name)


# Making the color choices for the first page
color_choices <- c(
  "red", "blue", "pink", "forestgreen",
  "grey", "black", "yellow", "purple"
)


# Introduction page
intro_page <- tabPanel(
  "Introduction Page",
  img(
    src = "https://i.redd.it/489ohv5xzvf31.jpg",
    height = "50%", width = "50%"
  ),
  titlePanel("Introduction"),
  p("With the movement in the stock market in the past few months,
    we thought that it might be interesting to analyze some of the
    patterns that occur in the data. Analyzing historic stock data
    is common in the financial sector, and is called technical
    analysis, or TA. There are a variety of indicators that people use
    to find a good entry point in different stocks, so we decided to take
    a look at those and try it ourselves. We also wanted to answer some
    questions, like answering what the relationship between the volume and
    P/E ratios of stocks are, and other variables, and also what the
    relationship is between variability and price of a stock is. We think
    that all of these questions are pertinent to what happens on Wall
    Street on a daily basis, and want to learn more.")
)
# 1st page
page_one <- tabPanel(
  "First Page",
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
      p("With the first page, we wanted to take a look at how variable the
      stock was depending on how highly priced it was. We did this by creating
      a chart that shows the highs vs lows of the day for an individual stock.
      We did it this way because it made it much easier to look at the data
      with fewer datapoints and less noise. On this page, we also included a 2
      year chart of the stocks, so that the reader could get a better idea
      of what theyre looking at, because the scatterplot is hard to read
      if you don't know what its analyzing."),
      plotlyOutput("stock_data1"),
      plotlyOutput("stockhighlow")
    )
  )
)

# 2nd page
page_two <- tabPanel(
  "Second Page",
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
      p("The second indicator we took a look at is called a moving average,
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
      plotlyOutput("third_plot"),
      tableOutput("table")
    )
  )
)

choice <- toptech %>%
  select(
    Price, Volume, PE.Ratio, Change
  )

col_names <- colnames(choice)

page_three <- tabPanel(
  "Third Page",
  titlePanel("Stock Variable Bar Plot"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "variable",
        label = "Variable Displayed",
        choices = col_names
      ),
      selectInput(
        inputId = "color_var",
        label = "Color of Bar",
        choices = c("blue", "red", "green", "purple")
      ),
      sliderInput(
        inputId = "top_num_choice",
        label = "Number of Companies:",
        min = 1, max = 50, value = 5
      )
    ),
    mainPanel(
      h3("stock variable"),
      p("The third indicator we took a look at is the price, volume, change,
      and PE ratio of the top 100 tech companies, we want to find out if there
      are any relations between any two of them. In order to do that, we grouped
      all companies into two groups by price and made two charts in order to make
      it easier to compare, the top variable chart which includes the 50 companies
      with highest prices and the bottom variable chart which includes the other 50
      companies with lower prices. We made it available for users to pick their own
      sample size, they can choose to have top and bottom 5 or 10(any number from
      1-50 since there are 100 in total) companies ranked by price.
      By changing the variable displayed, we can find out if there are relationships
      between variables, we can answer questions like do higher prices always lead
      to higher PE ratio? Does volume depend on  prices? Do companies with high
      prices have a lower possibility of having negative changes? We wanted to
      find out things like these and that's the purpose of us making those two
      variable charts."),
      plotlyOutput(outputId = "plot_data"),
      plotlyOutput(outputId = "plot_data2")
    )
  )
)


takeaways_page <- tabPanel(
  "Summary Takeaways",
  titlePanel("Takeaways"),
  p("With the first page, we found that generally that stocks tend to be
    more variable at their lowest prices, and also at their highest prices.
    This makes sense because if you look at the chart above, you can see
    that the stock often pulls back when it is overextended either way.
    This means that when it is super high, it is more variable because
    it either jumped up and pulled back within the span of a couple of days,
    and when it is low, it did the opposite, where the stock price heavily
    decreased over the span of a few days and increased heavily over the next
    few. We think this happens because at a certain point, buying pressure
    will eventually overpower selling pressure and vice versa, and cause
    a large spike in either direction."),
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
  p("In the fourth page, after comparing several variables for both top
    and bottom charts, we found out that most of the companies with higher
    prices have higher PE ratios, which makes sense since
    PE ratio = price /earning, top chart(higher price companies)
    have more companies with negative changes compared to bottom chart
    (lower price companies) no matter what the sample size is, it could
    be because prices tend to increase since there is not a lot of room
    for those low price companies to decrease anymore. It looks like the
    volume does not have a lot to do with the price. But the biggest
    takeaway we found in those two charts is that there are no guaranteed
    relationships between any two of those four variables. There could be
    one variable tends to lead to a result but it's never 100%.")
)

# Building navbar with all pages
ui <- navbarPage(
  theme = shinytheme("superhero"),
  "Final Deliverable",
  intro_page,
  page_one,
  page_two,
  page_three,
  takeaways_page
)
