if exists('g:loaded_b64') | finish | endif

let s:save_cpo = &cpo " save user coptions
set cpo&vim " reset them to defaults

" command to run our plugin
command! -range B64Encode lua require'b64'.encode()
command! -range B64Decode lua require'b64'.decode()

let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

let g:loaded_b64 = 1
