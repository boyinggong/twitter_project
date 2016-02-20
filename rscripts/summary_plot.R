#library(dplyr)
#library(ggplot2)

## ---- dataSummaryPlot ----
combined <- combined_timelines
combined <- combined %>% mutate(GENDER_FLAG = as.character(ifelse(GENDER_FLAG == "", "FILM/SHOW", GENDER_FLAG)))
combined <- combined %>% mutate(FILM_FLAG = as.character(ifelse(FILM_FLAG == 0, "TV", "FILM")))
combined <- combined %>% mutate(tweet_user_screen_name = tolower(tweet_user_screen_name))
combined <- combined %>% filter(!is.na(FILM_FLAG) & tweet_time_lag > 0)
tweet_counts <- combined %>% ungroup() %>% group_by(tweet_user_screen_name) %>% count(tweet_user_screen_name)
names(tweet_counts)[2] <- "Tweets"
summary_columns <- c("tweet_user_screen_name",
                    "WINNER_FLAG",
                    "CATEGORY",
                    "NOMINEE",
                    "GENDER_FLAG",
                    "FILM_FLAG")
summary_data <- select(combined, one_of(summary_columns))

summary_data <- distinct(summary_data)
summary_data <- tweet_counts %>% left_join(summary_data,
                                           by = "tweet_user_screen_name")
#summary_data <- summary_data %>% arrange(desc(Tweets))
#summary_data <- summary_data %>% mutate(tweet_user_screen_name = factor(tweet_user_screen_name,
#                                                                        ordered = TRUE))
#summary_data <- summary_data %>% mutate(NOMINEE = ifelse(Tweets == 0, "", NOMINEE))
summary_data <- summary_data %>% filter(Tweets > 0 & !is.na(NOMINEE))

#png("../poster_graphics/summary_plot.png",
#    width = 50, height = 33, units = "cm", res = 300)
p <- ggplot(data = summary_data,
            aes(x = reorder(NOMINEE, Tweets), y = Tweets))
p <- p + geom_bar(stat = "identity", aes(fill = GENDER_FLAG))
p <- p + ylab("Number of Tweets")
p <- p + theme(axis.text.x = element_text(angle = 90, hjust = 1))
p <- p + facet_wrap(~ FILM_FLAG, scales = "free_x")
p <- p + ggtitle("Data Overview") + xlab("Nominees")
p <- p + ylim(c(0, 500))
p <- p + scale_fill_discrete(name = "User Type")
p
#dev.off()
ggsave(filename = "../poster_graphics/summary_plot.svg",
       plot = p, width = 50, height = 33, units = "cm")

# p <- ggplot(data = summary_data,
#             aes(x = NOMINEE))
# p <- p + geom_bar(aes(fill = GENDER_FLAG)) + ylab("Number of Tweets")
# p <- p + theme(axis.text.x = element_blank())
# p <- p + facet_wrap(~ FILM_FLAG)
# p
