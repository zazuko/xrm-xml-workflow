#!/bin/bash

# This script watches for changes in the mapping file and runs the transformation automatically whenever the mapping file changes.
# It requires that "inotifywait" is installed on the system.
# It downloads and invokes carml-jar directly (different from the default pipeline which is using carml-service).

input_file="../input/example.json"
output_file="../output/dev-transformed.ttl"

mapping="mapping-json.carml.ttl"
temp_mapping="__temp__.ttl"


url="https://github.com/carml/carml-jar/releases/download/v1.3.0/carml-jar-rdf4j-1.3.0-0.4.9.jar"
destination="./carml-jar.jar"

# Check if the file already exists
if [ -f "$destination" ]; then
  echo "Using $destination."
else
  # Download the file using curl
  curl -L "$url" -o "$destination"

  # Check if the download was successful
  if [ $? -eq 0 ]; then
    echo "Downloaded $destination."
  else
    echo "An error occurred while downloading $url."
  fi
fi

echo "Listening to changes of $mapping"
while inotifywait -e modify $mapping
do

    # Just removes "carml:streamName "stdin"" so carml executes
    sed '/carml:streamName "stdin"/d' "$mapping" > "$temp_mapping"
    echo 'triplifying'
    cat $input_file | java -jar carml-jar.jar map -m ./$temp_mapping > $output_file
    rm $temp_mapping
done



