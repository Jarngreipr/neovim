set number
set relativenumber

let $MYVIMRC="$HOME/.local/dotfiles/nvim/init.vim"

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
	silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin()

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'

Plug 'altercation/vim-colors-solarized'

" Statusline
Plug 'itchyny/lightline.vim'

" Rust
Plug 'rust-lang/rust.vim'
Plug 'vim-syntastic/syntastic'

" C Programming
Plug 'WolfgangMehner/vim-plugins'

" VimWiki
Plug 'vimwiki/vimwiki'

" vimtex
Plug 'lervag/vimtex'

"Powershell support
Plug 'PProvost/vim-ps1'

" Pep8 highlighting for python
Plug 'nvie/vim-flake8'

" Jedi analysis for python
Plug 'davidhalter/jedi-vim'

" Run commands asynchronously
Plug 'neomake/neomake'

" C programming
Plug 'WolfgangMehner/vim-plugins'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
call plug#end()

let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
let g:solarized_termcolors = 256
colorscheme solarized

" Keymaps
let mapleader="\\"
let maplocalleader="<S-\\>"

" csupport
let g:C_MapLeader = ','

inoremap jk <Esc>
" Uppercase whole word in insert mode
inoremap <c-u> <esc>gUiwi
" Uppercase whole word in normal mode
nnoremap <c-u> gUiww

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
cnoremap w!! w !sudo tee > /dev/null %

noremap <leader>so :w<cr>:so %<cr>

" Window movement
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

" Disable scrolling
inoremap <ScrollWheelUp> <Nop> 
inoremap <ScrollWheelDown> <Nop> 

" Tab mappings
noremap <leader>tn :tabnew<cr>
noremap <leader>to :tabonly<cr>
noremap <leader>tc :tabclose<cr>
noremap <leader>tm :tabmove<cr>
noremap <leader>tN :tabNext<cr>
noremap <leader>tp :tabprevious<cr>

" Enable folding with spacebar
nnoremap <space> za

" Search
noremap <silent> <leader><cr> :noh<cr>

" Rust development
let g:rustfmt_autosave = 1
noremap <leader>ct :!cargo test<cr>
let b:current_compiler = 'cargo'

" VimTEX configs
let g:vimtex_view_method = 'zathura'
autocmd BufReadPre *.tex let b:vimtex_main = 'master.tex'
let g:tex_flavor = "latex"

" Netrw configs
let g:netrw_wiw = 20
let g:netrw_usetab = 1

" PEP 8 for python files
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=91 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set foldmethod=indent |
    \ set encoding=utf-8

" Syntastic python checkers
let g:syntastic_python_checkers = ['mypy']

" C Development
augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c
augroup END

" include path for header files
let &path.="src/include,/usr/include/AL,repos/libsystem/,repos/machine,"

" Call neamake when writing a buffer (no delay).
call neomake#configure#automake('w')
augroup my_neomake_cmds
	autocmd!
	" Have neomake run cargo when rust files are saved
	autocmd BufWritePost *.rs Neomake! cargo
augroup END

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <leader>r :call LanguageClient#textDocument_rename()<CR>

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options

command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

nnoremap <silent> <leader>f :Find<CR>
nnoremap <silent> <leader>fw :Find <C-R><C-W><CR>
nnoremap <silent> <C-f> :Files<CR>
