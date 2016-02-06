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

def get_url(text):
    r"""Extract the urls in a tweet

    Parameters
    ----------
    text: string

    Returns
    -------
    List of string: 
        each string is a url

    Examples
    --------

    """
    p = ttp.Parser()
    result = p.parse(text)
    return result.urls


def get_users_mentioned(text):
    r"""Extract the urls in a tweet

    Parameters
    ----------
    text: string

    Returns
    -------
    List of string: 
        each string is a screen name of users mentioned by the text

    Examples
    --------

    """
    p = ttp.Parser()
    result = p.parse(text)
    return result.users


def get_tags(text):
    p = ttp.Parser()
    result = p.parse(text)
    return result.tags


def sortFreqDict(freqdict):
    aux = [(freqdict[key], key) for key in freqdict]
    aux.sort()
    aux.reverse()
    return aux


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


def replaceTwoOrMore(s):
    #look for 2 or more repetitions of character and replace with the character itself
    pattern = re.compile(r"(.)\1{1,}", re.DOTALL)
    return pattern.sub(r"\1\1", s)


def remove_punct(word):
    punc = set(string.punctuation)
    punc.remove('-')
    return "".join([a for a in word if a not in punc])


with open("data/input_data/sentiment_analysis/stopwords.txt") as f:
    stopwords = f.read().split('\n')
stopwords.append('ATUSER')
stopwords.append('URL')


def remove_stopwords(tweet, stopwords):
    return " ".join([word for word in tweet.split(" ") if word not in stopwords])


