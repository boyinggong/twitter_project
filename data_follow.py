import json
import twitter
import csv
from time import sleep
import sys

CONSUMER_KEY       = "LMO6LXCAjzqF0DwO44YNX5PaY"
CONSUMER_SECRET    = "TjmAEUqteMieEAIYVO9VtINBbiNYAHqJr6aEJoUnvIeG3fEKUm"
OAUTH_TOKEN        = "1601903166-8wmp5Ml0zzRdfZzFHtUkUwXTCbsbOdoZYQWWH9u"
OAUTH_TOKEN_SECRET = "Z5gC9jXyHw2LBTIC762jTtUfvT3DEjcHZCDUZfISfOA2N"

auth = twitter.oauth.OAuth(OAUTH_TOKEN, OAUTH_TOKEN_SECRET,
                           CONSUMER_KEY, CONSUMER_SECRET)
api = twitter.Twitter(auth=auth)

def get_users(api_call, user, is_id = False, max_num = None):
    if is_id:
        params = {'user_id': user}
    else:
        params = {'screen_name': user}
    params['count'] = 5000 # highest number of responses available
    current = api_call(**params)
    results = current['ids']
    next_cursor = current['next_cursor']
    calls = 1
    while next_cursor != 0 and (not max_num or len(results) < max_num):
        if calls >= 15:
            break
        current = api_call(**params)
        results += current['ids']
        next_cursor = current['next_cursor']
        calls += 1

    return results[0:max_num] if max_num else results


def get_followers(user, is_id = False, max_num = None):
    """ Returns the ids of users who follow user
    """
    return get_users(api.followers.ids, user = user,
                     is_id = is_id, max_num = max_num)


def get_following(user, is_id = False, max_num = None):
    """ Returns the ids of users followed by USER
    """
    return get_users(api.friends.ids, user = user,
                     is_id = is_id, max_num = max_num)

def get_all_following(users, max_num = None):
    """ Gets the ids of users followed by each user in USER
    """
    follows = []
    i = 0
    while i < len(users):
        if not users[i]:
            follows.append([])
            with open('data/output_data/following/' + str(users[i]) + str(i) + '.json', 'w') as f:
                json.dump([], f, indent = 4)
            i += 1
            continue
        try:
            print('Downloading', users[i])
            follows.append(get_following(users[i], max_num = max_num))
            with open('data/output_data/following/' + users[i] + '.json', 'w') as f:
                json.dump(follows[i], f, indent = 4)
            i += 1
        except twitter.TwitterHTTPError:
            print('Sleeping...')
            sleep(900)

    return follows

def get_all_followers(users, max_num = None):
    """ Gets the ids of users who followed each user in USER
    """
    followers = []
    i = 0
    while i < len(users):
        if not users[i]:
            followers.append([])
            with open('data/output_data/followers/' + str(users[i]) + str(i) + '.json', 'w') as f:
                json.dump([], f, indent = 4)
            i += 1
            continue
        try:
            print('Downloading', users[i])
            followers.append(get_followers(users[i], max_num = max_num))
            with open('data/output_data/followers/' + users[i] + '.json', 'w') as f:
                json.dump(followers[i], f, indent = 4)
            i += 1
        except twitter.TwitterHTTPError:
            print('Sleeping...')
            sleep(900)

    return followers
