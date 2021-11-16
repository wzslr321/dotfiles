export PATH="/opt/homebrew/opt/bison/bin:$PATH"
export PATH="/opt/homebrew/opt/flex/bin:$PATH"
export TERM=xterm-256color
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/bison/lib"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export LDFLAGS="-L/opt/homebrew/opt/flex/lib"
export CPPFLAGS="-I/opt/homebrew/opt/flex/include"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

source "$HOME/zsh-vim-mode/zsh-vim-mode.plugin.zsh"

autoload zsh-autosuggestions
autoload zsh-syntax-highlighting
autoload zsh-vim-mode

autoload -Uz compinit && compinit 
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

PROMPT='%F{blue}%1~%f %F{cyan}%# '

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

alias cmp='mkdir bin && g++-11 -std=c++17 -o bin/main main.cpp'
alias rb="rm -r bin"
alias ncp='rb && cmp'
alias main='./bin/main'

alias cm='g++ -Wall -Weffc++ -Wextra -Wsign-conversion -Werror -std=c++17 -o main main.cpp'
alias c='g++ -Wall -Weffc++ -Wextra -Wsign-conversion -Werror -std=c++17'

alias cr='open -a Safari http://www.cppreference.com/w/cpp'
alias b='cd ../'

alias vc='open -a safari https://vim.rtorr.com'

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /Users/wiktor/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


