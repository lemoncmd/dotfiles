" dein settings

if &compatible
  set nocompatible
endif
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Yggdroot/indentLine')
  call dein#add('Haron-Prime/Antares')
  call dein#add('itchyny/lightline.vim')
  call dein#add('cohama/lexima.vim')
  call dein#add('rust-lang/rust.vim')
  call dein#add('ollykel/v-vim')
  call dein#add('neoclide/coc.nvim', { 'rev': 'release' })
  call dein#end()
  call dein#save_state()
endif

" color theme

augroup MyAutoCmd
  autocmd!
augroup END

au MyAutoCmd VimEnter * nested colorscheme antares

au MyAutoCmd VimEnter,ColorScheme * highlight Normal ctermbg=none guibg=NONE
au MyAutoCmd VimEnter,ColorScheme * highlight NonText ctermbg=none guibg=NONE
au MyAutoCmd VimEnter,ColorScheme * highlight LineNr ctermbg=none guibg=NONE
au MyAutoCmd VimEnter,ColorScheme * highlight Folded ctermbg=none guibg=NONE
au MyAutoCmd VimEnter,ColorScheme * highlight EndOfBuffer ctermbg=none guibg=NONE
filetype plugin indent on
syntax enable

" plugin settings

let g:lexima_no_default_rules = 1
call lexima#set_default_rules()

let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ 'separator': { 'left': "\u2B80", 'right': "\u2B82" },
    \ 'subseparator': { 'left': "\u2B81", 'right': "\u2B83" },
    \ }

" vim settings

set fenc=utf-8
set nobackup
set noswapfile
set autoread
set hidden
set showcmd

set number
set nocursorline
set nocursorcolumn
set virtualedit=onemore
set smartindent
set autoindent
set visualbell
set showmatch
set laststatus=2
set ruler
set noshowmode
set wildmode=list:longest
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk

set list listchars=tab:\?\-
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

set whichwrap=b,s,<,>,[,]

" mouse settings

if has('mouse')
  set mouse=a
  if !has('nvim')
    if has('niyse_sgr')
      set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
      set ttymouse=sgr
    else
      set ttymouse=xterm2
    endif
  endif
endif

" key binds

inoremap <silent> jj <Esc>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>
