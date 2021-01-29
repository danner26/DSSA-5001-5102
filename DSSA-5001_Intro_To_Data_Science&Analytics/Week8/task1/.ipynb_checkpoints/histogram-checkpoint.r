#! /usr/bin/env Rscript

png("histogram.png")
library(tidyverse)
library(readr)
library(tibble)
streams_clean <- read_csv("./data.csv")
ggplot(data = as_tibble(streams_clean), aes(x="Streams")) +
  geom_bar() +
  labs(title = "Spotify Streams",
       x = "Streams")
