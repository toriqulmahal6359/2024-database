import json
import csv
import os

def json_to_csv(json_file, output_dir, max_records_per_file=1048576):
    # Read JSON file
    with open(json_file, 'r') as f:
        data = json.load(f)

    # Create output directory if it doesn't exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Write to CSV files
    file_count = 0
    current_records = 0
    while current_records < len(data):
        csv_file = os.path.join(output_dir, f'output_{file_count}.csv')
        with open(csv_file, 'w', newline='') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=data[0].keys())
            writer.writeheader()
            for row in data[current_records:current_records+max_records_per_file]:
                writer.writerow(row)
            current_records += max_records_per_file
        print(f'CSV file {csv_file} created.')
        file_count += 1

# Example usage:
json_file = 'input.json'
output_dir = 'output_csv'
json_to_csv(json_file, output_dir)
