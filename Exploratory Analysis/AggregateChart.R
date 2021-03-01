library(stringr)
library(tidyverse)
library(tidyr)
library(ggplot2)
library(data.table)
setwd("/Users/samcooke/Desktop/project-EricFYL/Exploratory Analysis")
top_tech <- read.csv("TSL.csv", header = TRUE)

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

percent_change <- sapply(top_tech$X..Change, assigning)
percent_change <- data.frame(percent_change)

top_tech <- top_tech %>%
  mutate(n = row_number())

percent_change <- percent_change %>%
  mutate(n = row_number())

top_tech_with_percent <- left_join(top_tech, percent_change)

table <- top_tech_with_percent %>%
  group_by(percent_change) %>%
  summarise(number = n())
table <- data.table(table)
print(table)
