" File:        tabline.vim
" Maintainer:  Matthew Kitt <http://mkitt.net/>
" Description: Configure tabs within Terminal Vim.
" Last Change: Wed 10/Dec/2014 hr 23:42
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

if !exists('g:tabline_tab_num_sep')
  let g:tabline_tab_num_sep = ':'
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

if !exists('g:tabline_powerline')
  let g:tabline_powerline = 0
endif

" Get the GUI attributes of a Highlight ID, e.g. underline, bold, etc
function! GetGUIAttr(id, win)
  let ret   = ''
  let attrs = ['bold', 'italic', 'underline', 'reverse', 'inverse']

  for i in range(5)
    if (synIDattr(hlID(a:id), attrs[i], a:win))
      let ret .= ',' . attrs[i]
    endif
  endfor

  if (ret == '')
    let ret = 'gui=NONE'
  else
    let ret = substitute(ret, '^,', 'gui=', '')
  endif

  return ret
endfunction

function! Tabline()
  if g:tabline_powerline
    let win = (has("gui_running") ? 'gui' : 'cterm')
    exe 'hi User1 ' . win . 'fg=' . synIDattr(hlID('Title'),      'fg', win) . ' ' . win . 'bg=' . synIDattr(hlID('Tabline'),     'bg', win) . ' ' . GetGUIAttr('Tabline', win)
    exe 'hi User2 ' . win . 'fg=' . synIDattr(hlID('Tabline'),    'bg', win) . ' ' . win . 'bg=' . synIDattr(hlID('Tabline'),     'bg', win) . ' ' . GetGUIAttr('Tabline', win)
    exe 'hi User3 ' . win . 'fg=' . synIDattr(hlID('Tabline'),    'bg', win) . ' ' . win . 'bg=' . synIDattr(hlID('TablineFill'), 'bg', win) . ' ' . GetGUIAttr('Tabline', win)
    exe 'hi User4 ' . win . 'fg=' . synIDattr(hlID('TablineSel'), 'bg', win) . ' ' . win . 'bg=' . synIDattr(hlID('TablineFill'), 'bg', win) . ' ' . GetGUIAttr('Tabline', win)
    exe 'hi User5 ' . win . 'fg=' . synIDattr(hlID('Tabline'),    'bg', win) . ' ' . win . 'bg=' . synIDattr(hlID('TablineSel'),  'bg', win) . ' ' . GetGUIAttr('Tabline', win)
    exe 'hi User6 ' . win . 'fg=' . synIDattr(hlID('TablineSel'), 'bg', win) . ' ' . win . 'bg=' . synIDattr(hlID('Tabline'),     'bg', win) . ' ' . GetGUIAttr('Tabline', win)
  endif
  let s = ''
  let tt = tabpagenr('$')
  for i in range(tt)
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")

    let cur_tab     = (tab == tabpagenr())
    let last_tab    = (tab == tt)
    let pre_tab     = (tab == (tabpagenr() - 1))

    let s .= '%' . tab . 'T'
    let s .= (cur_tab ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' '
    if g:tabline_show_tab_num == 1
      let s .= tab . g:tabline_tab_num_sep
    endif
    let s .=
          \   g:tabline_bracket_left
          \ . (bufname != '' ?  fnamemodify(bufname, g:tabline_fnamemod) : g:tabline_no_name)
          \ . g:tabline_bracket_right

    if bufmodified
      let s .= g:tabline_modified
    endif
    if g:tabline_powerline
      let s.= (cur_tab ? (last_tab ? '%4*' : '%6*') : (last_tab ? '%3*' : (pre_tab ? '%5*' : '%2*'))) . '%*'
    endif
  endfor

  let s .= '%#TabLineFill#'
  return s
endfunction
set tabline=%!Tabline()

