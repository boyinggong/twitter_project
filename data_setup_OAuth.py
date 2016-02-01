from __future__ import division, print_function

import twitter

def setup_twitter_OAuth(OAUTH_TOKEN, OAUTH_TOKEN_SECRET, CONSUMER_KEY, CONSUMER_SECRET):
    """ This is used to create 2 variables "auth" and "api"
        which set up the key twitter OAuth connections per the
        keys provided
        This function should be called within another function that
        runs the actual twitter api queries
    """
    global auth
    global api
    auth = twitter.oauth.OAuth(OAUTH_TOKEN, OAUTH_TOKEN_SECRET,
                               CONSUMER_KEY, CONSUMER_SECRET)
    api = twitter.Twitter(auth=auth)
    return auth, api
