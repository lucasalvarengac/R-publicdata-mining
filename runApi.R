# setwd("~/Documents/TCDataMining/")

source("R/config.R", encoding = "UTF-8", local = TRUE)

pl <- plumb("mining/plumber.R")

plumber::pr_run(pl, port = 9600L, host = "0.0.0.0")