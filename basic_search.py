import json
import twitter
import matplotlib.pyplot as plt

CONSUMER_KEY       = "LMO6LXCAjzqF0DwO44YNX5PaY"
CONSUMER_SECRET    = "TjmAEUqteMieEAIYVO9VtINBbiNYAHqJr6aEJoUnvIeG3fEKUm"
OAUTH_TOKEN        = "1601903166-8wmp5Ml0zzRdfZzFHtUkUwXTCbsbOdoZYQWWH9u"
OAUTH_TOKEN_SECRET = "Z5gC9jXyHw2LBTIC762jTtUfvT3DEjcHZCDUZfISfOA2N"

auth = twitter.oauth.OAuth(OAUTH_TOKEN, OAUTH_TOKEN_SECRET,
                           CONSUMER_KEY, CONSUMER_SECRET)
api = twitter.Twitter(auth=auth)

def get_tweets(q, n = 100):
    tweets = api.search.tweets(q = q, count = 100)['statuses']
    while len(tweets) < n:
        last_id = tweets[-1]['id']
        tweets += api.search.tweets(q = q, count = 100,
                                    max_id = last_id - 1)['statuses']
        print(len(tweets))
    tweets = tweets[0:n]
    return(tweets)

def sentiment_words(file):
    with open(file, encoding = 'latin1') as f:
        words = f.readlines()

    words = [w for w in words if not w.startswith(';')]
    words = [w[0:-1] for w in words]
    return words

negative_words = sentiment_words('negative-words.txt')
positive_words = sentiment_words('positive-words.txt')

def tweet_sentiment(tweet):
    total = 0.0
    for word in tweet.split(' '):
        if word in negative_words:
            total -= 1
        elif word in positive_words:
             total += 1
    return total / len(tweet.split(' '))

def get_timeline(user):
    return(api.statuses.user_timeline(screen_name = user))

def line_plot(data):
    plt.plot(data)
    plt.show()

#tweets = get_tweets("#SuperBowl50", n = 200)
#sentiment = [tweet_sentiment(t['text']) for t in tweets]
#line_plot(sentiment)
