#this chart ranked the change of the companies
#we can see what companies have their prices increased or decreased the most


library(stringr)
library(tidyverse)
library(tidyr)
library(ggplot2)

toptech <- read.csv("TSL.csv", header = TRUE)

candname<- ggplot(toptech,aes(x=reorder(Name,Change),y=Change,fill="")) + 
  geom_bar(stat='identity')+labs(y="change",x="Names")
candname + coord_flip()
