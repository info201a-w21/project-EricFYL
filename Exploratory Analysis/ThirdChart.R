# This chart looks at the relationship between average volume and the price per share of
# A stock. I think that this might be an interesting relationship because companies with a
# higher marketcap generally have a higher price per share, and there large marketcap companies
# are traded usually with more volume because of how important and recognizable they are.
# Another factor that goes into this relationship is that some retail investors can't afford
# to buy some highly priced stocks, so that might drive the volume down. Additionally,
# cheaper stocks are bought in larger quantities, which would drive the volume down for higher priced stocks
# Either way, I think it might be interesting to see.

library(stringr)
library(tidyverse)
library(tidyr)
library(ggplot2)

tech_companies <- read.csv("TSL.csv", header = TRUE)

price_vs_volume <- ggplot(tech_companies, aes(x = Price, y = Avg.Vol)) + 
  geom_point() + geom_smooth(method=lm, se=FALSE)

print(price_vs_volume + ggtitle("Relationship Between Stock Price and Avg. Volume"))
