######################################################
################## during analysis ###################
######################################################

# source("read_data.R")

# library(dplyr)

during_plot <- function(median_flag = TRUE, time_limit = 24, VALUE = NA){
  
  aggregate_by <- function(median_flag){
    if(median_flag){
      out <- data.during %>%
        group_by(WINNER_FLAG,tweet_time_lag_hours) %>% 
        summarise(tweet_count = n(),
                  number_of_tweeters = n_distinct(tweet_user_name),
                  tweet_count_each_day = n()/n_distinct(tweet_user_name),
                  tweet_retweet_count = median(as.numeric(tweet_retweet_count)), 
                  tweet_length = median(str_count(tweet_text)),
                  tweet_favorite_count = median(tweet_favorite_count)) 
      
    }else{
      out <- data.during %>% 
        group_by(WINNER_FLAG,tweet_time_lag_hours) %>% 
        summarise(tweet_count = n(),
                  number_of_tweeters = n_distinct(tweet_user_name),
                  tweet_count_each_day = n()/n_distinct(tweet_user_name),
                  tweet_retweet_count = mean(as.numeric(tweet_retweet_count)), 
                  tweet_length = mean(str_count(tweet_text)),
                  tweet_favorite_count = mean(tweet_favorite_count)) 
    }
    return(out)
  }
  my_plot <- function(data, title, median_flag = TRUE){
    if(median_flag){
      title2 <- " (median)"
    }else{
      title2 <- " (mean)"
      
    }
    p1 <- ggplot(data = data, aes(x = tweet_time_lag_hours, y = tweet_retweet_count),
                 environment = environment())
    p2 <- p1 + geom_line(aes_string(color = "WINNER_FLAG")) +
      xlab("lag (hours)") + ylab("retweet count") + ggtitle("lag vs retweet count")
    
    p1 <- ggplot(data = data, aes(x = tweet_time_lag_hours, y = tweet_count_each_day))
    p3 <- p1 + geom_line(aes_string(color = "WINNER_FLAG")) +
      xlab("lag (hours)") + ylab("tweet count") + ggtitle("lag vs tweet count")
    
    p1 <- ggplot(data = data, aes(x = tweet_time_lag_hours, y = tweet_favorite_count))
    p4 <- p1 + geom_line(aes_string(color = "WINNER_FLAG")) +
      xlab("lag (hours)") + ylab("favorite count") + ggtitle("lag vs favorite count")
    
    p1 <- ggplot(data = data, aes(x = tweet_time_lag_hours, y = tweet_length))
    p5 <- p1 + geom_line(aes_string(color = "WINNER_FLAG")) +
      xlab("lag (hours)") + ylab("tweet length") + ggtitle("lag vs tweet length")
    
    return(grid.arrange(p2,p3,p4,p5, nrow = 2,
                        top = textGrob(paste(title, title2), gp=gpar(fontsize=20)))) 
    
  }
  
  if(is.na(VALUE)){
    data.person <- combined_timelines %>%
      filter(PERSON_FLAG == "1")
  }else{
    data.person <- combined_timelines %>%
      filter(PERSON_FLAG == "1", GENDER_FLAG == VALUE)
  }
  
  data.person <- data.person %>% 
    rowwise() %>% 
    mutate(tweet_time_lag_hours = floor(tweet_time_lag * 24))
  data.during <- data.person %>% 
    filter(abs(tweet_time_lag_hours) < time_limit)
  grouped <- aggregate_by(median_flag)
  title <- paste("Winners vs Losers +-", time_limit, "hours", sep = " ")
  return(my_plot(grouped, title, median_flag))
}