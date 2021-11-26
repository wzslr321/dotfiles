call plug#begin(stdpath('config'))

Plug 'andweeb/presence.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'anott03/nvim-lspinstall'
Plug 'nvim-lua/completion-nvim'
Plug 'kana/vim-operator-user'
Plug 'tyru/open-browser.vim'
Plug 'derekwyatt/vim-fswitch'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'bfrg/vim-cpp-modern'
Plug 'vim-syntastic/syntastic'
Plug 'kana/vim-operator-user'
Plug 'sbdchd/neoformat'
Plug 'cdelledonne/vim-cmake'
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'JamshedVesuna/vim-markdown-preview'

Plug 'rust-lang/rust.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'
Plug 'mfussenegger/nvim-dap'

call plug#end()
