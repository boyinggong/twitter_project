# ipak function: install and load multiple R packages.
# check to see if packages are installed. Install them if they are not, then load them into the R session.
# SOURCE: https://gist.github.com/stevenworthington/3178163
ipak <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg))
        install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
}

# Install and load the required packages
packages <- c("ggplot2", "dplyr", "readr", "stringr")
ipak(packages)

# The date of the CSV files
timeline_CSV_date = "20160204" # UPDATE
metadata_CSV_date = "02-04"    # UPDATE

# Read in the timelines dataset
timelines <- read.csv(file.path("../data/output_data/timelines/CSV", str_c("all_concat_timelines_", timeline_CSV_date, ".csv")),
                      header = TRUE, stringsAsFactors = FALSE)

# Read in the metadata for the nominees
# Remove all blank screen names from the nominee metadata
timelines2  <- filter(timelines, tweet_user_screen_name != "") 

nominees_metadata2  <- filter(nominees_metadata, TWITTER_SCREEN_NAME != "") %>% distinct(TWITTER_SCREEN_NAME) 

# Join the nominee metadata on the timelines dataset
combined <- left_join(timelines2
                      , nominees_metadata2
                      , by = c("tweet_user_screen_name" = "TWITTER_SCREEN_NAME"))


dirname(sys.frame(1)$ofile)
