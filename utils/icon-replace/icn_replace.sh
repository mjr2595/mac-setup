#!/bin/bash

icon_path=$1
app_path="/Applications/$2.app"

fileicon set $app_path "$1"