import plistlib
import json

# Load the .plist file
with open('text_replacements.plist', 'rb') as f:
    plist_data = plistlib.load(f)

# Transform the .plist data to the desired JSON format
json_data = []
for item in plist_data:
    if item.get('shortcut').startswith(":"):
        name = item.get('shortcut').split(":")[1]
    else:
        name = item.get('phrase').split()[0]
    entry = {
        "name": name,
        "text": item['phrase'],
    }
    if 'shortcut' in item:
        entry["keyword"] = item['shortcut']
    json_data.append(entry)

# Save the JSON data to a file
with open('text_replacements.json', 'w', encoding="utf-8") as f:
    json.dump(json_data, f, ensure_ascii=False, indent=2)

print("Conversion complete. JSON file saved as 'text_replacements.json'")
