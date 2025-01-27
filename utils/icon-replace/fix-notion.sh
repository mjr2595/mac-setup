#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title fix-notion
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🪄

home_directory="$HOME"
icon_path="$home_directory/mac-setup/mac-icons/notion.icns"
app_path="/Applications/Notion.app"

fileicon set $app_path $icon_path