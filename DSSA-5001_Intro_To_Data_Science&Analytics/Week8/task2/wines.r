#! /usr/bin/env Rscript

library(tidyverse, readr, tibble)
library(Hmisc)
setwd("~/dssa_workspace/DSSA5001/Week8/task2")

redwine = read.csv("winequality-red_clean.csv", header = TRUE)
whitewine = read.csv("winequality-white_clean.csv", header = TRUE)

summary(redwine)
summary(whitewine)

redwine.cor = cor(redwine)
whitewin.cor = cor(whitewine)

redwine.rcorr = rcorr(as.matrix(redwine))
redwine.rcorr

whitewine.rcorr = rcorr(as.matrix(redwine))
whitewine.rcorr
