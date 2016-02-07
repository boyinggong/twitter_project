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
                    "tweet_user_friends_count",
                    "GENDER_FLAG")
follow <- select(combined,
                 which(names(combined) %in% follow_columns))
#follow <- select(combined, one_of(follow_columns))
follow <- distinct(follow)
## Lady Gaga is duplicated with a slightly different count for some reason
follow <- follow[-70,]

follow_interesting <- filter(follow,
                             tweet_user_friends_count < 40000 &
                               (tweet_user_followers_count > 25e5 |
                                  tweet_user_friends_count > 1000))
gaga <- follow %>% filter(tweet_user_screen_name == "ladygaga")
gaga <- gaga[1, c("tweet_user_followers_count", "tweet_user_friends_count")]
thrones <- follow %>% filter(tweet_user_screen_name == "gameofthrones")
thrones <- thrones[1, c("tweet_user_followers_count", "tweet_user_friends_count")]

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
p <- p + annotate("text", x = 0, y = 2000, label = "Active",
                  size = 7, hjust = "left")
p <- p + annotate("text", x = 01e7, y = 500, label = "Popular",
                  size = 7, hjust = "left")
p <- p + annotate("text", x = 1e7, y= 2000, label = "Power",
                  size= 7)
p <- p + annotate("text", x = 1e7, y = 3000,
                  label = paste("Not shown:\n",
                                "Lady Gaga:", gaga[1], ",", gaga[2], "\n",
                                "Game of Thrones:", thrones[1], ",", thrones[2]))
p

## ---- followProfiling ----
## Plotting the interesting groups
follow_interesting <- follow %>% filter(tweet_user_followers_count > 25e5 |
                                          tweet_user_friends_count > 1000)
user_type <- function(row) {
  c1 <- (row[1] > 25e5)
  c2 <- (row[2] > 1000)
  c3 <- c1 & c2
  type <- NA
  type[c1] <- "Popular"
  type[c2] <- "Active"
  type[c3] <- "Power"
  return(type)
}

user_types <- factor(sapply(1:nrow(follow_interesting),
                            function(i) user_type(follow_interesting[i,])))
follow_interesting <- follow_interesting %>% mutate(type = user_types)

follow_interesting <- follow_interesting %>%
  mutate(GENDER_FLAG = ifelse(GENDER_FLAG == "", "FILM/SHOW", GENDER_FLAG))

p <- ggplot(data = follow_interesting, aes(GENDER_FLAG))
p <- p + geom_bar(aes(fill = WINNER_FLAG)) + facet_wrap(~ type) + xlab("Type")
p <- p + ggtitle("Breakdown of User Type by Style of Twitter Use") +
  scale_fill_discrete(name = "WINNER")
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

