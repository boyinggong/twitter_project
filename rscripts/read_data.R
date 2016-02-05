# ipak function: install and load multiple R packages.
# check to see if packages are installed. Install them if they are not, then load them into the R session.
# SOURCE: https://gist.github.com/stevenworthington/3178163
ipak <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg))
        install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
}


setwd("")

# Install and load the required packages
packages <- c("ggplot2", "dplyr", "readr", "stringr")
ipak(packages)

# The date of the CSV files
timeline_CSV_date = "20160204" # UPDATE
metadata_CSV_date = "02-04"    # UPDATE

##setwd("~/LEARNING/STUDY/UC_BERKELEY/STATISTICS/COURSES/MA_PROGRAM/CURRENT_COURSES/SPRING_2016/STAT222/PROJECTS/twitter_project/rscripts")
top_level <- system("git rev-parse --show-toplevel")
setwd(paste(top_level, "/rscripts"))

# Read in the timelines dataset
timelines <- read.csv(file.path("../data/output_data/timelines/CSV", str_c("all_concat_timelines_", timeline_CSV_date, ".csv)")),
                      header = TRUE, stringsAsFactors = FALSE)

# Read in the metadata for the nominees
nominees_metadata  <- read.csv(file.path("../data/input_data/golden_globes_metadata", str_c("nominees-spreadsheet-", metadata_CSV_date, ".csv)"))
                      , header = TRUE
                      , stringsAsFactors = FALSE)

# Join the nominee metadata on the timelines dataset
combined <- left_join(timelines
                      , nominees_metadata
                      , by = c("tweet_user_screen_name" = "TWITTER_SCREEN_NAME"))
