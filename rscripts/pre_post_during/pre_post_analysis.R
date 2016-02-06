######################################################
################ pre post analysis ###################
######################################################

getwd()
setwd("C:/Users/Tomofumi/Documents/Class/spring/capstone/project1/")
source("read_format_data.R")


# take +- 20 days
data.person <- data.person %>% 
  filter(abs(tweet_time_lag) < 20)

data.person <- data.person %>% 
  rowwise() %>% 
  mutate(tweet_time_lag_days = floor(tweet_time_lag))


##### grouping by winners/losers or male/female #####
aggregate_by <- function(x, median_flag = TRUE, ...){
  if(median_flag){
    out <- x %>% group_by_(...) %>%
      summarise(tweet_count = n(),
                number_of_tweeters = n_distinct(tweet_user_name),
                tweet_count_each_day = n()/n_distinct(tweet_user_name),
                tweet_retweet_count = median(tweet_retweet_count), 
                tweet_length = median(str_count(tweet_text)),
                tweet_favorite_count = median(tweet_favorite_count)) 
    
  }else{
    out <- x %>% group_by_(...) %>%
      summarise(tweet_count = n(),
                number_of_tweeters = n_distinct(tweet_user_name),
                tweet_count_each_day = n()/n_distinct(tweet_user_name),
                tweet_retweet_count = mean(tweet_retweet_count), 
                tweet_length = mean(str_count(tweet_text)),
                tweet_favorite_count = mean(tweet_favorite_count)) 
    
  }
  return(out)
}

my_plot <- function(data, title, key, median_flag = TRUE){
  if(median_flag){
    title2 <- " (median)"
  }else{
    title2 <- " (mean)"
  }
  p1 <- ggplot(data = data, aes(x = tweet_time_lag_days, y = tweet_retweet_count),
               environment = environment())
  p2 <- p1 + geom_line(aes_string(color = key)) +
    xlab("lag (days)") + ylab("retweet count") + ggtitle("lag vs retweet count")
  
  p1 <- ggplot(data = data, aes(x = tweet_time_lag_days, y = tweet_count_each_day))
  p3 <- p1 + geom_line(aes_string(color = key)) +
    xlab("lag (days)") + ylab("tweet count") + ggtitle("lag vs tweet count")
  
  p1 <- ggplot(data = data, aes(x = tweet_time_lag_days, y = tweet_favorite_count))
  p4 <- p1 + geom_line(aes_string(color = key)) +
    xlab("lag (days)") + ylab("favorite count") + ggtitle("lag vs favorite count")
  
  p1 <- ggplot(data = data, aes(x = tweet_time_lag_days, y = tweet_length))
  p5 <- p1 + geom_line(aes_string(color = key)) +
    xlab("lag (days)") + ylab("tweet length") + ggtitle("lag vs tweet length")
  
  return(grid.arrange(p2,p3,p4,p5, nrow = 2,
                      top = textGrob(paste(title, title2), gp=gpar(fontsize=20)))) 
  
}

# by each person
setwd("C:/Users/Tomofumi/Documents/Class/spring/capstone/project1/myplots/pre_post/")
data.person.grouped.median <- aggregate_by(data.person, TRUE, "tweet_user_name", "tweet_time_lag_days")
my_plot(data.person.grouped.median, "By each person", "tweet_user_name")

data.person.grouped.mean <- aggregate_by(data.person, FALSE, "tweet_user_name", "tweet_time_lag_days")
my_plot(data.person.grouped.mean, "By each person", "tweet_user_name", median_flag = FALSE)

# max?
m1 <- max(data.person.grouped$tweet_retweet_count)
she <- data.person.grouped$tweet_user_name[which.max(data.person.grouped$tweet_retweet_count)]
m2 <- max(data.person.grouped$tweet_favorite_count)
he <- data.person.grouped$tweet_user_name[which.max(data.person.grouped$tweet_favorite_count)]
c(she, he)
c(m1,m2)

her_tweet <- data.person %>% 
        filter(tweet_user_name == she,tweet_retweet_count == m1) %>% 
        select(tweet_user_name, tweet_text, tweet_retweet_count)
his_tweet <- data.person %>% 
  filter(tweet_user_name == he,tweet_favorite_count == m2) %>% 
  select(tweet_user_name, tweet_text, tweet_favorite_count)
View(her_tweet)
View(his_tweet)

# removing these guys?

# by winner/loser
data.winner.grouped.median <- aggregate_by(data.person, TRUE, 
                                    "WINNER_FLAG", "tweet_time_lag_days")
my_plot(data.winner.grouped.median, "Winners vs Losers", "WINNER_FLAG")

data.winner.grouped.mean <- aggregate_by(data.person, FALSE,
                                           "WINNER_FLAG", "tweet_time_lag_days")
my_plot(data.winner.grouped.mean, "Winners vs Losers", "WINNER_FLAG", FALSE)

# by male/female
data.gender.grouped.median <- aggregate_by(data.person, TRUE,
                                    "GENDER_FLAG", "tweet_time_lag_days")
my_plot(data.gender.grouped.median, "Male vs Female", "GENDER_FLAG", TRUE)

data.gender.grouped.mean <- aggregate_by(data.person, FALSE,
                                           "GENDER_FLAG", "tweet_time_lag_days")
my_plot(data.gender.grouped.mean, "Male vs Female", "GENDER_FLAG", FALSE)

# by film/tv
data.person <- data.person %>% 
  rowwise() %>% 
  mutate(FILM_FLAG_CHARA = ifelse(FILM_FLAG == 1, "Film", "TV"))

data.film.grouped.median <- aggregate_by(data.person, TRUE, 
                                           "FILM_FLAG_CHARA", "tweet_time_lag_days")
my_plot(data.film.grouped.median, "Film vs TV", "FILM_FLAG_CHARA")

data.film.grouped.mean <- aggregate_by(data.person, FALSE,
                                         "FILM_FLAG_CHARA", "tweet_time_lag_days")
my_plot(data.film.grouped.mean, "Film vs TV", "FILM_FLAG_CHARA", FALSE)


###### some statistics ######
n.gen <- data.person %>% group_by(GENDER_FLAG) %>%
  summarise(number = n_distinct(tweet_user_name))

n.win <- data.person %>% group_by(WINNER_FLAG) %>%
  summarise(number = n_distinct(tweet_user_name))

n.film <- data.person %>% group_by(FILM_FLAG_CHARA) %>%
  summarise(number = n_distinct(tweet_user_name))
