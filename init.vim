" Vim-Plugでプラグインを管理
call plug#begin('~/.vim/plugged')

" Scala対応のCoc.nvimプラグイン
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" カラースキーム
Plug 'Mofiqul/dracula.nvim'

" nvim-tree
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

" Telescopeプラグインと依存プラグイン
Plug 'nvim-telescope/telescope.nvim', {'branch': '0.1.x'}
Plug 'nvim-lua/plenary.nvim' " Telescope の依存プラグイン

" vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" Coc.nvimの設定
let g:coc_global_extensions = ['coc-metals']

" カラースキームの設定
colorscheme dracula

" nvim-tree設定
lua require('config.nvim_tree')
nnoremap <C-n> :NvimTreeToggle<CR>

" terminal設定
nnoremap <leader>t :belowright 12split \| terminal<CR>
autocmd TermOpen * startinsert

" Telescopeキーマップ
lua require('config.telescope')
nnoremap <leader>ff :Telescope find_files<CR>
nnoremap <leader>fg :Telescope live_grep<CR>
nnoremap <leader>fb :Telescope buffers<CR>
nnoremap <leader>fh :Telescope help_tags<CR>

" vim-airline設定
let g:airline#extensions#tabline#enabled = 1

