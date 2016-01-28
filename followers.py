import json
import twitter

CONSUMER_KEY       = "LMO6LXCAjzqF0DwO44YNX5PaY"
CONSUMER_SECRET    = "TjmAEUqteMieEAIYVO9VtINBbiNYAHqJr6aEJoUnvIeG3fEKUm"
OAUTH_TOKEN        = "1601903166-8wmp5Ml0zzRdfZzFHtUkUwXTCbsbOdoZYQWWH9u"
OAUTH_TOKEN_SECRET = "Z5gC9jXyHw2LBTIC762jTtUfvT3DEjcHZCDUZfISfOA2N"

auth = twitter.oauth.OAuth(OAUTH_TOKEN, OAUTH_TOKEN_SECRET,
                           CONSUMER_KEY, CONSUMER_SECRET)
api = twitter.Twitter(auth=auth)

def get_followers(user, is_id = False):
    """ Returns the ids of users who follow user
    """
    if is_id:
        params = {'user_id': user}
    else:
        params = {'screen_name': user}
    followers = []
    followers += api.followers.ids(**params)['ids']
    return followers

def get_following(screen_name, user_id):
    """ Returns the ids of users followed by USER
    """
    return None

