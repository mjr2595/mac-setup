# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

plugins=(
    dotenv
    macos
    python
    z
    zsh-autosuggestions
)

export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3' # Maybe needed depending on the theme
export CLICOLOR=1 # Enable colors in ls
export HOMEBREW_BUNDLE_DUMP_NO_VSCODE=1 # No VSCode extensions in brewfile

# Set personal aliases
alias ls="ls -A"
alias ll="ls -lah"
alias vim="nvim"
alias vi="nvim"
alias g="groovy"
alias pw="pennywise"
alias codi="code-insiders"

# lm work things
export PATH=$PATH:/Volumes/me/coretool
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
source /Volumes/me/coretool/coretool-completion.bash

# Other PATH stuff

export PATH="/usr/local/opt/libpq/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh  # This loads NVM

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/michael/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/michael/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/michael/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/michael/google-cloud-sdk/completion.zsh.inc'; fi

# Created by `pipx` on 2023-06-13 01:47:23
export PATH="$PATH:/Users/michael/.local/bin"

# Flutter SDK
export PATH="$PATH:/Users/michael/Tools/flutter/bin"
export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"

# Python
eval "$(pyenv init --path)"
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# Go
export PATH="$PATH:$HOME/go/bin"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Starship
eval "$(starship init zsh)"
source "$HOME/.configure_tools.sh"
