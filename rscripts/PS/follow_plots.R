library(dplyr)
library(ggplot2)

## Pull in the data
source("../read_data.R")

combined$tweet_user_followers_count <- as.numeric(combined$tweet_user_followers_count)
combined$tweet_user_friends_count <- as.numeric(combined$tweet_user_friends_count)
follow_columns <- c("tweet_user_screen_name",
                    "WINNER_FLAG",
                    "CATEGORY",
                    "NOMINEE",
                    "tweet_user_followers_count",
                    "tweet_user_friends_count")
follow <- select(combined,
                 which(names(combined) %in% follow_columns))
#follow <- select(combined, one_of(follow_columns))
follow <- distinct(follow)

p <- ggplot(data = filter(follow, tweet_user_friends_count < 40000),
            aes(x = tweet_user_followers_count,
                y = tweet_user_friends_count,
                color = WINNER_FLAG))
p <- p + geom_point()
follow.interesting <- filter(follow,
                             tweet_user_friends_count < 40000 &
                             (tweet_user_followers_count > 25e5 |
                             tweet_user_friends_count > 1000))
p <- p + geom_label(data = follow.interesting,
                    aes(label = NOMINEE, hjust = "left"),
                    #nudge_x = 1020000,
                    nudge_x = 10000,
                    show.legend = FALSE)
p <- p + xlab("Number of followers") + ylab("Number followed")
p

follow[order(follow$tweet_user_friends_count), -4]
