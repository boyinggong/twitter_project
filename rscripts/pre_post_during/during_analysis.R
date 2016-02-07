######################################################
################## during analysis ###################
######################################################

setwd("C:/Users/Tomofumi/Documents/Class/spring/capstone/project1/")
source("read_format_data.R")

data.person <- data.person %>% 
  rowwise() %>% 
  mutate(tweet_time_lag_hours = floor(tweet_time_lag * 24))

half <- data.person %>% 
  filter(abs(tweet_time_lag_hours) < 12)

one <- data.person %>% 
  filter(abs(tweet_time_lag_hours) < 24)

three <- data.person %>% 
  filter(abs(tweet_time_lag_hours) < 24 * 3)

##### grouping by and plotting #####

my_plot2 <- function(data, title, key, median_flag = TRUE){
  if(median_flag){
    title2 <- " (median)"
  }else{
    title2 <- " (mean)"
    
  }
  p1 <- ggplot(data = data, aes(x = tweet_time_lag_hours, y = tweet_retweet_count),
               environment = environment())
  p2 <- p1 + geom_line(aes_string(color = key)) +
    xlab("lag (hours)") + ylab("retweet count") + ggtitle("lag vs retweet count")
  
  p1 <- ggplot(data = data, aes(x = tweet_time_lag_hours, y = tweet_count_each_day))
  p3 <- p1 + geom_line(aes_string(color = key)) +
    xlab("lag (hours)") + ylab("tweet count") + ggtitle("lag vs tweet count")
  
  p1 <- ggplot(data = data, aes(x = tweet_time_lag_hours, y = tweet_favorite_count))
  p4 <- p1 + geom_line(aes_string(color = key)) +
    xlab("lag (hours)") + ylab("favorite count") + ggtitle("lag vs favorite count")
  
  p1 <- ggplot(data = data, aes(x = tweet_time_lag_hours, y = tweet_length))
  p5 <- p1 + geom_line(aes_string(color = key)) +
    xlab("lag (hours)") + ylab("tweet length") + ggtitle("lag vs tweet length")
  
  return(grid.arrange(p2,p3,p4,p5, nrow = 2,
                      top = textGrob(paste(title, title2), gp=gpar(fontsize=20)))) 
  
}

grouping_plot <- function(data, title, key){
  grouped <- aggregate_by(data, TRUE, key, "tweet_time_lag_hours")
  my_plot2(grouped, title, key)
  grouped <- aggregate_by(data, FALSE, key, "tweet_time_lag_hours")
  my_plot2(grouped, title, key, FALSE)
}

# by each person
setwd("C:/Users/Tomofumi/Documents/Class/spring/capstone/project1/myplots/during")
grouping_plot(half, "By each person +- 12 hours", "tweet_user_name")
grouping_plot(one, "By each person +- 24 hours", "tweet_user_name")
grouping_plot(three, "By each person +- 3 days", "tweet_user_name")


# by winner/loser
grouping_plot(half, "Winner vs Loser +- 12 hours", "WINNER_FLAG")
grouping_plot(one, "Winner vs Loser +- 24 hours", "WINNER_FLAG")
grouping_plot(three, "Winner vs Loser +- 3 days", "WINNER_FLAG")


# by male/female
grouping_plot(half, "Male vs Female +- 12 hours", "GENDER_FLAG")
grouping_plot(one, "Male vs Female +- 24 hours", "GENDER_FLAG")
grouping_plot(three, "Male vs Female +- 3 days", "GENDER_FLAG")

# by film/tv
grouping_plot(half, "Film vs TV +- 12 hours", "FILM_FLAG_CHARA")
grouping_plot(one, "Film vs TV +- 24 hours", "FILM_FLAG_CHARA")
grouping_plot(three, "Film vs TV +- 3 days", "FILM_FLAG_CHARA")

