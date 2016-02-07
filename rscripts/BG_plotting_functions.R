
source("./read_data.R")

library(stringr)
library(SocialMediaMineR)
library(ggplot2)

class(combined_timelines)
length(combined_timelines$tweet_text)
names(combined_timelines)

test <- combined_timelines["tweet_NLP_get_users_mentioned"][1, 1]
str_replace_all(test, "\'|\\[|\\]", "")

###############  create mentioned data frame

mentioned_dataframe <- function(combined_timelines){
  screen_names = unique(combined_timelines$tweet_user_screen_name)
  count_mentioned = data.frame(Screen_name = rep(0, length(screen_names)))
  row.names(count_mentioned) = screen_names
  for (name in screen_names){
    countperson <- sapply(1:length(combined_timelines$tweet_text), function(i)
      length(grep(name, combined_timelines$tweet_text[i])))
    count_mentioned[name, 1] <- 
      sum(countperson[combined_timelines$tweet_user_screen_name != name])
  }
  colnames(count_mentioned) = "MentionCount"
  count_mentioned$Screen_name = row.names(count_mentioned)
  as.numeric(combined_timelines$tweet_retweet_count)
  x <- data.frame(Name = factor(combined_timelines$tweet_user_name), 
                  Screen_name = factor(combined_timelines$tweet_user_screen_name), 
                  Categories = factor(combined_timelines$CATEGORY), 
                  Win = factor(combined_timelines$WINNER_FLAG),
                  Gender = factor(combined_timelines$GENDER_FLAG),
                  Person = factor(combined_timelines$PERSON_FLAG),
                  Frequency = as.numeric(combined_timelines$tweet_retweet_count))
  retweet_count <- aggregate(x$Frequency, 
                             by=list(Name=x$Name, Screen_name = x$Screen_name, 
                                     Categories = x$Categories, Win = x$Win, Gender = x$Gender, PERSON = x$Person), 
                             FUN=sum)
  ordered_retweet_count <- retweet_count[with(retweet_count, order(-x)), ]
  names(ordered_retweet_count)[7] = "RetweetCount"
  total <- merge(count_mentioned, ordered_retweet_count, by="Screen_name")
  return(total)
}

ordered_retweet_count <- mentioned_dataframe(combined_timelines)

###############  person: mentioned vs retweet

mentioned_retweet <- function(ordered_retweet_count, IS_PERSON = TRUE){
  ggplot(ordered_retweet_count[ordered_retweet_count$PERSON == as.numeric(IS_PERSON), ], 
         aes(x = log(RetweetCount+1), y = log(MentionCount+1))) + 
    geom_point() +
    scale_colour_manual(values=c("grey50", "red"))
}

mentioned_retweet(ordered_retweet_count)

###############  person: mentioned vs retweet by win or loss

mentioned_retweet_win <- function(ordered_retweet_count, IS_PERSON = TRUE){
  ggplot(ordered_retweet_count[ordered_retweet_count$PERSON == as.numeric(IS_PERSON), ], 
         aes(x = log(RetweetCount+1), y = log(MentionCount+1))) + 
    geom_point(aes(color = Win)) +
    scale_colour_manual(values=c("grey50", "red"))
}

mentioned_retweet_win(ordered_retweet_count, IS_PERSON = TRUE)
mentioned_retweet_win(ordered_retweet_count, IS_PERSON = FALSE)

###############  person: mentioned vs retweet by gender

mentioned_retweet_gender <- function(ordered_retweet_count){
  ggplot(ordered_retweet_count[ordered_retweet_count$PERSON == as.numeric(IS_PERSON), ], 
         aes(x = log(RetweetCount+1), y = log(MentionCount+1))) + 
    geom_point(aes(color = Gender)) +
    scale_colour_manual(values=c("grey50", "red"))
}

mentioned_retweet_gender(ordered_retweet_count)
  
###############  mentioned bar plot

mention_plot <- function(ordered_retweet_count, IS_PERSON = TRUE){
  ordered_retweet_count$MentionCount = as.numeric(ordered_retweet_count$MentionCount)
  ordered_retweet_count$name2 <- reorder(ordered_retweet_count$Name, 
                                         ordered_retweet_count$MentionCount)
  ggplot(ordered_retweet_count[ordered_retweet_count$PERSON == as.numeric(IS_PERSON), ], 
         aes(x=Name, y=MentionCount, fill = Win)) + 
    geom_bar(aes(x=name2), stat='identity') +
    scale_fill_manual(values=c("grey50", "red")) + 
    coord_flip()
}

# When IS_PERSON = TRUE, plot the person account, else plot the movie account
mention_plot(ordered_retweet_count, IS_PERSON = TRUE)
mention_plot(ordered_retweet_count, IS_PERSON = FALSE)

###############  






time_test <- strptime(combined_timelines$tweet_created_at[1:10], "%a %b %d %H:%M:%S %z %Y")


time_test[6] < time_test[5]


aggregate(combined_timelines$Frequency, 
          by=list(Name=combined_timelines$Name, Screen_name = x$Screen_name, 
                  Categories = x$Categories, Win = x$Win, Gender = x$Gender, PERSON = x$Person), 
          FUN=sum)


names(combined_timelines)



