import csv
import twitter
import json
from time import sleep

# Shamindra Shrotriya - Twitter

SS_TWITTER_CONSUMER_KEY       = "Fo3zBsDzYkgJswA5Enn9L2hcR"
SS_TWITTER_CONSUMER_SECRET    = "JcN1kOm1uXC0u3U4BBN6Y6Kc452qCE17LTWps1vkfGd9ZvyFJk"
SS_TWITTER_OAUTH_TOKEN        = "315778828-E9zzE6i87aUREHpkXZB6ldxsnOLRT8WOrtbadL5a"
SS_TWITTER_OAUTH_TOKEN_SECRET = "VecnqjlDK2SI9FQd2DsK90inuifKkrgRZvUvaV24oZCmd"

# Boying Gong - Twitter

BG_TWITTER_CONSUMER_KEY       = "NFTdl27ubL1ruPEPVa3euHsqT"
BG_TWITTER_CONSUMER_SECRET    = "bHLU1yYwQEH1Unc645QH9wyURYchPdB83beN443mxpPMN6WH7p"
BG_TWITTER_OAUTH_TOKEN        = "3322914241-iu6NRqyQJ0TM9jbsmwntuO6rrQDXn9keERoWoWe"
BG_TWITTER_OAUTH_TOKEN_SECRET = "VuqiVIjSjq3A6V08jH13Vbj4qBvkDyt7naOFF3irI73Fn"

# Jianlong Huang - Twitter

JH_TWITTER_CONSUMER_KEY       = "8pDwG3fq5CQT3vDYlnQK6y6cb"
JH_TWITTER_CONSUMER_SECRET    = "urx2YkHWQWg6hHg3pPlzw3FfyvbQvyAu2Hq042Uuuwij1CXS4a"
JH_TWITTER_OAUTH_TOKEN        = "434717374-p29GfGmqvTW1MF7SRgVrou4SMm7zQAQzeKr3mLi7"
JH_TWITTER_OAUTH_TOKEN_SECRET = "IxVuHgpWC8lHYKnUdhHpA0LDraBmBo9Vi9GsIVCXBSAak"

# Tomofumi Ogawa - Twitter

TO_TWITTER_CONSUMER_KEY       = "Ukogd0UXMAdwmIfyPGjIGBjkj"
TO_TWITTER_CONSUMER_SECRET    = "syQtbGDHtfOrJ9uDYqmvpIATHTX8LhI6tdUc8rK0Zu5jbLetDA"
TO_TWITTER_OAUTH_TOKEN        = "4833848663-5SqGTuJDBUI778inTbTRWQaRM5cH2R6iJFp5uGY"
TO_TWITTER_OAUTH_TOKEN_SECRET = "atUAEyMI1hp8MT3f2hGhteyU5h9atCqUGIgbm4fgFgjaS"

auth = twitter.oauth.OAuth(TO_TWITTER_OAUTH_TOKEN, TO_TWITTER_OAUTH_TOKEN_SECRET,
                           TO_TWITTER_CONSUMER_KEY, TO_TWITTER_CONSUMER_SECRET)
api = twitter.Twitter(auth=auth)

def retrieve_timeline(screen_name):
    """ Gets the twitter timeline of the user as specified by their twitter
        screen_name e.g for the actor Leonardo DiCaprio use "LeoDiCaprio"
        (without quotes) to fetch his timeline tweets
    """
    print("Beginning retrieval of " + screen_name)
    try:
        timeline = api.statuses.user_timeline(screen_name=screen_name,
                                              count=200, include_rts=1)
    except:
        print("Reached rate limit; sleeping 15 minutes")
        # sleep(900)
        timeline = api.statuses.user_timeline(screen_name=screen_name,
                                              count=200, include_rts=1)

    ntweets = len(timeline)
    if ntweets < 200:
        return timeline
    while ntweets == 200 and len(timeline) < 3000:
        min_id = min([tweet["id"] for tweet in timeline])
        try:
            next_timeline = api.statuses.user_timeline(screen_name=screen_name,
                                                       count=200,
                                                       max_id=min_id - 1,
                                                       include_rts=1)
        except:
            print("Reached rate limit; sleeping 15 minutes")
            # sleep(900)
            next_timeline = api.statuses.user_timeline(screen_name=screen_name,
                                                       count=200,
                                                       max_id=min_id - 1,
                                                       include_rts=1)
        ntweets = len(next_timeline)
        timeline += next_timeline
    return timeline
