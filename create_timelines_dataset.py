import json
import pandas as pd
import time
import datetime
from functions_NLP import get_users_mentioned, get_tags, processTweet, \
                          remove_stopwords, processTweet, replaceTwoOrMore, remove_punct

# Define the base timeline data directory
INPUT_SENTIMENT_DATA_DIR    = "./data/input_data/sentiment_analysis/"
TIMELINE_DATA_DIR           = "./data/output_data/timelines/"
COMPUTED                    = "./data/output_data/following_computed_data/"

# Function to Convert String to Interger for datetime processing
def xstr(s):
    if s is None:
        s = 0
    return int(s)

with open(INPUT_SENTIMENT_DATA_DIR + "stopwords.txt") as f:
    STOPWORDS = f.read().split('\n')

def create_twitter_timeline_DataFrame(screen_name, timeline_data_dir = "./data/output_data/timelines/"):
    """ Create a data frame of all twitter information for a single user
        (as defined by their screen name) based on the json download of their
        twitter timeline
    """
    # Load a single user twitter timeline (already downloaded as a json object)
    with open(TIMELINE_DATA_DIR + screen_name + ".json", "r") as f:
        timelines = json.load(f)

    # Data definitions as list comprehensions
    # Define all tweet specific metadata
    tweet_user                       = [tweet["user"]["screen_name"] for tweet in timelines]
    tweet_retweeted                  = [tweet["retweeted"] for tweet in timelines]
    tweet_in_reply_to_user_id_str    = [tweet["in_reply_to_user_id_str"] for tweet in timelines]
    tweet_entities                   = [tweet["entities"] for tweet in timelines]
    tweet_in_reply_to_status_id_str  = [tweet["in_reply_to_status_id_str"] for tweet in timelines]
    tweet_in_reply_to_status_id      = [tweet["in_reply_to_status_id"] for tweet in timelines]
    tweet_text                       = [tweet["text"] for tweet in timelines]
    tweet_contributors               = [tweet["contributors"] for tweet in timelines]
    #tweet_user                       = [tweet["user"] for tweet in timelines]
    tweet_id                         = [tweet["id"] for tweet in timelines]
    tweet_coordinates                = [tweet["coordinates"] for tweet in timelines]
    tweet_in_reply_to_screen_name    = [tweet["in_reply_to_screen_name"] for tweet in timelines]
    #tweet_possibly_sensitive         = [tweet["possibly_sensitive"] for tweet in timelines]
    tweet_favorite_count             = [tweet["favorite_count"] for tweet in timelines]
    tweet_truncated                  = [tweet["truncated"] for tweet in timelines]
    tweet_created_at                 = [tweet["created_at"] for tweet in timelines]
    tweet_favorited                  = [tweet["favorited"] for tweet in timelines]
    tweet_retweet_count              = [tweet["retweet_count"] for tweet in timelines]
    tweet_in_reply_to_user_id        = [tweet["in_reply_to_user_id"] for tweet in timelines]
    tweet_lang                       = [tweet["lang"] for tweet in timelines]
    tweet_source                     = [tweet["source"] for tweet in timelines]
    tweet_geo                        = [tweet["geo"] for tweet in timelines]
    tweet_id_str                     = [tweet["id_str"] for tweet in timelines]
    tweet_place                      = [tweet["place"] for tweet in timelines]
    tweet_is_quote_status            = [tweet["is_quote_status"] for tweet in timelines]

    # Define all tweet USER specific metadata
    tweet_user_statuses_count                       = [tweet["user"]["statuses_count"] for tweet in timelines]
    tweet_user_follow_request_sent                  = [tweet["user"]["follow_request_sent"] for tweet in timelines]
    tweet_user_profile_sidebar_border_color         = [tweet["user"]["profile_sidebar_border_color"] for tweet in timelines]
    tweet_user_default_profile_image                = [tweet["user"]["default_profile_image"] for tweet in timelines]
    tweet_user_entities                             = [tweet["user"]["entities"] for tweet in timelines]
    tweet_user_has_extended_profile                 = [tweet["user"]["has_extended_profile"] for tweet in timelines]
    tweet_user_profile_background_image_url_https   = [tweet["user"]["profile_background_image_url_https"] for tweet in timelines]
    tweet_user_location                             = [tweet["user"]["location"] for tweet in timelines]
    tweet_user_profile_text_color                   = [tweet["user"]["profile_text_color"] for tweet in timelines]
    tweet_user_notifications                        = [tweet["user"]["notifications"] for tweet in timelines]
    tweet_user_id                                   = [tweet["user"]["id"] for tweet in timelines]
    tweet_user_screen_name                          = [tweet["user"]["screen_name"] for tweet in timelines]
    tweet_user_followers_count                      = [tweet["user"]["followers_count"] for tweet in timelines]
    tweet_user_protected                            = [tweet["user"]["protected"] for tweet in timelines]
    tweet_user_is_translator                        = [tweet["user"]["is_translator"] for tweet in timelines]
    tweet_user_profile_image_url_https              = [tweet["user"]["profile_image_url_https"] for tweet in timelines]
    tweet_user_profile_background_tile              = [tweet["user"]["profile_background_tile"] for tweet in timelines]
    tweet_user_name                                 = [tweet["user"]["name"] for tweet in timelines]
    tweet_user_profile_image_url                    = [tweet["user"]["profile_image_url"] for tweet in timelines]
    tweet_user_is_translation_enabled               = [tweet["user"]["is_translation_enabled"] for tweet in timelines]
    tweet_user_following                            = [tweet["user"]["following"] for tweet in timelines]
    tweet_user_default_profile                      = [tweet["user"]["default_profile"] for tweet in timelines]
    tweet_user_profile_background_color             = [tweet["user"]["profile_background_color"] for tweet in timelines]
    tweet_user_time_zone                            = [tweet["user"]["time_zone"] for tweet in timelines]
    tweet_user_friends_count                        = [tweet["user"]["friends_count"] for tweet in timelines]
    tweet_user_favourites_count                     = [tweet["user"]["favourites_count"] for tweet in timelines]
    tweet_user_description                          = [tweet["user"]["description"] for tweet in timelines]
    tweet_user_created_at                           = [tweet["user"]["created_at"] for tweet in timelines]
    tweet_user_profile_use_background_image         = [tweet["user"]["profile_use_background_image"] for tweet in timelines]
    tweet_user_geo_enabled                          = [tweet["user"]["geo_enabled"] for tweet in timelines]
    tweet_user_verified                             = [tweet["user"]["verified"] for tweet in timelines]
    tweet_user_profile_link_color                   = [tweet["user"]["profile_link_color"] for tweet in timelines]
    tweet_user_listed_count                         = [tweet["user"]["listed_count"] for tweet in timelines]
    tweet_user_profile_background_image_url         = [tweet["user"]["profile_background_image_url"] for tweet in timelines]
    tweet_user_profile_sidebar_fill_color           = [tweet["user"]["profile_sidebar_fill_color"] for tweet in timelines]
    tweet_user_utc_offset                           = [tweet["user"]["utc_offset"] for tweet in timelines]
    tweet_user_id_str                               = [tweet["user"]["id_str"] for tweet in timelines]
    #tweet_user_url                                  = [tweet["user"]["url"] for tweet in timelines]
    #tweet_user_profile_banner_url                   = [tweet["user"]["profile_banner_url"] for tweet in timelines]
    tweet_user_contributors_enabled                 = [tweet["user"]["contributors_enabled"] for tweet in timelines]
    tweet_user_lang                                 = [tweet["user"]["lang"] for tweet in timelines]

    # Define custom datetime variables
    #tweet_created_at_datetime                       = [datetime.datetime.strptime(time,'%a %b %d %H:%M:%S %z %Y').timetuple() for time in tweet_created_at]
    tweet_created_at_datetime_offset                = [(datetime.datetime.strptime(time,'%a %b %d %H:%M:%S %z %Y')
                                                        + datetime.timedelta(0, xstr(tweet_user_utc_offset[0]))).strftime('%a %b %d %H:%M:%S %z %Y')
                                                        for time in tweet_created_at]
    #tweet_user_created_at_datetime                  = [datetime.datetime.strptime(time,'%a %b %d %H:%M:%S %z %Y').timetuple() for time in tweet_user_created_at]
    tweet_user_created_at_datetime_offset           = [(datetime.datetime.strptime(time,'%a %b %d %H:%M:%S %z %Y')
                                                        + datetime.timedelta(0, xstr(tweet_user_utc_offset[0]))).strftime('%a %b %d %H:%M:%S %z %Y')
                                                        for time in tweet_user_created_at]

   # NLP Tweet Processing
    tweet_NLP_get_users_mentioned                   = [get_users_mentioned(tweet) for tweet in tweet_text]
    tweet_NLP_get_tags                              = [get_tags(tweet) for tweet in tweet_text]
    tweet_NLP_processTweet                          = [processTweet(tweet) for tweet in tweet_text]
    tweet_NLP_remove_stopwords                      = [remove_stopwords(tweet, STOPWORDS) for tweet in tweet_text]
    tweet_NLP_processTweet                          = [processTweet(tweet) for tweet in tweet_text]

    #tweet_NLP_replaceTwoOrMore                      = [replaceTwoOrMore(processedTweet) for processedTweet in tweet_NLP_processTweet]
    #tweet_NLP_remove_punct                          = [remove_punct(replaceTwoOrMore) for replaceTwoOrMore in tweet_NLP_replaceTwoOrMore]

    # Load all of the required fields into a Pandas DataFrame
    twitter_tl_df =   pd.DataFrame({'tweet_retweeted'  : tweet_retweeted,
                                    'tweet_in_reply_to_user_id_str' : tweet_in_reply_to_user_id_str,
                                    'tweet_entities' : tweet_entities,
                                    'tweet_in_reply_to_status_id_str' : tweet_in_reply_to_status_id_str,
                                    'tweet_in_reply_to_status_id' : tweet_in_reply_to_status_id,
                                    'tweet_text' : tweet_text,
                                    'tweet_contributors' : tweet_contributors,
                                    #'tweet_user' : tweet_user,
                                    'tweet_id' : tweet_id,
                                    'tweet_coordinates' : tweet_coordinates,
                                    'tweet_in_reply_to_screen_name' : tweet_in_reply_to_screen_name,
                                    'tweet_favorite_count' : tweet_favorite_count,
                                    'tweet_truncated' : tweet_truncated,
                                    'tweet_created_at' : tweet_created_at,
                                    'tweet_favorited' : tweet_favorited,
                                    'tweet_retweet_count' : tweet_retweet_count,
                                    'tweet_in_reply_to_user_id' : tweet_in_reply_to_user_id,
                                    'tweet_lang' : tweet_lang,
                                    'tweet_source' : tweet_source,
                                    'tweet_geo' : tweet_geo,
                                    'tweet_id_str' : tweet_id_str,
                                    'tweet_place' : tweet_place,
                                    'tweet_is_quote_status' : tweet_is_quote_status,
                                    'tweet_user_statuses_count' : tweet_user_statuses_count,
                                    'tweet_user_follow_request_sent' : tweet_user_follow_request_sent,
                                    'tweet_user_profile_sidebar_border_color' : tweet_user_profile_sidebar_border_color,
                                    'tweet_user_default_profile_image' : tweet_user_default_profile_image,
                                    'tweet_user_entities' : tweet_user_entities,
                                    'tweet_user_has_extended_profile' : tweet_user_has_extended_profile,
                                    'tweet_user_profile_background_image_url_https' : tweet_user_profile_background_image_url_https,
                                    'tweet_user_location' : tweet_user_location,
                                    'tweet_user_profile_text_color' : tweet_user_profile_text_color,
                                    'tweet_user_notifications' : tweet_user_notifications,
                                    'tweet_user_id' : tweet_user_id,
                                    'tweet_user_screen_name' : tweet_user_screen_name,
                                    'tweet_user_followers_count' : tweet_user_followers_count,
                                    'tweet_user_protected' : tweet_user_protected,
                                    'tweet_user_is_translator' : tweet_user_is_translator,
                                    'tweet_user_profile_image_url_https' : tweet_user_profile_image_url_https,
                                    'tweet_user_profile_background_tile' : tweet_user_profile_background_tile,
                                    'tweet_user_name' : tweet_user_name,
                                    'tweet_user_profile_image_url' : tweet_user_profile_image_url,
                                    'tweet_user_is_translation_enabled' : tweet_user_is_translation_enabled,
                                    'tweet_user_following' : tweet_user_following,
                                    'tweet_user_default_profile' : tweet_user_default_profile,
                                    'tweet_user_profile_background_color' : tweet_user_profile_background_color,
                                    'tweet_user_time_zone' : tweet_user_time_zone,
                                    'tweet_user_friends_count' : tweet_user_friends_count,
                                    'tweet_user_favourites_count' : tweet_user_favourites_count,
                                    'tweet_user_description' : tweet_user_description,
                                    'tweet_user_created_at' : tweet_user_created_at,
                                    'tweet_user_profile_use_background_image' : tweet_user_profile_use_background_image,
                                    'tweet_user_geo_enabled' : tweet_user_geo_enabled,
                                    'tweet_user_verified' : tweet_user_verified,
                                    'tweet_user_profile_link_color' : tweet_user_profile_link_color,
                                    'tweet_user_listed_count' : tweet_user_listed_count,
                                    'tweet_user_profile_background_image_url' : tweet_user_profile_background_image_url,
                                    'tweet_user_profile_sidebar_fill_color' : tweet_user_profile_sidebar_fill_color,
                                    'tweet_user_utc_offset' : tweet_user_utc_offset,
                                    'tweet_user_id_str' : tweet_user_id_str,
                                    #'tweet_user_url' : tweet_user_url,
                                    'tweet_user_contributors_enabled' : tweet_user_contributors_enabled,
                                    'tweet_user_lang' : tweet_user_lang,
                                    'tweet_created_at_datetime_offset' : tweet_created_at_datetime_offset,
                                    'tweet_user_created_at_datetime_offset' : tweet_user_created_at_datetime_offset,
                                    'tweet_NLP_get_users_mentioned' : tweet_NLP_get_users_mentioned,
                                    'tweet_NLP_get_tags' : tweet_NLP_get_tags,
                                    'tweet_NLP_processTweet' : tweet_NLP_processTweet,
                                    'tweet_NLP_remove_stopwords' : tweet_NLP_remove_stopwords,
                                    'tweet_NLP_processTweet' : tweet_NLP_processTweet
                                    #'tweet_NLP_replaceTwoOrMore' : tweet_NLP_replaceTwoOrMore,
                                    #'tweet_NLP_remove_punct' : tweet_NLP_remove_punct
                                   })
    return twitter_tl_df


def concatenate_all_twitter_timelines(screen_names_dir = COMPUTED, timeline_data_dir = TIMELINE_DATA_DIR):
    """ Function to concatenate all twitter timelines from the json timeline file
        for each twitter account
    """
    # Load the json file containing screen names for each twitter timeline
    with open(screen_names_dir + "screen_names.json", "r") as f:
        screen_names = json.load(f)

    # Remove all Null Names
    screen_names = [name for name in screen_names if name is not None]

    # Load all dataframes for the screen names into a singlt list
    frames = [create_twitter_timeline_DataFrame(screen_name, timeline_data_dir = TIMELINE_DATA_DIR) for screen_name \
                                                                                                    in screen_names]

    # Concatenate and union the list of dataframes
    final_out = pd.concat(frames, axis=0)

    return final_out
