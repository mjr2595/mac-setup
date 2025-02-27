# install xcode build tools
xcode-select --install

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# omz zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# install packages via brewfile
brew bundle --file=./apps/Brewfile-[personal or work]

# setup zsh with Starship
# brew install starship
mkdir ~/.confg/starship.toml
# copy over starship.toml

# disable last login terminal prompt
touch .hushlogin

# configure git
git config --global user.name mjr2595
git config --global user.email ****
git config --global init.defaultbranch main

# create dev folder
mkdir ~/Dev

# Python stuff
# brew update
# brew install pyenv
echo 'eval "$(pyenv init --path)"' >> ~/.zshrc # should already be in there
pyenv install -l
pyenv install [PYTHON_VERSION]
pyenv global [PYTHON_VERSION]
pyenv versions

# OPTIONAL: Vim stuff
# install vim-plug

# Vim (~/.vim/autoload)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Neovim (~/.local/share/nvim/site/autoload)
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
