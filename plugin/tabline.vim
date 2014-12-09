" File:        tabline.vim
" Maintainer:  Matthew Kitt <http://mkitt.net/>
" Description: Configure tabs within Terminal Vim.
" Last Change: Tue 09/Dec/2014 hr 13:47
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" Based On:    http://www.offensivethinking.org/data/dotfiles/vimrc

" Bail quickly if the plugin was loaded, disabled or compatible is set
if (exists("g:loaded_tabline_vim") && g:loaded_tabline_vim) || &cp
  finish
endif
let g:loaded_tabline_vim = 1

if !exists('g:tabeline_fnamemod')
  let g:tabline_fnamemod = ':t'
endif

if !exists('g:tabline_modified')
  let g:tabline_modified = '[+] '
endif

if !exists('g:tabline_show_tab_num')
  let g:tabline_show_tab_num = 1
endif

if !exists('g:tabline_bracket_left')
  let g:tabline_bracket_left = '['
endif

if !exists('g:tabline_bracket_right')
  let g:tabline_bracket_right = '] '
endif

if !exists('g:tabline_no_name')
  let g:tabline_no_name = 'No Name'
endif

function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")

    let s .= '%' . tab . 'T'
    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' '
    if g:tabline_show_tab_num == 1
      let s .= tab .':'
    endif
    let s .=
          \ g:tabline_bracket_left
          \ . (bufname != '' ?  fnamemodify(bufname, g:tabline_fnamemod) : g:tabline_no_name)
          \ . g:tabline_bracket_right

    if bufmodified
      let s .= g:tabline_modified
    endif
  endfor

  let s .= '%#TabLineFill#'
  return s
endfunction
set tabline=%!Tabline()

