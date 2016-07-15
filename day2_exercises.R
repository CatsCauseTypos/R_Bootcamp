---
title: "R_bootcamp_day2_exercises"
author: "Donnelly West"
date: "September 15, 2015"
output: html_document
---
#loading data
  
  #check working directory
  getwd()

  #set / change working directory
  setwd("~/Desktop/R_bootcamp/")
  #remember:
  # setwd("/") takes you forward (use tab-complete)
  # setwd("..") takes you backward one folder

flights = readRDS("flights.RDS")

str(flights)

# (more info:http://stat-computing.org/dataexpo/2009/the-data.html)
# Get a sense for what the size of the data and what it represents using str, summary, and/or head: What spatial and temporal domain do they cover?

range(flights$year)
#2012-2013

range(flights$month)
#Jan-Dec

#1.How many flights are there in the dataset?
#```{r}

#336776
#I googled it
#```
count(flights$fl_num) #error no applicable method for group_by
?count() #ooohhhh, in dplyr, it's a by_group thing. 
head(flights)
str(flights)
count(flights$air_time) #same error: count is useless

# 2.Which airline has the most flights? The least?
# ```{r}
flights %>% 
  group_by(carrier, fl_num) %>% 
  mutate(num_fls = count())
#```

#3. How many airlines fly from LAX to SFO?

