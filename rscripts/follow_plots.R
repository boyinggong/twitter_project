## ---- followPlot ----
library(dplyr)
library(ggplot2)

## Pull in the data
##source("read_data.R")


combined <- combined_timelines
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
follow_interesting <- filter(follow,
                             tweet_user_friends_count < 40000 &
                               (tweet_user_followers_count > 25e5 |
                                  tweet_user_friends_count > 1000))

p <- ggplot(data = filter(follow, tweet_user_friends_count < 40000),
            aes(x = tweet_user_followers_count,
                y = tweet_user_friends_count,
                color = WINNER_FLAG))
p <- p + geom_hline(yintercept = 1000) + geom_vline(xintercept = 25e5)
p <- p + geom_point()
p <- p + geom_label(data = follow_interesting,
                    aes(label = NOMINEE, hjust = "left"),
                    nudge_x = 200000,
                    show.legend = FALSE)
p <- p + labs(x = "Number of followers", y = "Number followed",
              title = "Nominee Following vs. Follower Counts")
  
p <- p + coord_cartesian(xlim = c(0, 1.75e7)) + scale_colour_discrete(name = "Result")
p <- p + annotate("text", x = 0, y = 2000, label = "Try-hards",
                  size = 7, hjust = "left")
p <- p + annotate("text", x = 01e7, y = 500, label = "Popular kids",
                  size = 7, hjust = "left")
p


## not sure if this plot is very interesting
# p <- ggplot(data = filter(follow, tweet_user_friends_count < 40000 &
#                             grepl("Best Actress", CATEGORY)),
#             aes(x = tweet_user_followers_count,
#                 y = tweet_user_friends_count,
#                 color = WINNER_FLAG))
# p <- p + geom_point()
# #p <- p + facet_wrap(~CATEGORY) + scale_y_log10()
# p
