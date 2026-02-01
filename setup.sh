# install xcode build tools
xcode-select --install

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# omz zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# disable last login terminal prompt
touch .hushlogin

# install packages via brewfile
brew bundle --file=./apps/Brewfile-[personal or work]

# create dev and notes dirs
mkdir ~/Dev
mkdir ~/Documents/Notes

# set up config dirs
cd ~/mac-setup/configs
stow -t ~ zsh
stow -t ~ starship
stow -t ~ ghostty
stow -t ~ obsidian

# verify symlinks
ls -l ~/.zshrc
ls -l ~/.config/starship.toml
ls -l ~/.config/ghostty/config
ls -l ~/Documents/Notes

# configure git
git config --global user.name mjr2595
git config --global user.email ****
git config --global init.defaultbranch main
# optionally set up work gitconfig

# Python with uv
# List available Python versions
uv python list

# Install Python version (e.g., 3.12, 3.13)
uv python install [PYTHON_VERSION]

# Set global Python version (creates ~/.python-version)
uv python pin --global [PYTHON_VERSION]

# Install Python executable to PATH (optional, adds python3.X to ~/.local/bin)
uv python install [PYTHON_VERSION] --default

# Verify installation
uv python list --only-installed
uv python find

# OPTIONAL: Vim stuff
# install vim-plug

# Vim (~/.vim/autoload)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Neovim (~/.local/share/nvim/site/autoload)
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
