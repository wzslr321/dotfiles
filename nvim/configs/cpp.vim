
highlight ExtraWhitespace ctermbg=red guibg=red

match ExtraWhitespace /\s\+$/
au BufWinEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au BufWinLeave * call clearmatches()
nnoremap <silent> <leader>rs :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

nnoremap <silent> <leader>osx :call openbrowser#smart_search(expand('<cword>'), "cppreference")<CR>

au BufEnter *.h  let b:fswitchdst = "c,cpp"
au BufEnter *.cc let b:fswitchdst = "h,hpp"

nnoremap<silent><A - o> : FShere<cr>
nnoremap<silent><localleader>sl :FSSplitLeft<cr>
nnoremap<silent><localleader>sr :FSSplitRight<cr>
nnoremap<silent><localleader>sb :FSSplitBelow<cr>
nnoremap<silent><localleader>sa :FSSplitAbove<cr>

let g:syntastic_cpp_checkers = ['cpplint']
let g:syntastic_c_checkers = ['cpplint']
let g:syntastic_cpp_cpplint_exec = 'cpplint'
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

