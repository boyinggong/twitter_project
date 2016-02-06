from ttp import ttp
import re

def unshorten_links(shortlinks):
    r"""Follow a list of shortlinks

    Parameters
    ----------
    shortlinks : list of string (shotlinks)

    Returns
    -------
    List of string:
        each string is an unshortened link

    Examples
    --------

    """
    urls = []
    for shortlink in shortlinks:
        try:
            request_results = requests.head(shortlink, allow_redirects=True)
            urls.append(request_results.url)
        except Exception:
            pass
    return urls

def get_url(tweet):
    r"""Extract the urls in a tweet

    Parameters
    ----------
    tweet: string

    Returns
    -------
    List of string:
        each string is a url

    Examples
    --------

    """
    p = ttp.Parser()
    result = p.parse(tweet)
    return result.urls


def get_users_mentioned(tweet):
    r"""Extract the urls in a tweet

    Parameters
    ----------
    tweet: string

    Returns
    -------
    List of string:
        each string is a screen name of users mentioned by the tweet

    Examples
    --------

    """
    p = ttp.Parser()
    result = p.parse(tweet)
    return result.users


def get_tags(tweet):
    p = ttp.Parser()
    result = p.parse(tweet)
    return result.tags

def remove_stopwords(tweet, stopwords):
    return " ".join([word for word in tweet.split(" ") if word not in stopwords])

def processTweet(tweet):
    #Convert to lower case
    tweet = tweet.lower()
    #Convert www.* or https?://* to URL
    tweet = re.sub('((www\.[^\s]+)|(https?://[^\s]+))','URL',tweet)
    #Convert @username to AT_USER
    tweet = re.sub('@[^\s]+','AT_USER',tweet)
    #Remove additional white spaces
    tweet = re.sub('[\s]+', ' ', tweet)
    #Replace #word with word
    tweet = re.sub(r'#([^\s]+)', r'\1', tweet)
    #trim
    tweet = tweet.strip('\'"')
    return tweet


def replaceTwoOrMore(processedTweet):
    #look for 2 or more repetitions of character and replace with the character itself
    pattern = re.compile(r"(.)\1{1,}", re.DOTALL)
    return pattern.sub(r"\1\1", processedTweet)


def remove_punct(replaceTwoOrMoreTweet):
    punc = set(string.punctuation)
    punc.remove('-')
    return "".join([a for a in replaceTwoOrMoreTweet if a not in punc])

def sortFreqDict(freqdict):
    aux = [(freqdict[key], key) for key in freqdict]
    aux.sort()
    aux.reverse()
    return aux
