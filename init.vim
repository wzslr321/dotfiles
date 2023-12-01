lua require('plugins')
lua require('lsp')
lua require('plugins/nvim-cmp')
lua require('plugins/nvim-dap')
lua require('plugins/nvim-tree')
lua require('plugins/rust-tools')
lua require('keymappings')
lua require('init')

filetype plugin indent on

syntax enable

set tabstop=4
set shiftwidth=4
set softtabstop=-1
set nu rnu
set cursorline
set cursorlineopt=number
set expandtab

let g:tex_flavor='latex'
let g:vimtex_view_method = 'skim'
let g:vimtex_view_skim_sync = 1
let g:vimtex_view_skim_activate = 1

colorscheme tokyonight-night

let maplocalleader = "'"
:tnoremap <Esc> <C-\><C-n>

let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-pdf',
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}

let g:better_whitespace_enabled=0

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

let g:use_clangd = 1

call plug#begin()
    Plug 'https://gitlab.com/code-stats/code-stats-vim.git'
    Plug 'vim-airline/vim-airline'
call plug#end()

let g:codestats_api_key = 'SFMyNTY.WTNKbFlYUnBlQT09IyNNakUyTmpJPQ.7iYfkpTR3bP1M3ZaNPpASBDim7OknvyX2LLVKWjpPLw'
let g:airline_section_x = airline#section#create_right(['tagbar', 'filetype', '%{CodeStatsXp()}'])

function! SilentPlugInstall()
    execute 'silent! PlugInstall' | execute 'silent! q'
endfunction

autocmd VimEnter * call SilentPlugInstall()

