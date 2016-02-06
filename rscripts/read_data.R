# INSTRUCTIONS: Search for the word "UPDATE" and check that field is manually
#               updated to the latest value

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
packages <- c("ggplot2", "dplyr", "readr", "stringr", "rPython")
ipak(packages)

system.time(system("cd .. && python ./create_timelines_CSV.py"))

# The date of the CSV files
# Make sure that you run the following Python script first
# "../create_timelines_CSV.py"
timeline_CSV_date = format(Sys.Date(), format="%Y%m%d") 
metadata_CSV_date = "02-06"                             # UPDATE manually if this file is updated

# Read in the timelines dataset
timelines           <- read.csv(file.path("../data/output_data/timelines/CSV"
                                          , str_c("all_concat_timelines_", timeline_CSV_date, ".csv"))
                                , header = TRUE
                                , stringsAsFactors = FALSE)

nominees_metadata   <- read.csv(file.path("../data/input_data/golden_globes_metadata"
                                          , str_c("nominees-spreadsheet-", metadata_CSV_date, ".csv"))
                                , header = TRUE
                                , stringsAsFactors = FALSE)

# Read in the metadata for the nominees
# Remove all blank screen names from the nominee metadata
timelines          <- filter(timelines, tweet_user_screen_name != "")

nominees_metadata  <- filter(nominees_metadata, TWITTER_SCREEN_NAME != "") %>% 
                      distinct(TWITTER_SCREEN_NAME)

# Join the nominee metadata on the timelines dataset
combined_timelines <- left_join(timelines
                                , nominees_metadata
                                , by = c("tweet_user_screen_name" = "TWITTER_SCREEN_NAME"))