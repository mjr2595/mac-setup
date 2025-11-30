# ============================================
# Oh My Zsh Configuration
# ============================================
export ZSH=$HOME/.oh-my-zsh

plugins=(
    dotenv
    macos
    z
    zsh-autosuggestions
)

export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
source $ZSH/oh-my-zsh.sh

# ============================================
# Environment & Shell Options
# ============================================

# Consolidated PATH
export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.bun/bin:$HOME/.pyenv/bin:/usr/local/opt/libpq/bin:$PATH"

export CLICOLOR=1
export HOMEBREW_BUNDLE_DUMP_NO_VSCODE=1
export PYENV_ROOT="$HOME/.pyenv"
export EDITOR="nvim"
export VISUAL="nvim"

# History
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# ============================================
# Aliases
# ============================================
alias ls="ls -A"
alias ll="ls -lah"
alias vim="nvim"
alias vi="nvim"
alias g="groovy"
alias pw="pennywise"
alias codi="code-insiders"
alias lg="lazygit"
alias gs="git status"
alias ga="git add . && git status"
alias gc="git commit -m"
alias gp="git push"
alias gfp="git fetch && git pull"
alias gsw="git switch"
alias py="python"

# ============================================
# Work Configuration
# ============================================
export PATH=$PATH:/Volumes/me/coretool
source "$HOME/.configure_tools.sh"

# ============================================
# Language & Runtime Managers
# ============================================

# NVM 
export NVM_DIR="$HOME/.nvm"
nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm "$@"
}

# Python 
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
fi
pyenv() {
    unset -f pyenv
    eval "$(command pyenv init -)"
    pyenv "$@"
}

# uv 
uv() {
    unset -f uv uvx
    eval "$(command uv generate-shell-completion zsh)"
    eval "$(command uvx --generate-shell-completion zsh)"
    uv "$@"
}
uvx() {
    unset -f uv uvx
    eval "$(command uv generate-shell-completion zsh)"
    eval "$(command uvx --generate-shell-completion zsh)"
    uvx "$@"
}

# SDKMAN 
export SDKMAN_DIR="$HOME/.sdkman"
sdk() {
    unset -f sdk
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk "$@"
}

# envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# ============================================
# Prompt & Theme
# ============================================
eval "$(starship init zsh)"

# Work tools (background loaded)
if [[ -f "$HOME/.configure_tools.sh" ]]; then
    source "$HOME/.configure_tools.sh" &!
fi

# bun 
export BUN_INSTALL="$HOME/.bun"
bun() {
    unset -f bun
    [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
    command bun "$@"
}
