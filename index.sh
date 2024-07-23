#!/bin/bash

# URL of the file to download
URL="https://s3.amazonaws.com/"

# Desired output file name
OUTPUT_FILE="archive.tar.gz"

# Download the file with the specified name
curl -o $OUTPUT_FILE "$URL"

# Extract the file
tar -xzf $OUTPUT_FILE

# Use stream editor to remove single quotes from the file
sed "s/'//g" test.csv > cleaned_test.csv

# Insert the data into the database CH
clickhouse-client --host=200.12.12.12 --user=user_name --password='password' --query="INSERT INTO test.test_csv_table FORMAT CSVWithNames" < cleaned_test.csv

# Insert the data into the database MySQL
mysql -u user_name -p your_database_name -e "
LOAD DATA LOCAL INFILE '/home/user/cleaned_test.csv'
INTO TABLE test
FIELDS TERMINATED BY ','
ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;"
