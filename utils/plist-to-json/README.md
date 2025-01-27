# Convert macOS text replacement plist to JSON

This script converts a macOS text replacement plist file to a JSON file for importing as Raycast snippets.

## Requirements

- Python 3.6+
- macOS
- Raycast (optional but kinda the point)

## Usage

First, export existing macOS text replacements to a plist file. You can do this by going to System Preferences > Keyboard > Text Replacements...

Select all (Cmd + A) and drag the selected items to a folder to create a `Text Substitution.plist` file. Rename this file to `text_replacements.plist`.

Then, run the script:

```sh
python plist_to_json.py
```

This will create a `text_replacements.json` file in the same directory. You can then import this into Raycast. Open Raycast and type 'Import Snippets' to import the JSON file. More info on importing snippets can be found [here](https://manual.raycast.com/snippets/how-to-import-snippets).
