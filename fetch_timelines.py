from data_timelines import retrieve_timeline
from data_setup_OAuth import setup_twitter_OAuth
from data.input_data.twitter_API.twitter_OAuth_keys import all_twitter_OAuth_tokens
from time import sleep
import csv
import twitter
import json

#if __name__ == '__main__':
#    screen_names = []
#    with open("data/input_data/golden_globes_metadata/nominees-spreadsheet-01-29.csv") as f:
#        reader = csv.DictReader(f)
#        for row in reader:
#            current = row['TWITTER_SCREEN_NAME']
#            if not current or current == 'None':
#                current = None
#            else:
#                if current.startswith('@'):
#                    current = current[1:]
#            screen_names.append(current)

screen_names = ['rickygervais']
for screen_name in screen_names:
    # Create the API OAuth connection with SS account
    #setup_twitter_OAuth(SS_TWITTER_OAUTH_TOKEN, SS_TWITTER_OAUTH_TOKEN_SECRET
    #                    , SS_TWITTER_CONSUMER_KEY, SS_TWITTER_CONSUMER_SECRET)
    timelines = retrieve_timeline(screen_name)
    with open('data/output_data/timelines/' + str(screen_name) + '.json', 'w') as f:
        json.dump(timelines, f, indent = 4)

computed = "data/output_data/timelines_computed_data/"
with open(computed + "screen_names.json", "w") as f:
    json.dump(screen_names, f, indent = 4)
