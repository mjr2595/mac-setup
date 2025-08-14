#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title rand
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🔀

# Path to music favorites file
FILE=~/mac-setup/apps/Sync/Browser/Pomo/music-favs.md

# Check if file exists
if [[ ! -f "$FILE" ]]; then
    echo "File not found: $FILE"
    exit 1
fi

# Read lines and extract title and bracket value
titles=()
ids=()
while IFS='|' read -r _ title link _; do
    # Skip header lines
    [[ "$title" =~ Title ]] && continue
    [[ "$title" =~ -+ ]] && continue
    # Trim whitespace
    title=$(echo "$title" | xargs)
    # Extract bracket value
    if [[ "$link" =~ \[([^\]]+)\] ]]; then
        ids+=("${BASH_REMATCH[1]}")
        titles+=("$title")
    fi
done < "$FILE"

# Check if array is empty
if [[ ${#ids[@]} -eq 0 ]]; then
    echo "No items found in brackets."
    exit 1
fi

# Pick a random index
idx=$((RANDOM % ${#ids[@]}))

# Copy bracket value to clipboard
echo -n "${ids[$idx]}" | pbcopy

# Output the name
echo "Let's jam to ${titles[$idx]}"