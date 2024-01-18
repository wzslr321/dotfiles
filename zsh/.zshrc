# Some random stuff  
eval $(/opt/homebrew/bin/brew shellenv)

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="/usr/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$HOME/textec:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

export FLUTTER_PATH="$HOME/flutter/bin/flutter"
export DART_PATH="$HOME/flutter/bin/dart"
export DEFAULT_FLUTTER_DEVICE="macos"

export DOTFILES="$HOME/dotfiles"

# C++ 
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"

# Zellij
export ZELLIJ_CONFIG_DIR="$DOTFILES/zellij/"

source ~/dotfiles/zellij/.zellij.conf

if [[ -z "$ZELLIJ" ]]; then
    zellij attach default
fi


export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git)
plugins+=(zsh-vi-mode)

source $ZSH/oh-my-zsh.sh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source <(kubectl completion zsh)

# Aliases
alias b="cd .."
alias bb="cd ../.."
alias bbb="cd ../../.."
alias cpt="cp $DOTFILES/nvim/templates/main.tex "
alias cpr="rm src/main.rs && cp $DOTFILES/nvim/templates/rust-template.rs src/main.rs"
alias cpc="cp $DOTFILES/nvim/templates/cpp-template.cpp main.cpp"
alias cmp="rm -r out && mkdir out && g++ main.cpp --std=c++20 -o out/main"
alias cmps="g++ main.cpp -fsanitize=undefined -o out/main --std=c++20"
alias cr="./out/main"
alias cmpa="as -o main.o main.s && /usr/bin/clang -o main main.o -e _start -arch arm64"
alias cmpos="cargo +nightly run -Z build-std=core,compiler_builtins --target x86_64-blog_os.json build-std-features=compiler-builtins-mem"
alias c="clear"

# gcloud
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/google-cloud-sdk/completion.zsh.inc'; fi

# Haskell
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" 

# My lil program to make cd more convinient https://github.com/wzslr321/cdq
cdq() {
    local output=$(~/Remi/rust/cdq/target/debug/cdq $1)
    echo $output
     local dir=$(echo "$output" | sed -n 's/.*\.\///p')
    if [ -d "$dir" ]; then
        echo "Proceeding to the $dir"
        cd "$dir"
    fi
}

# Helpers
nps() {
    mkdir "$1" && cd "$1" && cpc && mkdir out
}

