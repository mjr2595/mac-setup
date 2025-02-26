#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title rand
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🔀

# File path
FILE=~/mac-setup/apps/Sync/Browser/Pomo/music-favs.md

# Check if file exists
if [[ ! -f "$FILE" ]]; then
    echo "File not found: $FILE"
    exit 1
fi

# Extract text inside brackets and store in an array
items=()
while IFS= read -r line; do
    while [[ "$line" =~ \[([^]]+)\] ]]; do
        items+=("${BASH_REMATCH[1]}")
        line=${line#*]}
    done
done < "$FILE"

# Check if array is empty
if [[ ${#items[@]} -eq 0 ]]; then
    echo "No items found in brackets."
    exit 1
fi

# Pick a random item
random_item=${items[RANDOM % ${#items[@]}]}

# Copy to clipboard
echo -n "$random_item" | pbcopy

echo "Copied to clipboard: $random_item"