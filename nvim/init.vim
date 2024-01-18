lua require('init')
lua require('plugins')
lua require('lsp')
lua require('plugins/nvim-cmp')
lua require('plugins/nvim-dap')
lua require('plugins/nvim-tree')
lua require('keymappings')

" https://vi.stackexchange.com/a/10125
filetype plugin indent on

syntax enable

set tabstop=4
set shiftwidth=4
" set softtabstop=-1
set nu rnu
set cursorline
set cursorlineopt=number
set expandtab
set laststatus=2
" display column & row number
set ruler 

highlight MatchParen guifg=#00FFFF guibg=#000000
highlight MatchParen ctermfg=10 ctermbg=NONE

" config for vim-tex plugin
let g:tex_flavor='latex'
let g:vimtex_view_method = 'skim'
let g:vimtex_view_skim_sync = 1
let g:vimtex_view_skim_activate = 1
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

let maplocalleader = "'"

:tnoremap <Esc> <C-\><C-n> 

" set to 1 when coding in haskell, as it detects unnecessary whitespace
let g:better_whitespace_enabled=0 

" TODO try move it to keymappings
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
 
let g:use_clangd = 1
