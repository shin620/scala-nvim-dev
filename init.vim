" Vim-Plugでプラグインを管理
call plug#begin('~/.vim/plugged')

" Scala対応のCoc.nvimプラグイン
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" カラースキーム
Plug 'Mofiqul/dracula.nvim'

call plug#end()

" Coc.nvimの設定
let g:coc_global_extensions = ['coc-metals']

" カラースキームの設定
colorscheme dracula

