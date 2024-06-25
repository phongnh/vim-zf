vim9script

tnoremap <silent> <buffer> <c-c> <c-w>:<c-u>call zf#Stop()<cr>

b:undo_ftplugin = 'execute "tunmap <buffer> <c-c>"'
