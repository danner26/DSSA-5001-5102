#! /usr/bin/env Rscript
# This R script reads a column of data points from the standard
# input using $ ./explore.r < filename.dat
# and calculates various statistical parameters and also creates 
# a histogram graphic.
library(tidyverse)
library(readr)
library(tibble)

setwd("~/dssa_workspace/DSSA5001/Week8/")

png("boxplot.png")
d<-scan("streams_clean.csv")#"stdin", quiet=TRUE)
cat("Minimum = ",min(d),"\n")
cat("Maximum = ",max(d),"\n")
cat("Median  = ",median(d),"\n")
cat("Mean    = ",mean(d),"\n")
summary(d)
stem(d)
boxplot(d)

png("histogram.png")
streams_clean <- read_csv("data.csv")
ggplot(data = streams_clean, aes(x = Streams)) +
  geom_histogram() +
  labs(title = "Spotify Streams - Histogram",
       x = "Streams")

png("loghistogram.png")
ggplot(streams_clean, aes(x = Streams)) + geom_histogram() + 
  scale_x_log10() +
  labs(title = "Spotify Streams - Logarithm Histogram",
       x = "Streams")
