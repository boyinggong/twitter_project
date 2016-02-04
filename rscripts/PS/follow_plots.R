library(readr)
library(dplyr)
library(ggplot2)

timelines <- read.csv("../../data/output_data/timelines/CSV/all_concat_timelines_20160203.csv",
                      header = TRUE, stringsAsFactors = FALSE)
metadata <- read_csv("../../data/input_data/golden_globes_metadata/nominees-spreadsheet-01-30.csv")

combined <- left_join(timelines, metadata, by = c("tweet_user_screen_name" = "TWITTER_SCREEN_NAME"))

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
