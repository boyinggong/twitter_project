from data_follow import get_all_following
import csv

if __name__ == '__main__':
    screen_names = []
    with open("data/input_data/golden_globes_metadata/nominees-spreadsheet-01-29.csv") as f:
        reader = csv.DictReader(f)
        for row in reader:
            current = row['TWITTER_SCREEN_NAME']
            if not current or current == 'None':
                current = None
            else:
                if current.startswith('@'):
                    current = current[1:]
            screen_names.append(current)

    following = get_all_following(screen_names, max_num = 5000)

    computed = "data/output_data/following_computed_data/"
    with open(computed + 'following.json', 'w') as f:
        json.dump(following, f, indent = 4)
    
    with open(computed + "screen_names.json") as f:
        json.dump(screen_names, f, indent = 4)
