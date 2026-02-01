#!/usr/bin/env bash

# macOS System Preferences Configuration

# Close System Preferences to prevent conflicts
osascript -e 'tell application "System Preferences" to quit'

echo "Applying macOS system preferences..."
echo ""

# ============================================
# General UI/UX
# ============================================
echo "→ Configuring General UI/UX..."

# Note: Most General UI/UX settings are using system defaults

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# ============================================
# Keyboard & Input
# ============================================
echo "→ Configuring Keyboard & Input..."

# Set a fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Set mouse tracking speed
defaults write NSGlobalDomain com.apple.mouse.scaling -int 2

# Set trackpad tracking speed
defaults write NSGlobalDomain com.apple.trackpad.scaling -int 1

# Disable force click and haptic feedback
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool false

# Disable press-and-hold for keys in favor of key repeat
# defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable automatic period substitution (double-space for period)
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# ============================================
# Trackpad
# ============================================
echo "→ Configuring Trackpad..."

# Note: Using default trackpad settings

# Enable tap to click
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable three finger drag
# defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# ============================================
# Finder
# ============================================
echo "→ Configuring Finder..."

# Show hidden files by default
# defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
# defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
# defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
# defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Hide tags in sidebar
defaults write com.apple.finder ShowRecentTags -bool false

# Don't show icons on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# New Finder windows show home directory
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Use list view in all Finder windows by default
# Options: `icnv` (Icon), `clmv` (Column), `glyv` (Gallery), `Nlsv` (List)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes 2>/dev/null || true

# ============================================
# Dock
# ============================================
echo "→ Configuring Dock..."

# Set the icon size of Dock items
defaults write com.apple.dock tilesize -int 44

# Enable magnification
# defaults write com.apple.dock magnification -bool true
# defaults write com.apple.dock largesize -int 64

# Position the Dock on the left
# Options: left, bottom, right
defaults write com.apple.dock orientation -string "left"

# Minimize windows into application icon
# defaults write com.apple.dock minimize-to-application -bool true

# Set minimize/maximize window effect (genie, scale, suck)
defaults write com.apple.dock mineffect -string "scale"

# Show indicator lights for open applications
defaults write com.apple.dock show-process-indicators -bool true

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Remove the auto-hiding Dock delay
# defaults write com.apple.dock autohide-delay -float 0

# Speed up the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0.5

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Disable launch animation when opening an application
defaults write com.apple.dock launchanim -bool false

# Group windows by application in Mission Control
defaults write com.apple.dock expose-group-apps -bool true

# Enable App Exposé gesture
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# Disable Launchpad gesture
defaults write com.apple.dock showLaunchpadGestureEnabled -bool false

# Set bottom-right hot corner to do nothing (1 = disabled)
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-br-modifier -int 0

# ============================================
# Menu Bar
# ============================================
echo "→ Configuring Menu Bar..."

# Show battery percentage
# defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Flash clock time separators
# defaults write com.apple.menuextra.clock FlashDateSeparators -bool false

# Show date in menu bar clock
# defaults write com.apple.menuextra.clock Show24Hour -bool false
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool false
defaults write com.apple.menuextra.clock ShowDate -int 2

# ============================================
# Screenshots
# ============================================
echo "→ Configuring Screenshots..."

# Note: Using default screenshot settings

# Save screenshots to ~/Desktop/Screenshots
mkdir -p "${HOME}/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
# defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# ============================================
# Safari & WebKit
# ============================================
echo "→ Configuring Safari..."

# Note: Using default Safari settings

# Enable the Develop menu and the Web Inspector
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Show the full URL in the address bar
# defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# ============================================
# Terminal
# ============================================
echo "→ Configuring Terminal..."

# Only use UTF-8 in Terminal.app
# defaults write com.apple.terminal StringEncodings -array 4

# Disable Secure Keyboard Entry in Terminal.app
defaults write com.apple.terminal SecureKeyboardEntry -bool false

# ============================================
# Activity Monitor
# ============================================
echo "→ Configuring Activity Monitor..."

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
# defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 102

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# ============================================
# Accessibility
# ============================================
echo "→ Configuring Accessibility..."

# Enable reduce motion
defaults write com.apple.Accessibility ReduceMotionEnabled -bool true

# ============================================
# Time Machine
# ============================================
echo "→ Configuring Time Machine..."

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# ============================================
# Restart Affected Applications
# ============================================
echo ""
echo "Restarting affected applications..."

for app in "Activity Monitor" \
    "cfprefsd" \
    "Dock" \
    "Finder" \
    "SystemUIServer" \
    "Safari"; do
    killall "${app}" &> /dev/null || true
done

echo ""
echo "✓ macOS defaults applied successfully!"
echo ""
echo "Note: Some changes require a logout/restart to take full effect."
