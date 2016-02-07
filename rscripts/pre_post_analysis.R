######################################################
################ pre post analysis ###################
######################################################

source("read_data.R")
  
pre_post_plot <- function(VALUE, median_flag = TRUE){
  # input:
  #   VALUE: "M" or "F", whether you want to fiter by
  #   median_flag: TRUE or FALSE,
  #     T for taking median for the values in plot
  #     and F for taking mean
  # 
  # output:
  #   1 plot divided by 4 grid
  #   - time lag vs retweet count
  #   - time lag vs tweet count per day
  #   - time lag vs favorite count
  #   - time lag vs tweet length
  
  # filtering by person & +- 20 days
  data.person <- combined_timelines %>%
    filter(PERSON_FLAG == "1" & abs(tweet_time_lag) < 20, GENDER_FLAG == VALUE)
 
  aggregate_by <- function(median_flag){
    if(median_flag){
      out <- data.person %>%
        group_by(WINNER_FLAG,tweet_time_lag_days) %>% 
        summarise(tweet_count = n(),
                  number_of_tweeters = n_distinct(tweet_user_name),
                  tweet_count_each_day = n()/n_distinct(tweet_user_name),
                  tweet_retweet_count = median(as.numeric(tweet_retweet_count)), 
                  tweet_length = median(str_count(tweet_text)),
                  tweet_favorite_count = median(tweet_favorite_count)) 
      
    }else{
      out <- data.person %>% 
        group_by(WINNER_FLAG,tweet_time_lag_days) %>% 
        summarise(tweet_count = n(),
                  number_of_tweeters = n_distinct(tweet_user_name),
                  tweet_count_each_day = n()/n_distinct(tweet_user_name),
                  tweet_retweet_count = mean(as.numeric(tweet_retweet_count)), 
                  tweet_length = mean(str_count(tweet_text)),
                  tweet_favorite_count = mean(tweet_favorite_count)) 
    }
    return(out)
  }

  my_plot <- function(data, title, median_flag){
    if(median_flag){
      title2 <- " (median)"
    }else{
      title2 <- " (mean)"
    }
    
    p1 <- ggplot(data = data, aes(x = tweet_time_lag_days, y = tweet_retweet_count),
                 environment = environment())
    p2 <- p1 + geom_line(aes_string(color = "WINNER_FLAG")) +
      xlab("lag (days)") + ylab("retweet count") + ggtitle("lag vs retweet count")
    
    p1 <- ggplot(data = data, aes(x = tweet_time_lag_days, y = tweet_count_each_day))
    p3 <- p1 + geom_line(aes_string(color = "WINNER_FLAG")) +
      xlab("lag (days)") + ylab("tweet count") + ggtitle("lag vs tweet count")
    
    p1 <- ggplot(data = data, aes(x = tweet_time_lag_days, y = tweet_favorite_count))
    p4 <- p1 + geom_line(aes_string(color = "WINNER_FLAG")) +
      xlab("lag (days)") + ylab("favorite count") + ggtitle("lag vs favorite count")
    
    p1 <- ggplot(data = data, aes(x = tweet_time_lag_days, y = tweet_length))
    p5 <- p1 + geom_line(aes_string(color = "WINNER_FLAG")) +
      xlab("lag (days)") + ylab("tweet length") + ggtitle("lag vs tweet length")
    
    return(grid.arrange(p2,p3,p4,p5, nrow = 2,
                        top = textGrob(paste(title, title2), gp=gpar(fontsize=20)))) 
    
  }
  
  data.grouped <- aggregate_by(median_flag)
  if(VALUE == "M"){
    title <- "Male Winners vs Male Losers"
  }else{
    title <- "Female Winners vs Female Losers"
  }
  return(my_plot(data.grouped, title, median_flag))
}

