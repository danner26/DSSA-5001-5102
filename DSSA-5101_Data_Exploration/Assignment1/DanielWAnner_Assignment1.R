library(readr)
library(tibble)
setwd('/home/rstudio/dssa_workspace/R/Assignment1')

data = read_csv('fish.csv')
glimpse(data)
summary(data)
dim(data)
nrow(data)
str(data)
head(data)