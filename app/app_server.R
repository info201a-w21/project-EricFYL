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
toptech <- read.csv("TSL.csv")

server <- function(input, output) {
  output$stock_data1 <- renderPlotly({
    select_stock <- input$stock

    stock_data_choice <- stock_data %>%
      filter(date <= "2018-02-07" & date >= "2016-02-07") %>%
      filter(Name == select_stock) %>%
      select(date, Name, open, close, high, low)

    main_plot <- stock_data_choice

    colorfun <- input$color

    main_plot <- main_plot %>%
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
  })

  output$stockhighlow <- renderPlotly({
    select_stock <- input$stock
    colorfun <- input$color

    stock_data_choice <- stock_data %>%
      filter(date <= "2018-02-07" & date >= "2016-02-07") %>%
      filter(Name == select_stock) %>%
      select(date, Name, open, close, high, low)

    second_plot <- stock_data_choice

    # Creating plot
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
    select_moving_avg2 <- input$moving_avg2


    # Mutating the data to add moving averages
    # Moving averages were calculated with a library
    sma_data <- stock_data %>%
      filter(Name == select_stock_3) %>%
      select(date, Name, open, close, high, low) %>%
      mutate(
        moving_avg_1 = rollmean(close,
          k = as.numeric(select_moving_avg1),
          fill = NA, align = "right"
        ),
        moving_avg_2 = rollmean(close,
          k = as.numeric(select_moving_avg2),
          fill = NA, align = "right"
        )
      )

    # Creating plot
    third_plot <- sma_data %>%
      plot_ly(
        x = ~date,
        type = "candlestick",
        open = ~open,
        close = ~close,
        high = ~high,
        low = ~low
      ) %>%
      layout(
        title = "Moving Average Chart",
        xaxis = list(title = "Date"),
        yaxis = list(title = "Stock Price")
      )

    # Adding Moving Average lines
    third_plot <- third_plot %>%
      add_lines(
        y = ~moving_avg_1,
        name = "Moving Average 1"
      )
    third_plot <- third_plot %>%
      add_lines(y = ~moving_avg_2, name = "Moving Average 2")
  })

  # Creating the watchlist dataframe by
  # adding the two most important moving averages
  watchlist_data <- stock_data %>%
    group_by(Name) %>%
    select(date, Name, open, close, high, low) %>%
    mutate(
      fifty_day_MA = rollmean(close, k = 50, fill = NA, align = "right"),
      two_hundred_day_MA = rollmean(close,
        k = 200,
        fill = NA, align = "right"
      )
    )
  # Filtering by the most recent date because that's what we want to analyze,
  # creating a new column with the ratio between moving averages, and
  # arranging the by the closest to a 1:1 ratio
  watchlist_data <- watchlist_data %>%
    filter(date == "2018-02-07") %>%
    mutate(moving_average_ratio = two_hundred_day_MA / fifty_day_MA) %>%
    select(Name, moving_average_ratio) %>%
    arrange(abs(moving_average_ratio - 1))
  output$table <- renderTable(watchlist_data)

  output$plot_data <- renderPlotly({
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

    plot_data <- chart2data
    stock_price_plot <- ggplot(data = plot_data) +
      geom_bar(aes(x = Name, y = chart2data[[input$variable]]),
        size = 1, fill = input$color_var, stat = "identity"
      ) +
      theme(axis.text.x = element_text(angle = 20)) +
      labs(
        title = "Stock variable chart",
        x = "Company name", y = input$variable
      )
    ggplotly(stock_price_plot)
  })
}
