# this chart ranked the change of the companies
# we can see what companies have their prices increased or decreased the most


library(stringr)
library(tidyverse)
library(tidyr)
library(ggplot2)

toptech <- read.csv("TSL.csv", header = TRUE)

<<<<<<< HEAD
candname<- ggplot(toptech,aes(x=reorder(Name,Change),y=Change,fill="")) + 
  geom_bar(stat='identity')+labs(y="change",x="Names")
print(candname + coord_flip())
=======
candname <- ggplot(toptech, aes(x = reorder(Name, Change), y = Change)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(y = "price change", x = " company names") +
  ggtitle("Price changes for the top 100 tech companies") +
  theme(text = element_text(size = 7.5)) +
  scale_x_discrete(labels = abbreviate)
candname + coord_flip()
>>>>>>> b0aebfecdb337f1e9e0a2f4dd3813d628ab48e80
