library(ggplot2)
library(dplyr)
library(stringr)
library(chron)
library(gridExtra)
library(grid)

pre_post_modify <- function(data){
  # input:
  #   data, expecting combined_timelines
  # output:
  #   data modified, adding columns;
  #   - tweet_created_at_R
  #   - tweet_time_lag

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
  GG.date <- chron(dates. = "01/11/16", times. = "01:00:00")
  
  data.modified <- data %>% 
    rowwise() %>% 
    mutate(tweet_created_at_R = convert_date(tweet_created_at))

  data.modified <- data.modified %>% 
    rowwise() %>% 
    mutate(tweet_time_lag = tweet_created_at_R - GG.date)
  
  data.modified <- data.modified %>% 
    rowwise() %>% 
    mutate(tweet_time_lag_days = floor(tweet_time_lag))
  
  data.modified <- data.modified %>%
    rowwise() %>% 
    mutate(pre_post_during_flag =
             ifelse(tweet_time_lag_days > 1,
                    ifelse(tweet_time_lag_days > -1, "during", "pre"), "post")
    )
  
  return(data.modified)
}
