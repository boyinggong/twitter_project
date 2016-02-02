import json
import os
from data_setup_OAuth import setup_twitter_OAuth, twitter
import global_vars
from time import sleep

META_FOLLOWING = global_vars.OUTPUT_DATA_DIR + "/following_metadata/"
META_FOLLOWERS = global_vars.OUTPUT_DATA_DIR + "/followers_metadata/"

FOLLOWING_DIR = global_vars.OUTPUT_DATA_DIR + "/following/"
FOLLOWERS_DIR = global_vars.OUTPUT_DATA_DIR + "/followers/"

CONSUMER_KEY       = "LMO6LXCAjzqF0DwO44YNX5PaY"
CONSUMER_SECRET    = "TjmAEUqteMieEAIYVO9VtINBbiNYAHqJr6aEJoUnvIeG3fEKUm"
OAUTH_TOKEN        = "1601903166-8wmp5Ml0zzRdfZzFHtUkUwXTCbsbOdoZYQWWH9u"
OAUTH_TOKEN_SECRET = "Z5gC9jXyHw2LBTIC762jTtUfvT3DEjcHZCDUZfISfOA2N"

auth, api = setup_twitter_OAuth(OAUTH_TOKEN, OAUTH_TOKEN_SECRET, CONSUMER_KEY, CONSUMER_SECRET)

def get_metadata_batch(users, is_id = False):
    """Get the metadata for a batch of 100 users.
    """
    users = [str(u) for u in users]
    if is_id:
        params = {'user_id': ",".join(users)}
    else:
        params = {'screen_name': ",".join(users)}

    try:
        return api.users.lookup(**params)
    except twitter.TwitterHTTPError as e:
        print(params)
        #print(e)
        print('Sleeping...')
        sleep(900)
        return api.users.lookup(**params)
        
def get_metadata(users, is_id = False):
    """Get the metadata for all users in users.
    """
    metadata = []
    i = 0
    while i < len(users):
        if i + 100 > len(users):
            i2 = len(users)
        else:
            i2 = i + 100
        metadata.append(get_metadata_batch(users[i:i2], is_id = is_id))
        i += 100

    return metadata


def get_following_metadata():
    for filename in os.listdir(FOLLOWING_DIR):
        print("Getting data for: " + filename)
        with open(FOLLOWING_DIR + filename) as f:
            try:
                current_ids = json.load(f)
            except json.JSONDecodeError:
                current_ids = []
        metadata = get_metadata(current_ids, is_id = True)
        with open(META_FOLLOWING + filename, "w") as f:
            json.dump(metadata, f, indent = 4)

def get_followers_metadata():
    for filename in os.listdir(FOLLOWERS_DIR):
        print("Getting data for: " + filename)
        with open(FOLLOWERS_DIR + filename) as f:
            try:
                current_ids = json.load(f)
            except json.JSONDecodeError:
                current_ids = []
        metadata = get_metadata(current_ids, is_id = True)
        with open(META_FOLLOWERS + filename, "w") as f:
            json.dump(metadata, f, indent = 4)



if __name__ == "__main__":
    get_following_metadata()
    #get_following_metadata()
