from followers import get_all_following
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

    # cutoff = 0
    # if len(sys.argv) > 1:
    #     cutoff = screen_names.index(sys.argv[1])
    # following = get_all_following(screen_names[cutoff:])


    following = get_all_following(screen_names)
    with open('data/following.json', 'w') as f:
        json.dump(following, f, indent = 4)

    with open('data/input_data/screen_names.json', 'w') as f:
        json.dump(screen_names, f, indent = 4)
