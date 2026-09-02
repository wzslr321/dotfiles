eval $(/opt/homebrew/bin/brew shellenv)

# Private keys (not stored on github)
if [ -f ~/.zshenv.local ]; then
    source ~/.zshenv.local
fi

# --- PATH (deduplicated) ---
export PATH="$HOME/.local/bin:$PATH"

# LaTeX
export PATH="/Library/TeX/texbin:$PATH"

# LLVM
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# Java
export JAVA_HOME=$(/usr/libexec/java_home -v17)
export PATH="$JAVA_HOME/bin:$PATH"

# Android
export ANDROID_HOME=~/Library/Android/sdk
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$PATH"

# Flutter / Dart (SDKs managed by fvm; consumed by nvim DAP config)
export PATH="$HOME/fvm/default/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export FLUTTER_PATH="$HOME/fvm/default/bin/flutter"
export DART_PATH="$HOME/fvm/default/bin/dart"

# .NET
export DOTNET_ROOT="/usr/local/share/dotnet"
export PATH="$DOTNET_ROOT:$DOTNET_ROOT/tools:$HOME/.dotnet/tools:$PATH"

# Ruby (was duplicated 3x, now just once)
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# Python (Homebrew 3.14 via brew shellenv)

# C++
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"

# --- Dotfiles ---
export DOTFILES="$HOME/dotfiles"

# --- Zellij fallback ---
# Kept during the cmux trial so existing sessions and `zas` remain available.
export ZELLIJ_CONFIG_DIR="$DOTFILES/zellij/"
source "$DOTFILES/zellij/.zellij.conf"

# --- Paseo ---
# The desktop app bundles its CLI. Keep it available without a global symlink.
PASEO_BIN_DIR="/Applications/Paseo.app/Contents/Resources/bin"
if [ -d "$PASEO_BIN_DIR" ]; then
    export PATH="$PASEO_BIN_DIR:$PATH"
fi

# --- Oh My Zsh (no theme - starship handles the prompt) ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-vi-mode)
source $ZSH/oh-my-zsh.sh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Terminal keys ---
# Let zellij receive Ctrl-S instead of freezing terminal output with XOFF.
[[ -t 0 ]] && stty -ixon -ixoff

# --- Starship prompt ---
export STARSHIP_CONFIG="$DOTFILES/starship.toml"
[[ "$TERM" != "dumb" ]] && eval "$(starship init zsh)"

# --- Modern CLI tools ---
# Install: brew install eza bat fd zoxide delta
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias lt="eza --tree --icons --level=2"
alias cat="bat --paging=never"

# --- Aliases ---
alias b="cd .."
alias bb="cd ../.."
alias bbb="cd ../../.."
alias c="clear"
alias pip="pip3"
alias python="python3"
alias flutter="fvm flutter"

# Codex TUI: keep native terminal scrollback usable. Inside cmux, use its
# per-session wrapper for notifications and session restore without installing
# global hooks that would also run in Ghostty.
codex() {
    local runner=(command codex)
    local cmux_codex_wrapper="/Applications/cmux.app/Contents/Resources/bin/cmux-codex-wrapper"

    if [[ -n "$CMUX_SURFACE_ID" && -x "$cmux_codex_wrapper" ]]; then
        runner=("$cmux_codex_wrapper")
    fi

    case "$1" in
        exec|e|review|login|logout|mcp|plugin|mcp-server|app-server|remote-control|app|completion|update|doctor|sandbox|debug|apply|a|archive|delete|unarchive|cloud|exec-server|features|help|-h|--help|-V|--version)
            "${runner[@]}" "$@"
            ;;
        *)
            "${runner[@]}" --no-alt-screen "$@"
            ;;
    esac
}

# C++ workflow
alias cmp="rm -r out && mkdir out && g++ main.cpp --std=c++20 -o out/main"
alias cmps="g++ main.cpp -fsanitize=undefined -o out/main --std=c++20"
alias cr="./out/main"
alias cmpr="cmps && ./out/main"
alias cmpa="as -o main.o main.s && /usr/bin/clang -o main main.o -e _start -arch arm64"

# Flutter
alias rundev="flutter run lib/main_dev.dart --target dev"

# --- Haskell ---
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

# --- NVM ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- Atuin (shell history) ---
if [ -f "$HOME/.atuin/bin/env" ]; then
    . "$HOME/.atuin/bin/env"
fi
command -v atuin >/dev/null && eval "$(atuin init zsh)"

# --- Zoxide (smart cd, replaces cd) ---
# Install: brew install zoxide
eval "$(zoxide init zsh)"

# --- Delta (better git diffs) ---
# Configure in ~/.gitconfig:
#   [core]
#     pager = delta
#   [interactive]
#     diffFilter = delta --color-only
#   [delta]
#     navigate = true
#     side-by-side = true

# CocoaPods
export LANG=en_US.UTF-8
export PATH="$HOME/.gem/ruby/3.2.0/bin:$PATH"

# Ollama
export OLLAMA_DEBUG=1

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/creatix/.dart-cli-completion/zsh-config.zsh ]] && . /Users/creatix/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

# --- Machine-local / private shell config (gitignored) ---
if [ -f "$DOTFILES/zsh/.zshrc.local" ]; then
    source "$DOTFILES/zsh/.zshrc.local"
fi
