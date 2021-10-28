set noswapfile

" ----------------------------------------------------------------------------
"  Text Formatting
" ----------------------------------------------------------------------------

" syntax
syntax on
set background=dark

" whitespace
set autoindent
set smartindent
set nowrap
set tabstop=4
set shiftwidth=4
set expandtab
set nosmarttab

" ----------------------------------------------------------------------------
"  Remapping
" ----------------------------------------------------------------------------

" creating tabs and cycling through them
nmap } :tabn<Enter>
nmap { :tabp<Enter>
map <C-T> :tabnew<Enter>
imap <C-T> <ESC>:tabnew<Enter>

" sane movement with wrap turned on
nmap j gj
nmap k gk
vmap j gj
vmap k gk
nmap <Down> gj
nmap <Up> gk
vmap <Down> gj
vmap <Up> gk

" ----------------------------------------------------------------------------
"  UI
" ----------------------------------------------------------------------------

set ruler                  " show the cursor position all the time
set noshowcmd              " don't display incomplete commands
set nolazyredraw           " turn off lazy redraw
set backspace=2            " allow backspacing over everything in insert mode
set scrolloff=8            " start scrolling before edge of screen

" ----------------------------------------------------------------------------
" Visual Cues
" ----------------------------------------------------------------------------

set showmatch              " brackets/braces that is
set mat=5                  " duration to show matching brace (1/10 sec)
set incsearch              " do incremental searching
set laststatus=2           " always show the status line
set ignorecase             " ignore case when searching
set hlsearch               " highlight searches
set visualbell             " shut up
set t_vb=                  " no flashing

" ----------------------------------------------------------------------------
" Plugins
" ----------------------------------------------------------------------------

packadd! dracula-vim
let g:dracula_colorterm = 0
colorscheme dracula

let g:go_def_mapping_enabled = 0
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_assignments = 1

let g:terraform_fmt_on_save = 1
