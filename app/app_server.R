library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(lintr)
library(styler)
library(zoo)

style_file("app_server.R")
lint("app_server.R")

stock_data <- read.csv("TSLDATA.csv")

server <- function(input, output) {
  output$stockData <- renderPlotly({
    select_stock <- input$stock

    stock_data_choice <- stock_data %>%
      filter(date <= "2018-02-07" & date >= "2016-02-07") %>%
      filter(Name == select_stock) %>%
      select(date, Name, open, close, high, low)

    mainPlot <- stock_data_choice

    colorfun <- input$color

    mainPlot <- mainPlot %>%
      plot_ly(
        x = ~date,
        type = "candlestick",
        open = ~open,
        close = ~close,
        high = ~high,
        low = ~low
      ) %>%
      layout(
        title = "Stock Chart",
        xaxis = list(title = "Years"),
        yaxis = list(title = "Value of Stock (USD)")
      )



    mainPlot
  })

  output$stockhighlow <- renderPlotly({
    select_stock <- input$stock
    colorfun <- input$color

    stock_data_choice <- stock_data %>%
      filter(date <= "2018-02-07" & date >= "2016-02-07") %>%
      filter(Name == select_stock) %>%
      select(date, Name, open, close, high, low)

    second_plot <- stock_data_choice

    second_plot <- second_plot %>%
      plot_ly(
        x = ~low,
        y = ~high,
        color = I(colorfun),
        type = "scatter"
      ) %>%
      layout(
        title = "Correlation between the highest and Lowest Prices
        for Stocks",
        xaxis = list(title = "Lowest Value of Stock"),
        yaxis = list(title = "Highest Value of Stock")
      )
  })

  output$third_plot <- renderPlotly({
    select_stock_3 <- input$stock3
    select_moving_avg1 <- input$moving_avg1

    watchlist_data <- stock_data %>%
      group_by(Name) %>%
      select(date, Name, open, close, high, low) %>%
      mutate(
        fifty_day_MA = rollmean(close, k = 50, fill = NA, align = "right"),
        two_hundred_day_MA = rollmean(close, k = 200, fill = NA, align = "right")
      )

    watchlist_data <- watchlist_data %>%
      filter(date == "2018-02-07") %>%
      mutate(moving_average_ratio = two_hundred_day_MA / fifty_day_MA) %>%
      select(Name, moving_average_ratio) %>%
      arrange(abs(moving_average_ratio - 1))

    SMA_data <- stock_data %>%
      filter(Name == select_stock_3) %>%
      select(date, Name, open, close, high, low) %>%
      mutate(
        ten_day_MA = rollmean(close, k = 10, fill = NA, align = "right"),
        twenty_day_MA = rollmean(close, k = 20, fill = NA, align = "right"),
        fifty_day_MA = rollmean(close, k = 50, fill = NA, align = "right"),
        hundred_day_MA = rollmean(close, k = 100, fill = NA, align = "right"),
        two_hundred_day_MA = rollmean(close, k = 200, fill = NA, align = "right")
      )


    third_plot <- SMA_data %>%
      plot_ly(
        x = ~date,
        type = "candlestick",
        open = ~open,
        close = ~close,
        high = ~high,
        low = ~low
      )

    third_plot <- third_plot %>%
      add_lines(y = ~fifty_day_MA, name = "50 Day Moving Average")
    third_plot <- third_plot %>%
      add_lines(y = ~two_hundred_day_MA, name = "200 Day Moving Average")
  })

  output$table <- renderTable(watchlist_data)
}
