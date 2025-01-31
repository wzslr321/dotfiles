eval $(/opt/homebrew/bin/brew shellenv)


# Retrieve private keys that can not be stored on github, e.g. GH Token
if [ -f ~/.zshenv.local ]; then
    source ~/.zshenv.local
fi

export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/texlive/2023/bin/universal-darwin:$PATH"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="/usr/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/fvm/default/bin:$PATH"
export PATH="$HOME/textec:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="$HOME/.dotnet:$PATH"
export PATH="$PATH:/Users/creatix/.dotnet/tools"
export DOTNET_ROOT="$HOME/.dotnet"
export PATH=$JAVA_HOME/bin:$PATH
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
# export PATH="$HOME/development/flutter/bin:$PATH"

# University 
export JAVA_HOME="$HOME/Library/Java/JavaVirtualMachines/corretto-1.8.0_432/Contents/Home"

export CC=/opt/homebrew/Cellar/llvm/19.1.5/bin/clang
export CXX=/opt/homebrew/Cellar/llvm/19.1.5/bin/clang++

export FLUTTER_PATH="$HOME/fvm/versions/3.27.3/bin/flutter"
export DART_PATH="$HOME/fvm/versions/3.27.3/bin/dart"

export DOTFILES="$HOME/dotfiles"

# C++ 
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"

# Zellij
export ZELLIJ_CONFIG_DIR="$DOTFILES/zellij/"

source ~/dotfiles/zellij/.zellij.conf

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git)
plugins+=(zsh-vi-mode)

source $ZSH/oh-my-zsh.sh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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
alias cmpr="cmps && ./out/main"
alias rundev="flutter run lib/main_dev.dart --target dev"
alias lf="~/development/flutter/bin/flutter"
alias ld="~/development/flutter/bin/dart"

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

# Atuin | shell history
# https://github.com/atuinsh/atuin
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
