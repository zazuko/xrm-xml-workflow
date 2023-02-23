#!/bin/bash

input_file="../input/example.json"
output_file="./output.ttl"

mapping="mapping.carml.ttl"
temp_mapping="__temp__.ttl"


url="https://github.com/carml/carml-jar/releases/download/carml-jar-1.1.0/carml-jar-rdf4j-1.1.0-0.4.6.jar"
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



