library(stringr)
library(tidyverse)
library(tidyr)
library(ggplot2)

TopTech <- read.csv("TSL.csv", header = TRUE)

assigning <- function(n) {
  if (n > 0.01) {
    return("Greater than 1% gain")
  } else if (n < 0.01 & n > 0) {
    return("Less than 1% gain")
  } else if (n < -0.01) {
    return("More than 1% loss")
  } else if (n > -0.01 & n < 0) {
    return("Less than 1% loss")
  }
}

percent_change <- sapply(TopTech$X..Change, assigning)
percent_change <- data.frame(percent_change)

TopTech <- TopTech %>% 
  mutate(n = row_number())

percent_change <- percent_change %>% 
  mutate(n = row_number())

top_tech_with_percent <- left_join(TopTech, percent_change)

table <- top_tech_with_percent %>% 
  group_by(percent_change) %>% 
  summarise(number = n())

prop.table(table(table))
