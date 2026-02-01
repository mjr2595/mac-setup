# ============================================
# Oh My Zsh Configuration
# ============================================
export ZSH=$HOME/.oh-my-zsh

plugins=(
    dotenv
    macos
    z
)

# Defer autosuggestions to speed up startup
zshinit_deferred() {
    source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd zshinit_deferred

export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
source $ZSH/oh-my-zsh.sh

# ============================================
# Environment & Shell Options
# ============================================

# Consolidated PATH
export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.bun/bin:$HOME/.pyenv/bin:/usr/local/opt/libpq/bin:$HOME/.sdkman/candidates/groovy/current/bin:$HOME/.opencode/bin:$PATH"

export CLICOLOR=1
export HOMEBREW_BUNDLE_DUMP_NO_VSCODE=1
export PYENV_ROOT="$HOME/.pyenv"
export EDITOR="nvim"
export VISUAL="nvim"
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"

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
alias codi="code-insiders"
alias gs="git status"
alias ga="git add . && git status"
alias gc="git commit -m"
alias gp="git push"
alias gfp="git fetch && git pull"
alias gsw="git switch"
alias py="python"
alias g="groovy"
alias pw="pennywise"
alias jt="jiratool"

# ============================================
# Work Configuration
# ============================================
export PATH=$PATH:/Volumes/me/coretool
if [[ -f "$HOME/.configure_tools.sh" ]]; then
    source "$HOME/.configure_tools.sh"
fi

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
codex() {
    unset -f codex
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    command codex "$@"
}
pnpm() {
    unset -f pnpm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    command pnpm "$@"
}

# bun 
export BUN_INSTALL="$HOME/.bun"
bun() {
    unset -f bun
    [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
    command bun "$@"
}

# Python 
# Skip pyenv path init if already set
if [[ ":$PATH:" != *":$PYENV_ROOT/shims:"* ]] && command -v pyenv 1>/dev/null 2>&1; then
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

# envman - defer loading
envman() {
    unset -f envman
    [ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
    envman "$@"
}

# ============================================
# Prompt & Theme
# ============================================
# Cache starship init for faster startup
if [[ ! -f "$HOME/.starship_cache" ]] || [[ "$(command -v starship)" -nt "$HOME/.starship_cache" ]]; then
    starship init zsh > "$HOME/.starship_cache"
fi
source "$HOME/.starship_cache"