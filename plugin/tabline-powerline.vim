" File:        tabline-powerline.vim
" Maintainer:  Matthew Kitt <http://mkitt.net/> (originator)
"              Rusty Shackleford <http://takeiteasy.github.io/>
" Description: Configure tabs within Terminal Vim.
" Last Change: 2012-10-21
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
  let win = (has("gui_running") ? 'gui' : 'cterm')
  exe 'hi User1 guifg=' . synIDattr(hlID('TablineSel'), 'bg', win) . ' guibg=' . synIDattr(hlID('Tabline'),  'bg', win) . ' ' . GetGUIAttr('Tabline', win)
  exe 'hi User2 guifg=' . synIDattr(hlID('Tabline'), 'bg', win) . ' guibg=' . synIDattr(hlID('Tabline'), 'bg', win) . ' ' . GetGUIAttr('Tabline', win)
  exe 'hi User3 guifg=' . synIDattr(hlID('Tabline'), 'bg', win) . ' guibg=' . synIDattr(hlID('TablineFill'), 'bg', win) . ' ' . GetGUIAttr('Tabline', win)
  exe 'hi User4 guifg=' . synIDattr(hlID('TablineSel'), 'bg', win) . ' guibg=' . synIDattr(hlID('TablineFill'), 'bg', win) . ' ' . GetGUIAttr('Tabline', win)
  exe 'hi User5 guifg=' . synIDattr(hlID('Tabline'), 'bg', win) . ' guibg=' . synIDattr(hlID('TablineSel'), 'bg', win) . ' ' . GetGUIAttr('Tabline', win)

  let s = ''
  for i in range(tabpagenr('$'))
    let tab         = i + 1
    let winnr       = tabpagewinnr(tab)
    let buflist     = tabpagebuflist(tab)
    let bufnr       = buflist[winnr - 1]
    let bufname     = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")

    let cur_tab     = tab == tabpagenr()
    let last_tab    = tab == tabpagenr('$')
    let pre_tab     = tab == (tabpagenr() - 1)

    let s .= '%' . tab . 'T'
    let s .= (cur_tab ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . tab .':'
    let s .= (bufname != '' ? '['. fnamemodify(bufname, ':t') . '] ' : '[No Name] ')

    if bufmodified
      let s .= '[+] '
    endif

    let s.= (cur_tab ? (last_tab ? '%4*' : '%1*') : (last_tab ? '%3*' : (pre_tab ? '%5*' : '%2*'))) . '⮀%*'
  endfor

  let s .= '%#TabLineFill#'
  return s
endfunction
set tabline=%!Tabline()


