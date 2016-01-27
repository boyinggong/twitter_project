import json
import twitter

CONSUMER_KEY       = "LMO6LXCAjzqF0DwO44YNX5PaY"
CONSUMER_SECRET    = "TjmAEUqteMieEAIYVO9VtINBbiNYAHqJr6aEJoUnvIeG3fEKUm"
OAUTH_TOKEN        = "1601903166-8wmp5Ml0zzRdfZzFHtUkUwXTCbsbOdoZYQWWH9u"
OAUTH_TOKEN_SECRET = "Z5gC9jXyHw2LBTIC762jTtUfvT3DEjcHZCDUZfISfOA2N"

auth = twitter.oauth.OAuth(OAUTH_TOKEN, OAUTH_TOKEN_SECRET,
                           CONSUMER_KEY, CONSUMER_SECRET)
api = twitter.Twitter(auth=auth)


