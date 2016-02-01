import csv
import twitter
import json
from time import sleep

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
        sleep(900)
        timeline = api.statuses.user_timeline(screen_name=screen_name,
                                              count=200, include_rts=1)

    ntweets = len(timeline)
    if ntweets < 200:
        return timeline
    while ntweets == 200 and len(timeline) < 3200:
        min_id = min([tweet["id"] for tweet in timeline])
        try:
            next_timeline = api.statuses.user_timeline(screen_name=screen_name,
                                                       count=200,
                                                       max_id=min_id - 1,
                                                       include_rts=1)
        except:
            print("Reached rate limit; sleeping 15 minutes")
            sleep(900)
            next_timeline = api.statuses.user_timeline(screen_name=screen_name,
                                                       count=200,
                                                       max_id=min_id - 1,
                                                       include_rts=1)
        ntweets = len(next_timeline)
        timeline += next_timeline
    return timeline
