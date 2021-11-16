let g:nvim_config_root = stdpath('config')


let g:vimspector_enable_mappings = 'HUMAN'
let g:openbrowser_search_engines = extend(
\ get(g:, 'openbrowser_search_engines', {}),
\ {
\   'cppreference': 'https://en.cppreference.com/mwiki/index.php?title=Special%3ASearch&search={query}',
\ },
\ 'keep'
\)

let g:config_file_list = ['plugins.vim',
	\ 'configs/cpp.vim',
    \ 'configs/coc.vim',
    \ 'configs/fzf.vim',
    \ 'configs/vimspector.vim'
	\ ]


nnoremap <silent> ff :<C-u>Neoformat<CR>

for f in g:config_file_list
    execute 'source ' . g:nvim_config_root . '/' . f
endfor

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

require("presence"):setup({
    neovim_image_text = "🤕🥱",
    main_image = "file",
})
EOF

set tabstop=4
set shiftwidth=4
set expandtab

source $HOME/.config/nvim/themes/airline.vim
source $HOME/.config/nvim/themes/onedark.vim

let vim_markdown_preview_github=1
