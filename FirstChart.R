# This chart displays that when the price is high for a stock,
# they would have more change as for stocks with
# lower price have the chance to be volatile. 

library(stringr)
library(tidyverse)
library(tidyr)
library(ggplot2)

toptech <- read.csv("TSL.csv", header = TRUE)

head(toptech)

price_change <- ggplot(toptech, aes(x = Price, y = Change)) + 
  geom_line()

print(price_change + ggtitle("Price Change between high and low stocks"))

