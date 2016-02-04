#!/usr/bin/env python
import json
import pandas as pd
from datetime import datetime
import time
#import sys
#sys.path.append('./')
#sys.path
from create_timelines_dataset import create_twitter_timeline_DataFrame, concatenate_all_twitter_timelines

# Define the base timeline data directory
TIMELINE_DATA_DIR = "./data/output_data/timelines/"
COMPUTED          = "./data/output_data/following_computed_data/"

# Produce the concatenated dataframe of all tweets across all accounts
final   = concatenate_all_twitter_timelines(screen_names_dir = COMPUTED
                                            , timeline_data_dir = TIMELINE_DATA_DIR)

# Get the timestring format to append to the filename
timestr = time.strftime("%Y%m%d")
final.to_csv(TIMELINE_DATA_DIR + "CSV/all_concat_timelines_" + timestr + ".csv")
