# My Mac Setup

This repo contains info on all the apps, tools, and settings I use on my Mac

### Automated Setup

Run the [`setup.sh`](setup.sh) script to automate the entire Mac setup process. The script handles:

- Installing Xcode Command Line Tools
- Installing Homebrew
- Installing Oh My Zsh with plugins
- Managing packages via Brewfiles
- Creating necessary directories
- Setting up dotfiles with GNU Stow
- Configuring Git
- Applying macOS system preferences

**Quick start:**

```bash
./setup.sh           # Interactive mode (prompts for each step)
./setup.sh --typical # Typical setup (auto-confirm, skip optional features)
```

The `--typical` flag runs a streamlined setup that automatically confirms all standard steps while skipping:

- Additional profile-specific package installation
- SSH commit signing setup

This is just my current preferred setup.

### macOS System Preferences

The [`macos-defaults.sh`](macos-defaults.sh) script configures macOS system preferences including keyboard repeat rate, Finder settings, Dock customization, screenshot locations, and more. Run it standalone or as part of the main setup script.

### Config Files

Config files are organized by application and managed using [GNU Stow](https://www.gnu.org/software/stow/). See the [configs](./configs/) readme for more deets.

### Homebrew

I use Homebrew to keep packages and apps updated and installed on my computer. I typically keep two Brewfiles -- one for personal use and one for work. See [apps](./apps/) for that stuff.

### Utilities

I also have some helpful scripts n things in this repo. Most of these I integrate with Raycast via Script Commands. For more details, see the [utils](./utils/) directory.

### Themes

I switch up themes pretty often to help spice things up. Sometimes just based on mood or the season...

**Current theme:** [Kanagawa (Kazte)](https://marketplace.visualstudio.com/items?itemName=Kazte.kanagawa-kazte-vscode-color-theme)

Here's a list of some of my past favorites:

- [Ayu](https://github.com/ayu-theme)
  - [Ayu Borderless for Zed](https://github.com/babyccino/Borderless-Ayu-Zed)
- [Gruvbox](https://github.com/morhetz/gruvbox)
  - [Warp term theme](https://gist.github.com/mjr2595/577258b53b2697087e75a5d4a36f668f)
- [Nord](https://www.nordtheme.com/)
  - [Firefox Nord Theme](https://color.firefox.com/?theme=XQAAAAIPAQAAAAAAAABBKYhm849SCia2CaaEGccwS-xMDPr6_CqlFI4MnOwqZESgRUapmIlv11Yd8Tl3BA9DEpHmaalTe_N-82o2XfpjlEZD9MaHq66xpqUpnZQLgP7FSZDiLkGIoS-wHKdSGZbsH8AhJeOCI-lo-g7ehrIiZKyL0gk2rppTmDPrzfzJp_abHb1ly43cSq8Yc7QZAer4ZLwu90zMJiOO__y_wOA) (requires Firefox Color extension)
  - [Chrome Nord Theme](https://chrome.google.com/webstore/detail/nord/abehfkkfjlplnjadfcjiflnejblfmmpj)
- [Dracula](https://draculatheme.com/)
- Atom One Dark
- [Catppuccin](https://github.com/catppuccin/catppuccin) =^.^=
- VS Code Dark Modern

#### Theme aggregators

- [Slack themes](https://gist.github.com/mjr2595/fa63d054ea08bff1fdd848c355fe89df)
- [iTerm themes](https://iterm2colorschemes.com/)
