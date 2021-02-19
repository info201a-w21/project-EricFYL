# This chart looks at the relationship between PE ratio and Price per share to see whether
# they are correlated even with the extremely expensive stocks.

library(stringr)
library(tidyverse)
library(tidyr)
library(ggplot2)

tech_companies <- read.csv("TSL.csv", header = TRUE)

ggplot(tech_companies, aes(x = PE.Ratio, y = Price)) + 
  geom_point() + geom_smooth(method=lm, se=FALSE)

ggplot(tech_companies, aes(x = PE.Ratio, y = Market.Cap..Billions.)) + 
  geom_point() + geom_smooth(method=lm, se=FALSE)

# This additional chart shows that there is little correlation between a large PE Ratio and 
# actual market cap, so there are definitely more important measures of value.