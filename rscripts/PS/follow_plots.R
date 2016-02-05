library(dplyr)
library(ggplot2)

## Pull in the data
source("../read_data.R")

follow_columns <- c("tweet_user_screen_name",
                    #"WINNER_FLAG",
                    #"CATEGORY",
                    #"tweet_user_followers_count",
                    "tweet_user_friends_count")
follow <- select(combined,
                 which(names(combined) %in% follow_columns))
#follow <- select(combined, one_of(follow_columns))
follow <- distinct(follow)
p <- ggplot(data = follow, aes(x = tweet_user_followers_count,
                                 y = tweet_user_friends_count)) 
p + geom_point()
