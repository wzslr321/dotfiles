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

