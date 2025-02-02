#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title bblist
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🍼
# @raycast.argument1 { "type": "text", "placeholder": "url" }
# @raycast.argument2 { "type": "text", "placeholder": "title" }

# Args from raycast
url="$1"
title="$2"

# URL encode helper function
urlencode() {
    local string="$1"
    local strlen=${#string}
    local encoded=""
    local pos c o
    
    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9] ) o="${c}" ;;
            * )               printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done
    echo "${encoded}"
}

encoded_url=$(urlencode "$url")
encoded_title=$(urlencode "$title")

babylist_url="https://www.babylist.com/add_reg_item?u=${encoded_url}&t=${encoded_title}"

# Print stuff 
echo "Original URL: $url"
echo "Original Title: $title"
echo -e "\nBabylist Add Link:"
echo "$babylist_url"

# Open URL in default browser based on OS
case "$(uname -s)" in
    Darwin*)    # macOS
        open "$babylist_url"
        ;;
    Linux*)     # Linux
        xdg-open "$babylist_url" 2>/dev/null || sensible-browser "$babylist_url" 2>/dev/null || x-www-browser "$babylist_url" 2>/dev/null || gnome-open "$babylist_url"
        ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)  # Windows
        start "$babylist_url"
        ;;
    *)
        echo "Unsupported operating system. Please open the URL manually."
        ;;
esac
