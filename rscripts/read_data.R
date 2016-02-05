library(readr)
library(dplyr)


## for some reason, read_csv doesn't work here
timelines <- read.csv("../../data/output_data/timelines/CSV/all_concat_timelines_20160203.csv",
                      header = TRUE, stringsAsFactors = FALSE)
metadata <- read_csv("../../data/input_data/golden_globes_metadata/nominees-spreadsheet-02-04.csv")

combined <- left_join(timelines, metadata, by = c("tweet_user_screen_name" = "TWITTER_SCREEN_NAME"))
