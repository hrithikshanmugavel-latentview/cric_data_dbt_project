import zipfile
import json
import pandas as pd
import os

# Function to check if a file is a JSON file
def is_json_file(file_name):
    return file_name.lower().endswith('.json')

# Function to process a single JSON file
def process_json_file(file_path, combined_df):
    with open(file_path, 'r') as file:
        data = json.load(file)

    match_id = os.path.splitext(os.path.basename(file_path))[0]

    num_dates_columns = 6
    dates_filled = data['info'].get("dates", []) + [None] * (num_dates_columns - len(data['info'].get("dates", [])))

    event_info = data['info'].get("event", {})
    event_name = event_info.get("name", None)
    match_number = event_info.get("match_number", None)
    event_stage = event_info.get("stage", None)

    officials_info = data['info'].get("officials", {})
    match_referees = officials_info.get("match_referees", [])
    reserve_umpires = officials_info.get("reserve_umpires", [])
    tv_umpires = officials_info.get("tv_umpires", [])
    umpires = officials_info.get("umpires", [])

    outcome_info = data['info'].get("outcome", {})
    match_result = outcome_info.get("result", "Winner")
    winner = outcome_info.get("winner", outcome_info.get("eliminator", None))
    by_wickets = outcome_info.get("by", {}).get("wickets", None)
    by_innings = outcome_info.get("by", {}).get("innings", None)
    by_runs = outcome_info.get("by", {}).get("runs", None)
    method = outcome_info.get("method", None)

    team_keys = list(data['info']['players'].keys())

    info = {
        "match_id": [match_id],
        "balls_per_over": [data['info'].get("balls_per_over", None)],
        "city": [data['info'].get("city", None)],
        **{f"dates_{i+1}": [dates_filled[i]] for i in range(num_dates_columns)},

        "event_name": [event_name],
        "match_number": [match_number],
        "event_stage": [event_stage],

        "gender": [data['info'].get("gender", None)],
        "match_type": [data['info'].get("match_type", None)],
        "match_type_number": [data['info'].get("match_type_number", None)],

        "match_referees": [match_referees[0] if match_referees else None],
        "reserve_umpires": [reserve_umpires[0] if reserve_umpires else None],
        "tv_umpires": [tv_umpires[0] if tv_umpires else None],
        "umpire_1": [umpires[0] if umpires else None],
        "umpire_2": [umpires[1] if umpires else None],

        "match_result": [match_result],
        "winner": [winner],
        "by_innings": [by_innings],
        "by_wickets": [by_wickets],
        "by_runs": [by_runs],
        "method": [method],

        "overs": [data['info'].get("overs", None)],
        "player_of_match": [data['info'].get("player_of_match", [None])[0]],
        "season": [data['info'].get("season", None)],
        "team_type": [data['info'].get("team_type", None)],

        "team_1" : team_keys[0],
        "team_2" : team_keys[1],

        "toss_decision": [data['info']['toss'].get("decision", None)],
        "toss_winner": [data['info']['toss'].get("winner", None)],
        "venue": [data['info'].get("venue", None)]
    }

    j = 0

    for team, players in data['info'].get("players", {}).items():
        j += 1
        for i in range(1, 13):
            if i <= len(players):
                info[f"team_{j}_player_{i}"] = [players[i - 1]]
            else:
                info[f"team_{j}_player_{i}"] = [None]

    info_df = pd.DataFrame(info)

    def get_id(name):
      return data['info']['registry']["people"].get(name, None)

    for col in info_df.columns:
      if "player" in col or "umpire" in col or "referee" in col or "player_of_match" in col:
        id_col = col + "_id"
        info_df[id_col] = info_df[col].apply(get_id)

    def is_powerplay(over, ball, powerplay_ranges):
        for powerplay in powerplay_ranges:
            start_over, start_ball = divmod(powerplay['from'], 1)
            start_ball = int(start_ball * 10)
            end_over, end_ball = divmod(powerplay['to'], 1)
            end_ball = int(end_ball * 10)

            if (over > start_over or (over == start_over and ball >= start_ball)) and (
                    over < end_over or (over == end_over and ball <= end_ball)):
                return 'yes'
        return 'no'

    innings_record = []
    delivery_number = 0

    for inning in data.get('innings', []):
        inning_number = data['innings'].index(inning) + 1

        powerplay_ranges = inning.get('powerplays', [])
        super_over_flag = inning.get('super_over', False)

        cumulative_runs = 0
        target_runs = 0
        target_overs = 0
        total_target_balls = 0
        target_remaining = 0
        balls_remaining = 0

        if 'target' in inning:
            target_runs = inning.get('target', {}).get('runs', 0)
            target_overs = inning.get('target', {}).get('overs', 0)
            total_target_balls = target_overs * 6 if target_overs else 0

        for over in inning.get('overs', []):
            over_number = over.get('over', None)

            for delivery in over.get('deliveries', []):
                delivery_number += 1

                over_ball = delivery_number

                powerplay_status = is_powerplay(over_number, over_ball, powerplay_ranges)

                runs_total = delivery.get('runs', {}).get('total', 0)
                cumulative_runs += runs_total

                if total_target_balls != 0:
                    balls_remaining = int(total_target_balls - (delivery_number + (over_number) * 6))
                else:
                    balls_remaining = 0

                if target_runs != 0:
                    target_remaining = target_runs - cumulative_runs
                else:
                    target_remaining = 0

                delivery_data = {
                    'innings': inning_number,
                    'super_over': 'yes' if super_over_flag else None,
                    'team': inning.get('team', None),
                    'over_number': over_number,
                    'delivery_number': delivery_number,
                    'batter': delivery.get('batter', None),
                    'bowler': delivery.get('bowler', None),
                    'non_striker': delivery.get('non_striker', None),
                    'replacement_in': '',
                    'replacement_out': '',
                    'replacement_team': '',
                    'replacement_reason': '',
                    'runs_batter': delivery.get('runs', {}).get('batter', 0),
                    'runs_extras': delivery.get('runs', {}).get('extras', 0),
                    'runs_total': delivery.get('runs', {}).get('total', 0),
                    'powerplay': powerplay_status,
                    'wicket_kind': '',
                    'wicket_player_out': '',
                    'wicket_fielder_1': '',
                    'wicket_fielder_2': '',
                    'extras_wides': 0,
                    'extras_noballs': 0,
                    'extras_byes': 0,
                    'extras_legbyes': 0,
                    'extras_penalty': 0,
                    'review_by': '',
                    'review_umpire': '',
                    'review_batter': '',
                    'review_decision': '',
                    'review_type': '',
                    'review_umpires_call': '',
                    'target_remaining': target_remaining,
                    'balls_remaining': balls_remaining
                }

                if 'replacements' in delivery:
                    replacements = delivery['replacements'].get('match', [])
                    for replacement in replacements:
                        delivery_data['replacement_in'] = replacement.get('in', '')
                        delivery_data['replacement_out'] = replacement.get('out', '')
                        delivery_data['replacement_team'] = replacement.get('team', '')
                        delivery_data['replacement_reason'] = replacement.get('reason', '')

                if 'wickets' in delivery:
                    for i, wicket in enumerate(delivery['wickets']):
                        delivery_data['wicket_kind'] = wicket.get('kind', '')
                        delivery_data['wicket_player_out'] = wicket.get('player_out', '')

                        fielders = wicket.get('fielders', [])
                        if len(fielders) > 0:
                            delivery_data['wicket_fielder_1'] = fielders[0].get('name', '')
                        if len(fielders) > 1:
                            delivery_data['wicket_fielder_2'] = fielders[1].get('name', '')

                if 'extras' in delivery:
                    for extra_type, extra_value in delivery['extras'].items():
                        delivery_data[f'extras_{extra_type}'] = extra_value

                    if 'wides' in delivery['extras'] or 'noballs' in delivery['extras']:
                        delivery_number -= 1

                if 'review' in delivery:
                    review = delivery['review']
                    delivery_data['review_by'] = review.get('by', '')
                    delivery_data['review_umpire'] = review.get('umpire', '')
                    delivery_data['review_batter'] = review.get('batter', '')
                    delivery_data['review_decision'] = review.get('decision', '')
                    delivery_data['review_type'] = review.get('type', '')
                    delivery_data['review_umpires_call'] = review.get('umpires_call', '')

                innings_record.append(delivery_data)

            delivery_number = 0

    innings_df = pd.DataFrame(innings_record)

    # Repeat the info DataFrame for each row of innings_df
    num_innings_rows = len(innings_df)
    info_df_repeated = pd.concat([info_df] * num_innings_rows, ignore_index=True)

    # Concatenate the information and innings data
    combined_df = pd.concat([info_df_repeated, innings_df], axis=1)

    return combined_df

# Path to the zip file containing JSON files
zip_file_path = "C:/Users/hrithik.s.lv/Documents/LV-Projects/ipl_data_project/ipl_json.zip"

# Directory to extract JSON files
extracted_dir ="C:/Users/hrithik.s.lv/Documents/LV-Projects/ipl_data_project/ipl_json_files"

# Extract the zip file
with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
    zip_ref.extractall(extracted_dir)

# List all extracted JSON files
json_files = [f for f in os.listdir(extracted_dir) if is_json_file(f)]

# Initialize an empty DataFrame to store combined data
complete_df = pd.DataFrame()

# Loop through each JSON file
for json_file in json_files:
    json_file_path = os.path.join(extracted_dir, json_file)
    # Process the JSON file and append data to combined_df
    combined_df = process_json_file(json_file_path, complete_df)
    complete_df = pd.concat([complete_df, combined_df], axis=0)

# Save the combined DataFrame to a CSV file
csv_file_path = 'C:/Users/hrithik.s.lv/Documents/LV-Projects/ipl_data_project/all_ipl_match_data.csv'
complete_df.to_csv(csv_file_path, index=False)

