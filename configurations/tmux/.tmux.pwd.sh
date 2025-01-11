#!/bin/bash

# Take a path and max length as input
INPUT_PATH="$1"
MAX_LENGTH="$2"

# If the arguments are empty, return ????????
if [ -z "$MAX_LENGTH" ] || [ -z "$MAX_LENGTH" ]; then
  echo "????????"
  exit 1
fi

# Truncate /home/username to ~
if [[ "$INPUT_PATH" =~ ^$HOME ]]; then
  INPUT_PATH="~${INPUT_PATH#$HOME}"
fi

# If the path is longer than our character threshold, begin truncation
if [ ${#INPUT_PATH} -gt $MAX_LENGTH ]; then

  # Split the path into an array
  IFS="/"
  read -r -a PATH_PARTS <<< "$INPUT_PATH"
  PATH_PARTS_LENGTH=${#PATH_PARTS[@]}

  # Replace the middle parts of the path with "..." (Ex: ~/.../myFile)
  if [ $PATH_PARTS_LENGTH -gt 3 ]; then
    INPUT_PATH="${PATH_PARTS[0]}/.../${PATH_PARTS[$PATH_PARTS_LENGTH - 1]}"
  fi

  # If the path is STILL too long after truncation, truncate it MORE
  # (Ex: ~/.../supercalifradulis...)
  if [ ${#INPUT_PATH} -gt $MAX_LENGTH ]; then
    INPUT_PATH="${INPUT_PATH:0:$MAX_LENGTH-3}..."
  fi
fi

echo "$INPUT_PATH"