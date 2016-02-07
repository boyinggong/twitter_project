getwd()
setwd("C:/Users/Tomofumi/Documents/Class/spring/capstone/project1/twitter_project/rscripts/")

source("read_data.R")

library(ggplot2)
library(dplyr)
library(stringr)
library(chron)
library(gridExtra)
library(grid)

####### data filtering & formatting ######
data.person <- combined %>%
  filter(PERSON_FLAG == "1")

rm(combined, nominees_metadata, timelines, metadata_CSV_date, packages, timeline_CSV_date, ipak)

convert_date <- function(date){
  # converting date values (characters) in data into comfortable form in R
  # c(yyyy-mm-dd, hh:mm:ss) date object
  # browser()
  if(class(date) != "character") warning("input object is not character")
  splitted <- str_split(date, " ")[[1]]
  if(length(splitted) != 6) warning("object was not splitted into 6 lenghth")
  
  month <- match(splitted[2], month.abb)
  year.month.day <- str_c(splitted[6], month, splitted[3], sep = "-")
  time <- splitted[4]
  
  date.out <- chron(dates = year.month.day, times = time,format=c('y-m-d','h:m:s'))
  return(date.out)
}

# from wiki
# January 10, 2016, 5:00 p.m. PST / 8:00 p.m. EST
# converting PST into UTC
create_GG_time <- function(){
  GG.txt <- "2016-01-10 17:00"
  GG.date <- as.POSIXct(GG.txt, tz="America/Los_Angeles")  
  attributes(GG.date)$tzone <- "UTC"
  GG.dates <- str_split(GG.date," ")[[1]][1]
  GG.times <- str_split(GG.date," ")[[1]][2]
  GG.dates.splitted <- str_split(GG.dates, "-")[[1]]
  GG.dates <- str_c(GG.dates.splitted[2], GG.dates.splitted[3], 
                    str_sub(GG.dates.splitted[1], 3,4), sep = "/")
  GG.date <- chron(dates. = GG.dates, times. = GG.times)
  return(GG.date)
}

GG.date <- create_GG_time()

data.person <- data.person %>% 
  rowwise() %>% 
  mutate(tweet_created_at_R = convert_date(tweet_created_at))
# 25 seconds; a bit long
# maybe only for person?

data.person <- data.person %>% 
  rowwise() %>% 
  mutate(tweet_time_lag = tweet_created_at_R - GG.date)

###### counting the number of each levels #####
names <- unique(data.person$tweet_user_name)
names

gen <- NULL
for(name in names){
  gen <- c(gen, unique(data.person$GENDER_FLAG[data.person$tweet_user_name == name]))
}

n.male <- sum(gen=="M")
n.female <- sum(gen=="F")

winn <- NULL
for(name in names){
  winn <- c(winn, unique(data.person$WINNER_FLAG[data.person$tweet_user_name == name]))
}

n.winner <- sum(winn == "W")
n.loser <- sum(winn == "L")

