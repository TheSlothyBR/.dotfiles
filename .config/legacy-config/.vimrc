" Set color theme "
colorscheme nord
" set t_ut=""

" Set transparent background "
" hi Normal guibg=NONE ctermbg=NONE

" Set 256 term colors "
set termguicolors

" Set number and ~ row color "
" hi NonText guibg=SlateBlue1
" hi LineNr guifg=SlateBlue1

" Add numbers to each line on the left-hand side. "
set number

" Turn syntax highlighting on "
syntax on

" Show matching bracket "
set showmatch

" Highlight cursor line underneath the cursor horizontally. "
set cursorline

" Set tab width to 4 columns "
set tabstop=4

" Set spaces to autoindent "
set shiftwidth=4

" Configure smart indenting
set smartindent
set smarttab

" Configure fuzzyfind, search subfolders, tab complete and display matching files "
set path+=**
set wildmenu

" Configure auto brackets indenting "
inoremap {<C-Enter> {<C-Enter>}<Esc>O<BS><Tab>
iabbrev brk {}<Left><CR><Esc>O

" Prevent CTRL-F to abort the selection (in visual mode)
" This is caused by $VIM/_vimrc ':behave mswin' which sets 'keymodel' to
" include 'stopsel' which means that non-shifted special keys stop selection.
set keymodel=startsel

" Set temp folder path "
set backup
set directory=C:\\Git\\tmp
set backupdir=C:\\Git\\backup

" Allow mouse to select and not force visual mode "
set mouse=a
set mouse=nicr

" allow text selection with shift in insertmode. Arrows stop working in visual highlighting "
behave mswin

" Vim multiline edit "
"1. v + [number of line to select after cursor] j or k -- visual multi-line mode
"2. Shift + < or > -- indent / unindent 
"3. Ctrl B + [number of line to select after cursor] j or k -- visual block mode
"4. Shift i -- multi-cursor insert
"5. Under visual block mode, $ -- move cursors to end of line or ^ -- to the start
"6. A -- append at the end of each line
"7. Press Esc to signal Vim to repeat on other lines

" Allow cursor to move where there is no text "
set virtualedit=onemore

" Map leader key "
let mapleader=" "

" backspace in Visual mode acts like windows "
noremap <BS> d<Left>

" Surround visual selection in parenthesis/brackets... "
vnoremap <Leader>1 <esc>`>a)<esc>`<i(<esc>
vnoremap <Leader>2 <esc>`>a]<esc>`<i[<esc>
vnoremap <Leader>3 <esc>`>a><esc>`<i<<esc>
vnoremap <Leader>4 <esc>`>a}<esc>`<i{<esc>
vnoremap <Leader>5 <esc>`>a"<esc>`<i"<esc>
vnoremap <Leader>6 <esc>`>a'<esc>`<i'<esc>
vnoremap <Leader>7 <esc>`>a`<esc>`<i`<esc>

" CTRL-Z is Undo
noremap  <C-Z> u
inoremap <C-Z> <C-O>u

" CTRL-X is Cut
vnoremap <C-X> "+x

" CTRL-C is Copy
vnoremap <C-C> "+y

" CTRL-V is Paste
map <C-V>  "+gP
cmap <C-V> <C-R>+

" CTRL-B is Block selection
noremap <C-B> <C-V>

" CTRL-S is Save
noremap  <C-S>      :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" CTRL-A is Select All
noremap  <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG

" CTRL-Y is Redo (although not repeat); not in cmdline though
noremap  <C-Y>      <C-R>
inoremap <C-Y> <C-O><C-R>

" CTRL-F is find string in current file, enter than n to cycle "
map <C-F> /
