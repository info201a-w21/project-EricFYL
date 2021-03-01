library(stringr)
library(tidyverse)
library(tidyr)
library(ggplot2)
library(lintr)

tech_companies <- read.csv("TSL.csv", header = TRUE)

price_vs_volume <- ggplot(tech_companies, aes(x = Price, y = Avg.Vol)) +
  geom_point() + geom_smooth(method = lm, se = FALSE)

print(price_vs_volume +
        ggtitle("Relationship Between Stock Price and Avg. Volume"))
