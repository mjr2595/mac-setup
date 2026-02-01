#!/usr/bin/env bash

# Homebrew Installation Script with Profile Support
# Usage: ./brew-install.sh [personal|work|all]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$SCRIPT_DIR/Brewfile"
TEMP_BREWFILE="$SCRIPT_DIR/.Brewfile.tmp"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo "Usage: $0 [common|personal|work|all|addon]"
    echo ""
    echo "Options:"
    echo "  common    - Install only common packages (default)"
    echo "  personal  - Install common + personal-specific packages"
    echo "  work      - Install common + work-specific packages"
    echo "  all       - Install everything (personal + work)"
    echo "  addon     - Install base profile, then interactively add packages from other profile"
    echo ""
    echo "If no option is provided, common packages will be installed."
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

check_homebrew() {
    if ! command -v brew &> /dev/null; then
        print_error "Homebrew is not installed"
        echo ""
        echo "Install Homebrew first:"
        echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        exit 1
    fi
    print_success "Homebrew is installed"
}

filter_brewfile() {
    local profile=$1
    
    if [ "$profile" == "all" ]; then
        # Install everything - just copy the file but remove profile markers
        sed -E '/^# (PROFILE|END):/d' "$BREWFILE" > "$TEMP_BREWFILE"
    elif [ "$profile" == "common" ]; then
        # Install only common packages - exclude everything in PROFILE sections
        awk '
            /^# PROFILE:/ { skip = 1; next }
            /^# END:/ { skip = 0; next }
            !skip { print }
        ' "$BREWFILE" > "$TEMP_BREWFILE"
    else
        # Filter based on profile (personal or work)
        awk -v profile="$profile" '
            BEGIN { 
                skip = 0
                in_other_profile = 0
            }
            /^# PROFILE:/ {
                if ($0 ~ "PROFILE:" profile) {
                    skip = 0
                    in_other_profile = 0
                    next
                } else {
                    skip = 1
                    in_other_profile = 1
                    next
                }
            }
            /^# END:/ {
                if (in_other_profile) {
                    skip = 0
                    in_other_profile = 0
                    next
                }
            }
            !skip { print }
        ' "$BREWFILE" > "$TEMP_BREWFILE"
    fi
}

install_packages() {
    local profile=$1
    
    print_info "Filtering Brewfile for profile: $profile"
    filter_brewfile "$profile"
    
    print_info "Installing packages..."
    echo ""
    
    if brew bundle --file="$TEMP_BREWFILE"; then
        print_success "All packages installed successfully!"
    else
        print_warning "Some packages failed to install. Check the output above."
    fi
    
    # Clean up temp file
    rm -f "$TEMP_BREWFILE"
}

get_profile_specific_packages() {
    local profile=$1
    awk -v profile="$profile" '
        BEGIN { in_profile = 0 }
        /^# PROFILE:/ {
            if ($0 ~ "PROFILE:" profile) {
                in_profile = 1
            }
            next
        }
        /^# END:/ {
            if (in_profile) {
                in_profile = 0
            }
            next
        }
        in_profile && /^(brew|cask|mas)/ {
            # Extract package name (second field, remove quotes)
            gsub(/"/, "", $2)
            print $2
        }
    ' "$BREWFILE"
}

is_installed() {
    local package=$1
    brew list --formula "$package" &>/dev/null || brew list --cask "$package" &>/dev/null
}

interactive_addon() {
    local base_profile=$1
    local addon_profile=$2
    
    print_info "Getting packages from $addon_profile profile..."
    
    # Get packages from addon profile
    mapfile -t addon_packages < <(get_profile_specific_packages "$addon_profile")
    
    if [ ${#addon_packages[@]} -eq 0 ]; then
        print_warning "No packages found in $addon_profile profile"
        return
    fi
    
    # Filter out already installed packages
    local available_packages=()
    local package_descriptions=()
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^#\ PROFILE:$addon_profile ]]; then
            in_section=1
            continue
        fi
        if [[ "$line" =~ ^#\ END:$addon_profile ]]; then
            break
        fi
        if [[ $in_section -eq 1 ]] && [[ "$line" =~ ^(brew|cask)[[:space:]]+\"([^\"]+)\"[[:space:]]*#[[:space:]]*(.+)$ ]]; then
            local pkg="${BASH_REMATCH[2]}"
            local desc="${BASH_REMATCH[3]}"
            if ! is_installed "$pkg"; then
                available_packages+=("$pkg")
                package_descriptions+=("$desc")
            fi
        elif [[ $in_section -eq 1 ]] && [[ "$line" =~ ^(brew|cask)[[:space:]]+\"([^\"]+)\" ]]; then
            local pkg="${BASH_REMATCH[2]}"
            if ! is_installed "$pkg"; then
                available_packages+=("$pkg")
                package_descriptions+=("")
            fi
        fi
    done < <(awk -v profile="$addon_profile" '
        /^# PROFILE:/ { if ($0 ~ "PROFILE:" profile) print_section=1; next }
        /^# END:/ { if (print_section) print_section=0; next }
        print_section { print }
    ' "$BREWFILE")
    
    if [ ${#available_packages[@]} -eq 0 ]; then
        print_success "All $addon_profile packages are already installed!"
        return
    fi
    
    echo ""
    echo "Available packages from $addon_profile profile:"
    echo ""
    for i in "${!available_packages[@]}"; do
        local num=$((i + 1))
        local pkg="${available_packages[$i]}"
        local desc="${package_descriptions[$i]}"
        if [ -n "$desc" ]; then
            printf "  %2d) %-30s # %s\n" "$num" "$pkg" "$desc"
        else
            printf "  %2d) %s\n" "$num" "$pkg"
        fi
    done
    
    echo ""
    echo "Enter package numbers to install (space-separated), 'all', or 'none':"
    read -p "> " selection
    
    if [[ "$selection" == "none" ]] || [[ -z "$selection" ]]; then
        print_info "No additional packages selected"
        return
    fi
    
    local packages_to_install=()
    
    if [[ "$selection" == "all" ]]; then
        packages_to_install=("${available_packages[@]}")
    else
        for num in $selection; do
            if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#available_packages[@]}" ]; then
                local idx=$((num - 1))
                packages_to_install+=("${available_packages[$idx]}")
            fi
        done
    fi
    
    if [ ${#packages_to_install[@]} -eq 0 ]; then
        print_warning "No valid packages selected"
        return
    fi
    
    echo ""
    print_info "Installing selected packages..."
    for pkg in "${packages_to_install[@]}"; do
        echo "  - $pkg"
    done
    echo ""
    
    read -p "Continue? [Y/n]: " confirm
    if [[ "$confirm" =~ ^[Nn]$ ]]; then
        print_warning "Installation cancelled"
        return
    fi
    
    # Install each package
    for pkg in "${packages_to_install[@]}"; do
        # Determine if it's a formula or cask
        if grep -q "^brew \"$pkg\"" "$BREWFILE"; then
            brew install "$pkg"
        elif grep -q "^cask \"$pkg\"" "$BREWFILE"; then
            brew install --cask "$pkg"
        fi
    done
    
    print_success "Additional packages installed!"
}

# Main script
main() {
    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║   Homebrew Package Installation        ║"
    echo "╚════════════════════════════════════════╝"
    echo ""
    
    check_homebrew
    
    local profile="common"
    local addon_mode=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            common|personal|work|all)
                profile="$1"
                shift
                ;;
            addon)
                addon_mode=true
                shift
                ;;
            -h|--help)
                print_usage
                exit 0
                ;;
            *)
                print_error "Invalid argument: $1"
                print_usage
                exit 1
                ;;
        esac
    done
    
    if [ "$addon_mode" = true ]; then
        echo ""
        echo "Select base profile:"
        echo "  1) Common (shared packages only)"
        echo "  2) Work (common + work packages)"
        echo "  3) Personal (common + personal packages)"
        echo ""
        read -p "Enter choice [1-3]: " base_choice
        
        case "$base_choice" in
            1)
                profile="common"
                echo ""
                echo "Select addon profile:"
                echo "  1) Personal"
                echo "  2) Work"
                echo ""
                read -p "Enter choice [1-2]: " addon_choice
                case "$addon_choice" in
                    1)
                        addon_profile="personal"
                        ;;
                    2)
                        addon_profile="work"
                        ;;
                    *)
                        print_error "Invalid choice"
                        exit 1
                        ;;
                esac
                ;;
            2)
                profile="work"
                addon_profile="personal"
                ;;
            3)
                profile="personal"
                addon_profile="work"
                ;;
            *)
                print_error "Invalid choice"
                exit 1
                ;;
        esac
        
        echo ""
        print_info "Selected base profile: $profile"
        echo ""
        
        read -p "Install $profile packages first? [Y/n]: " confirm
        if [[ ! "$confirm" =~ ^[Nn]$ ]]; then
            install_packages "$profile"
            echo ""
        fi
        
        print_info "Now selecting additional packages from $addon_profile profile..."
        interactive_addon "$profile" "$addon_profile"
        
        echo ""
        print_success "Setup complete!"
        echo ""
    else
        echo ""
        print_info "Selected profile: $profile"
        echo ""
        
        echo ""
        install_packages "$profile"
        
        echo ""
        print_success "Installation complete!"
        echo ""
        print_info "Tip: Run 'brew bundle cleanup --file=$SCRIPT_DIR/Brewfile' to remove packages not in Brewfile"
        echo ""
    fi
}

main "$@"
