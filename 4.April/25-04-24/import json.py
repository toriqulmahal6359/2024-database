import json
import csv

def json_to_csv(json_file, csv_file):
    with open(json_file, 'r') as f:
        data = json.load(f)


    if isinstance(data, list) and all(isinstance(item, dict) for item in data):
        fieldnames = data[0].keys()
        with open(csv_file, 'w', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(data)
    else:
        print("Invalid JSON format. Expected a list of dictionaries.")


json_to_csv('js.json', 'output.csv')