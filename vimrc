
set nocompatible
syntax on
set nohls " Don't highlight search matches
"set hls " Highlight search matches
highlight Search ctermfg=black ctermbg=cyan
" highlight Statement ctermfg=blue     " good for white terminals
highlight Comment ctermfg=DarkGreen     " instead of 5 (magenta)
"highlight SpecialKey ctermfg=red        " instead of blue
highlight Constant ctermfg=red       " instead of blue
highlight String ctermfg=DarkRed
"highlight Title ctermfg=red             " instead of magenta
highlight Special ctermfg=magenta
highlight Number ctermfg=red
highlight PreProc ctermfg=magenta
highlight link perlMethod NONE
highlight link perlStatementInclude perlStatement
let perl_extended_vars=1 " highlight advanced perl vars inside strings

set tabstop=8       " tab character counts as 8 spaces
set softtabstop=4   " tab key should insert 4 spaces
set shiftwidth=4    " autoindent step should be 4 spaces
set expandtab       " tab key should generate space chars only
" set softtabstop
" set noexpandtab
set textwidth=80 " wrap lines at this size
set showmatch " show matches on parens, brackets, etc
set bs=2
set comments=:#
set fo+=croql

" Perl script detection by filename:
autocmd BufRead,BufNewFile *.pl,*.perl,*.pm,*.px if &ft != 'perl' | set ft=perl | endif
" Perl script detection for shell scripts invoking perl
" For some reason vim detects files as "conf" when they start with ": #"
autocmd FileType sh,conf if getline(1) =~ '#.*perl' || getline(2) =~ 'exec .*perl' | set ft=perl | endif

" setup nice perl formatting, and use only spaces for indentation
" autocmd FileType perl set cindent cinwords+=sub,elsif cinkeys-=0# cino=+2,t0,(0,u0,#1 comments=n:# fo+=croql
autocmd FileType perl set cindent cinwords+=sub,elsif cinkeys-=0# cino=+2,t0,(0,u0,#1 comments=n:# fo+=croql
" use GNU formatting on C files, since that's what the GNATS project uses
autocmd FileType c,cpp,in set noexpandtab cindent cinkeys-=0 cino=+2,t0,(0,u0,{.5s,:.5s,=.5s,l1,^-2 fo+=croql

set tags=./tags,./../tags,./../../tags
"set ruler rulerformat=%73(%F%M%R%=\ %l,%c\ %B\ %o\ %P%)
set ruler rulerformat=%50(%60(%F%M%R%=\ %l,%c\ %o\ %b\ %P%)%)
set nomodeline " security issue
"set viminfo=""
set pastetoggle=<F11>
" map <C-x> :q!<CR>
" map <C-w> :wq!
" cmap Q<CR> q!<CR>
" help %: about ex special stuff, %:p:h means directory containing the file
" map <c-@> :!cd %:p:h " && ctags -R<cr><cr>
map <c-@> :!cd %:p:h && pwd

" Use ctrl-underscore to scan files in the directory for the word under the
" cursor. Then configure ctrl-n / ctrl-p to walk from the previous to the next.
map <c-_> :grep \\b<cword>\\b %:p:h/*<cr><cr><cr>
map <c-k> :grep \\b<cword>\\b %:p:h/../*.c %:p:h/../*/*.c %:p:h/*/*.c<cr><cr><cr>
map <c-n> :cnext<cr>
map <c-p> :cprev<cr>

" Mmmmm... tab completetion -- http://www.perlmonks.org/?node_id=166856
" function! InsertTabWrapper(direction)
"     let col = col('.') - 1
"     if !col || getline('.')[col - 1] !~ '\k'
"         return "\<tab>"
"     elseif "backward" == a:direction
"         return "\<c-p>"
"     else
"         return "\<c-n>"
"     endif
" endfunction
" inoremap <S-tab> <c-r>=InsertTabWrapper ("backward")<cr>
" inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>

" vim -b : edit binary files (that end with .bin) using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

" call pathogen#infect()
syntax on
filetype plugin indent on
let g:pyflakes_use_quickfix = 0

" =================== devtodo ===============

if exists("g:loaded_devtodo") || &cp
    finish
endif
let g:loaded_devtodo = 1

function! s:TodoList()
    exe "!todo --mono"
endfunction
command! -nargs=? -range=% TodoList :call s:TodoList()

function! s:TodoAdd(item)
    let item = (a:item == '' ? input("Item: ") : a:item)
    if item == ''
        echo "You must provide a todo item to add"
        return
    endif
    exe "!tda --mono \"" . item . "\""
endfunction
command! -nargs=? -range=% TodoAdd :call s:TodoAdd(<q-args>)

function! s:TodoDone(number)
    let number = (a:number == '' ? input("Number: ") : a:number)
    if number == ''
        echo "You must provide a number to mark as done"
        return
    endif
    exe "!tdd --mono " . number
endfunction
command! -nargs=? -range=% TodoDone :call s:TodoDone(<q-args>)
