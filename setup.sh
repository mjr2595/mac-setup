#!/usr/bin/env bash

# macOS Setup Script
# Complete setup automation for fresh Mac or existing system refresh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TYPICAL_SETUP=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================
# Helper Functions
# ============================================

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -t, --typical    Run typical setup (auto-confirm all except profile packages and SSH signing)"
    echo "  -h, --help       Show this help message"
    echo ""
}

print_header() {
    local text="  $1"
    local width=40
    local padding=$((width - ${#text}))
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    printf "${CYAN}║${NC}%-${width}s${CYAN}║${NC}\n" "$text"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
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

prompt_confirm() {
    local message="$1"
    local skip_in_typical="${2:-no}"  # second param: "skip" means return false in typical mode
    
    # In typical setup mode
    if [ "$TYPICAL_SETUP" = true ]; then
        if [ "$skip_in_typical" = "skip" ]; then
            return 1  # Return false (N)
        else
            return 0  # Return true (Y)
        fi
    fi
    
    # Normal interactive mode
    read -p "$(echo -e ${BLUE}?${NC}) $message [Y/n]: " response
    [[ -z "$response" || "$response" =~ ^[Yy]$ ]]
}

# ============================================
# Installation Functions
# ============================================

install_xcode_tools() {
    print_header "Xcode Command Line Tools"
    
    if xcode-select -p &> /dev/null; then
        print_success "Xcode Command Line Tools already installed"
        return 0
    fi
    
    if prompt_confirm "Install Xcode Command Line Tools?"; then
        print_info "Installing Xcode Command Line Tools..."
        xcode-select --install
        print_warning "Press any key after installation completes..."
        read -n 1 -s -r
        print_success "Xcode Command Line Tools installed"
    else
        print_warning "Skipped Xcode Command Line Tools installation"
    fi
}

install_homebrew() {
    print_header "Homebrew Package Manager"
    
    if command -v brew &> /dev/null; then
        print_success "Homebrew already installed: $(brew --version | head -n1)"
        
        if prompt_confirm "Update Homebrew?"; then
            brew update
            print_success "Homebrew updated"
        fi
        return 0
    fi
    
    if prompt_confirm "Install Homebrew?"; then
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        print_success "Homebrew installed"
    else
        print_warning "Skipped Homebrew installation"
    fi
}

install_oh_my_zsh() {
    print_header "Oh My Zsh"
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_success "Oh My Zsh already installed"
        return 0
    fi
    
    if prompt_confirm "Install Oh My Zsh?"; then
        print_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        
        # Install zsh-autosuggestions plugin
        if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
            print_info "Installing zsh-autosuggestions plugin..."
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        fi
        
        print_success "Oh My Zsh installed"
    else
        print_warning "Skipped Oh My Zsh installation"
    fi
}

disable_last_login() {
    print_header "Terminal Preferences"
    
    if [ -f "$HOME/.hushlogin" ]; then
        print_success ".hushlogin already exists"
        return 0
    fi
    
    if prompt_confirm "Disable 'Last login' message in terminal?"; then
        touch "$HOME/.hushlogin"
        print_success "Created .hushlogin file"
    else
        print_warning "Skipped .hushlogin creation"
    fi
}

install_packages() {
    print_header "Homebrew Packages & Applications"
    
    if [ ! -f "$SCRIPT_DIR/apps/brew-install.sh" ]; then
        print_error "brew-install.sh not found in apps directory"
        return 1
    fi
    
    if prompt_confirm "Install common packages via Brewfile?"; then
        cd "$SCRIPT_DIR/apps"
        chmod +x brew-install.sh
        ./brew-install.sh common
        cd "$SCRIPT_DIR"
        
        # Offer to install additional packages
        echo ""
        if prompt_confirm "Install additional profile-specific packages?" "skip"; then
            echo ""
            echo "Select profile to add:"
            echo "  1) Personal packages"
            echo "  2) Work packages"
            echo "  3) All packages"
            echo "  4) Interactive addon mode"
            echo ""
            read -p "Enter choice [1-4] or press Enter to skip: " pkg_choice
            
            case "$pkg_choice" in
                1)
                    "$SCRIPT_DIR/apps/brew-install.sh" personal
                    ;;
                2)
                    "$SCRIPT_DIR/apps/brew-install.sh" work
                    ;;
                3)
                    "$SCRIPT_DIR/apps/brew-install.sh" all
                    ;;
                4)
                    "$SCRIPT_DIR/apps/brew-install.sh" addon
                    ;;
                *)
                    print_info "Skipping additional packages"
                    ;;
            esac
        fi
    else
        print_warning "Skipped package installation"
    fi
}

create_directories() {
    print_header "Creating Directories"
    
    local dirs=("$HOME/Dev" "$HOME/Documents/Notes")
    
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            print_success "Directory exists: $dir"
        else
            if prompt_confirm "Create directory: $dir?"; then
                mkdir -p "$dir"
                print_success "Created: $dir"
            fi
        fi
    done
}

setup_dotfiles() {
    print_header "Dotfiles & Configuration"
    
    if ! command -v stow &> /dev/null; then
        print_error "GNU Stow not installed. Install it first via Homebrew"
        return 1
    fi
    
    cd "$SCRIPT_DIR/configs"
    
    local configs=("zsh" "starship" "ghostty" "obsidian" "git")
    
    for config in "${configs[@]}"; do
        if [ ! -d "$config" ]; then
            print_warning "Config directory not found: $config"
            continue
        fi
        
        if prompt_confirm "Setup $config configuration?"; then
            stow -t ~ "$config" 2>/dev/null && print_success "Symlinked $config config" || print_warning "$config already symlinked or conflict exists"
        fi
    done
    
    cd "$SCRIPT_DIR"
    
    # Verify symlinks
    echo ""
    print_info "Verifying symlinks..."
    [ -L "$HOME/.zshrc" ] && print_success ".zshrc symlink verified" || print_warning ".zshrc not symlinked"
    [ -L "$HOME/.config/starship.toml" ] && print_success "starship.toml symlink verified" || print_warning "starship.toml not symlinked"
    [ -L "$HOME/.config/ghostty/config" ] && print_success "ghostty config symlink verified" || print_warning "ghostty config not symlinked"
    [ -L "$HOME/.gitconfig" ] && print_success ".gitconfig symlink verified" || print_warning ".gitconfig not symlinked"
}

configure_git() {
    print_header "Git Configuration"
    
    # Check if gitconfig is managed by stow
    if [ -L "$HOME/.gitconfig" ]; then
        print_success "Git config is managed by stow (symlinked)"
        print_info "Edit $SCRIPT_DIR/configs/git/.gitconfig to update base configuration"
        echo ""
        
        # Setup .gitconfig.local for personal settings first
        local current_email=$(git config user.email 2>/dev/null)
        
        if [ -z "$current_email" ]; then
            print_info "Setting up ~/.gitconfig.local for personal settings..."
            read -p "Enter your git email: " git_email
            if [ -n "$git_email" ]; then
                echo "[user]" > "$HOME/.gitconfig.local"
                echo "	email = $git_email" >> "$HOME/.gitconfig.local"
                print_success "Git email configured in ~/.gitconfig.local"
            else
                print_warning "Git email not configured"
            fi
        else
            print_success "Git email already set: $current_email"
        fi
        
        # Offer SSH commit signing setup
        echo ""
        if prompt_confirm "Setup SSH commit signing? (recommended over GPG)" "skip"; then
            local ssh_key="$HOME/.ssh/id_ed25519.pub"
            
            if [ ! -f "$ssh_key" ]; then
                print_warning "SSH key not found at $ssh_key"
                print_info "Generate one with: ssh-keygen -t ed25519 -C \"your-email@example.com\""
            else
                # Add SSH signing config to .gitconfig.local
                if [ ! -f "$HOME/.gitconfig.local" ]; then
                    touch "$HOME/.gitconfig.local"
                fi
                
                if ! grep -q "gpg.format" "$HOME/.gitconfig.local" 2>/dev/null; then
                    echo "" >> "$HOME/.gitconfig.local"
                    echo "[gpg]" >> "$HOME/.gitconfig.local"
                    echo "	format = ssh" >> "$HOME/.gitconfig.local"
                    echo "[user]" >> "$HOME/.gitconfig.local"
                    echo "	signingkey = $ssh_key" >> "$HOME/.gitconfig.local"
                    echo "[commit]" >> "$HOME/.gitconfig.local"
                    echo "	gpgsign = true" >> "$HOME/.gitconfig.local"
                fi
                
                print_success "SSH commit signing configured in ~/.gitconfig.local"
                print_info "Don't forget to add your SSH key as a 'Signing Key' on GitHub"
            fi
        fi
        return 0
    fi
    
    # Proceed with interactive configuration if not symlinked
    print_info "Configuring git interactively..."
    
    # Check current configuration
    local current_name=$(git config --global user.name 2>/dev/null)
    local current_email=$(git config --global user.email 2>/dev/null)
    
    if [ -n "$current_name" ]; then
        print_success "Git name already set: $current_name"
    else
        if prompt_confirm "Set git user name to 'mjr2595'?"; then
            git config --global user.name "mjr2595"
            print_success "Git name configured"
        fi
    fi
    
    if [ -n "$current_email" ]; then
        print_success "Git email already set: $current_email"
        if prompt_confirm "Update git email?"; then
            read -p "Enter your git email: " git_email
            if [ -n "$git_email" ]; then
                git config --global user.email "$git_email"
                print_success "Git email updated"
            fi
        fi
    else
        read -p "Enter your git email: " git_email
        if [ -n "$git_email" ]; then
            git config --global user.email "$git_email"
            print_success "Git email configured"
        else
            print_warning "Git email not configured"
        fi
    fi
    
    # Set default branch
    local current_branch=$(git config --global init.defaultBranch 2>/dev/null)
    if [ "$current_branch" != "main" ]; then
        if prompt_confirm "Set default branch to 'main'?"; then
            git config --global init.defaultBranch main
            print_success "Default branch set to 'main'"
        fi
    else
        print_success "Default branch already set to 'main'"
    fi
    
    # Optional: SSH commit signing
    echo ""
    if prompt_confirm "Setup SSH commit signing? (recommended over GPG)" "skip"; then
        local ssh_key="$HOME/.ssh/id_ed25519.pub"
        
        if [ ! -f "$ssh_key" ]; then
            print_warning "SSH key not found at $ssh_key"
            print_info "Generate one with: ssh-keygen -t ed25519 -C \"your-email@example.com\""
        else
            git config --global gpg.format ssh
            git config --global user.signingkey "$ssh_key"
            git config --global commit.gpgsign true
            print_success "SSH commit signing configured"
            print_info "Don't forget to add your SSH key as a 'Signing Key' on GitHub"
        fi
    fi
}

setup_node() {
    print_header "Node.js Setup"
    
    # Source nvm first (it may be lazy-loaded in zshrc)
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
    
    # Now check if nvm is available
    if ! command -v nvm &> /dev/null; then
        print_warning "nvm not found. Install via Homebrew first"
        return 1
    fi
    
    if prompt_confirm "Install Node.js LTS via nvm?"; then
        print_info "Installing Node.js LTS..."
        nvm install --lts
        nvm use --lts
        print_success "Node.js LTS installed: $(node --version)"
    else
        print_warning "Skipped Node.js installation"
    fi
}

apply_macos_defaults() {
    print_header "macOS System Preferences"
    
    if [ ! -f "$SCRIPT_DIR/macos-defaults.sh" ]; then
        print_warning "macos-defaults.sh not found. Skipping..."
        return 0
    fi
    
    if prompt_confirm "Apply macOS system preferences?"; then
        print_info "Applying macOS defaults..."
        chmod +x "$SCRIPT_DIR/macos-defaults.sh"
        "$SCRIPT_DIR/macos-defaults.sh"
        print_success "macOS preferences applied"
        print_warning "Some changes may require logout/restart to take effect"
    else
        print_warning "Skipped macOS defaults"
    fi
}

# ============================================
# Main Script
# ============================================

main() {
    # Parse command line arguments
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        print_usage
        exit 0
    fi
    
    if [[ "$1" == "--typical" || "$1" == "-t" ]]; then
        TYPICAL_SETUP=true
    fi
    
    clear
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}              Mac Setup                 ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo "This script will help you set up your Mac with all"
    echo "your preferred tools, apps, and configurations."
    echo ""
    
    if [ "$TYPICAL_SETUP" = true ]; then
        print_info "Running in typical setup mode (auto-confirm enabled)"
        echo ""
    fi
    
    if ! prompt_confirm "Continue with setup?"; then
        print_warning "Setup cancelled"
        exit 0
    fi
    
    # Run installation steps
    install_xcode_tools
    install_homebrew
    install_oh_my_zsh
    disable_last_login
    install_packages
    create_directories
    setup_dotfiles
    configure_git
    setup_node
    apply_macos_defaults
    
    # Final summary
    echo ""
    print_header "Setup Complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Sign into apps (1Password, Raycast, Slack, etc.)"
    echo "  3. Setup SSH keys: ssh-keygen -t ed25519 -C \"your-email\""
    echo "  4. Add SSH key to GitHub (including as Signing Key)"
    echo "  5. Run: gh auth login"
    echo ""
    echo "Optional:"
    echo "  - Import browser settings from apps/Sync/Browser/"
    echo "  - Import Raycast settings from apps/Sync/Raycast/"
    echo ""
    echo "Python with uv:"
    echo "  - List versions: uv python list"
    echo "  - Install: uv python install 3.13"
    echo "  - Set global: uv python pin --global 3.13"
    echo ""
}

main "$@"
