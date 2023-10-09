lua require('plugins')
lua require('lsp')
lua require('plugins/nvim-cmp')
lua require('plugins/nvim-tree')
lua require('keymappings')
lua require('init')
lua require('filetype')

filetype plugin indent on

syntax enable

set tabstop=4
set shiftwidth=4
set softtabstop=-1
set nu rnu

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
