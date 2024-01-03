
eval $(/opt/homebrew/bin/brew shellenv)
python3 -m site &> /dev/null && PATH="$PATH:`python3 -m site --user-base`/bin"

export ZELLIJ_CONFIG_DIR="/Users/wiktor/dotfiles/zellij/"
export PATH="/Users/wiktor/.local/bin:$PATH"
export PATH="/usr/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:/Users/wiktor/flutter/bin"
export PATH="/Users/wiktor/textec:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

export LDFLAGS="-L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++"
# export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"

export NODE_OPTIONS=--stack-trace-limit=100
export RUST_BACKTRACE=full


export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)
plugins+=(zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

alias b="cd .."
alias cpt="cp ~/.config/nvim/templates/main.tex "
alias cpr="rm src/main.rs && cp ~/.config/nvim/templates/rust-template.rs src/main.rs"
alias cpc="cp ~/.config/nvim/templates/cpp-template.cpp main.cpp"
alias cmp="rm -r out && mkdir out && g++ main.cpp --std=c++20 -o out/main"
alias cmps="g++ main.cpp -fsanitize=undefined -o out/main --std=c++20"
alias cr="./out/main"
alias cmpa="as -o main.o main.s && /usr/bin/clang -o main main.o -e _start -arch arm64"
alias cmpos="cargo +nightly run -Z build-std=core,compiler_builtins --target x86_64-blog_os.json build-std-features=compiler-builtins-mem"
alias c="clear"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(kubectl completion zsh)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/wiktor/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/wiktor/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/wiktor/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/wiktor/google-cloud-sdk/completion.zsh.inc'; fi

[ -f "/Users/wiktor/.ghcup/env" ] && source "/Users/wiktor/.ghcup/env" # ghcup-envexport PATH="/opt/homebrew/opt/libpq/bin:$PATH"

cdq() {
    local output=$(~/Remi/rust/cdq/target/debug/cdq $1)
    echo $output
     local dir=$(echo "$output" | sed -n 's/.*\.\///p')
    if [ -d "$dir" ]; then
        echo "Proceeding to the $dir"
        cd "$dir"
    fi
}

nps() {
    mkdir "$1" && cd "$1" && cpc && mkdir out
}

if [[ -z "$ZELLIJ" ]]; then
    zellij attach default
fi

source ~/dotfiles/zellij/.zellij.conf
