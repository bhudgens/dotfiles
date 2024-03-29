" Remap Leader
let mapleader =" "
nmap <bslash> <space>

call plug#begin('~/.vim/plugged')

" (coc.nvim) Intellesense
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" (tmux-navigator) Navigation Help
Plug 'christoomey/vim-tmux-navigator'

" (NerdTree) File Explorer
Plug 'preservim/nerdtree' |
  \ Plug 'ryanoasis/vim-devicons' |
  \ Plug 'Xuyuanp/nerdtree-git-plugin' |
  \ Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" (unimpaired) VIM Bindings
Plug 'tpope/vim-unimpaired'

" (surround) Change surrounding chars (changeme) to 'changeme'
Plug 'tpope/vim-surround'

" Git Integration
Plug 'tpope/vim-fugitive'

" Ruby on Rails
Plug 'tpope/vim-rails'

Plug 'bhudgens/vim-format-js'

" (fzf) Search
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" (gitgutter) Smart Gutter Like VSCode
Plug 'airblade/vim-gitgutter'

" onedark
Plug 'joshdick/onedark.vim'

" Coffeescript?
Plug 'kchmck/vim-coffee-script'

" (NerdCommenter) Smart Comments
Plug 'scrooloose/nerdcommenter'

" (quick-scope) Jumpy light
Plug 'unblevable/quick-scope' 

" (lighline) Smarter status bar
Plug 'itchyny/lightline.vim'

" (vim-visual-multi) Multiline select
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" (markdown preview) Markdown web view
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }

" (tidymarkdown) A beautifier for markdown
Plug 'groovytron/vim-tidymarkdown'

" (Plug sheerun/vim-polyglot) Syntax highlighting for $everything
Plug 'sheerun/vim-polyglot'

" (vim-autoformat) Beautifier for HTML
Plug 'vim-autoformat/vim-autoformat'

" (vim-prettier) format things nicely
Plug 'prettier/vim-prettier', { 'do': 'npm install --production' }

" (vim-react-snippets) Snippets for react: https://github.com/mlaursen/vim-react-snippets#function-components-javascript
" Plug 'SirVer/ultisnips'
Plug 'mlaursen/vim-react-snippets'

call plug#end()

let g:mkdp_open_to_the_world = 1
let g:mkdp_port = 8080
function! g:EchoUrl(url)
    :echo a:url
endfunction
let g:mkdp_browserfunc = 'g:EchoUrl'

" nmap <leader> <Plug>MarkdownPreview
" nmap <leader> <Plug>MarkdownPreviewStop
nmap <Leader>m <Plug>MarkdownPreviewToggle

" Make RipGrep NOT search file names
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

" FZF Searches
" Alt-Shift-f will search selected word
nnoremap <silent> <Esc>F :Rg <C-r><C-w><CR>
nnoremap <silent> <C-f> :Rg<CR>
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <leader>g :Commits<CR>
nnoremap <silent> <leader>b :Buffers<CR>

" Git Blame
nnoremap <leader>gb :Git blame<CR>

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" map <Esc>I :FormatJs<CR>
autocmd FileType css map <Esc>I :Prettier<CR>
autocmd FileType javascriptreact map <Esc>I :Prettier<CR>
autocmd FileType html map <Esc>I :Autoformat<CR>
autocmd FileType javascript,json map <Esc>I :Prettier<CR>
autocmd FileType markdown map <Esc>I :TidyMd<CR>
autocmd FileType terraform map <Esc>I :!terraform fmt<CR>

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()

function! ToggleNerdTree()
  set eventignore=BufEnter
  NERDTreeToggle
  set eventignore=
endfunction


" Escape seems on the way out
inoremap jk <ESC>

" File Explorer
nmap <leader>n :call ToggleNerdTree()<CR>

" Toggle NerdCommenter with CTRL-/
vmap <C-_> <plug>NERDCommenterToggle
nmap <C-_> <plug>NERDCommenterToggle
" Put a space after comment
let NERDSpaceDelims=1

" open NERDTree automatically
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * NERDTree

" Edit vimr configuration file
nnoremap <Leader>ve :e $MYVIMRC<CR>
" Reload vimr configuration file
nnoremap <Leader>vr :source $MYVIMRC<CR>

" Split screen vertically
nnoremap <Leader>\| :vsplit<CR>
nnoremap <Leader>- :split<CR>

set number

" from readme
" if hidden is not set, TextEdit might fail.
set hidden 

" Some servers have issues with backup files, see #649 
set nobackup 
set nowritebackup 

" Better display for messages 
set cmdheight=2 

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <Leader>ce :CocEnable<CR>
nnoremap <Leader>cd :CocDisable<CR>

let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:NERDTreeGitStatusWithFlags = 1
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusNodeColorization = 1
let g:NERDTreeColorMapCustom = {
  \ "Staged"    : "#0ee375",
  \ "Modified"  : "#d9bf91",
  \ "Renamed"   : "#51C9FC",
  \ "Untracked" : "#FCE77C",
  \ "Unmerged"  : "#FC51E6",
  \ "Dirty"     : "#FFBD61",
  \ "Clean"     : "#87939A",
  \ "Ignored"   : "#808080"
  \ }


let g:NERDTreeIgnore = ['^node_modules$']

" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-solargraph', 
  \ 'coc-yaml', 
  \ 'coc-lua', 
  \ 'coc-css', 
  \ 'coc-json', 
  \ ]


if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

if &term =~ '^tmux'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

set mouse+=a

if (has("termguicolors") && &term =~ '^tmux')
  " This is only necessary if you use set termguicolors.
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

let g:onedark_color_overrides = {
\ "background": {"gui": "#000000", "cterm": "000", "cterm16": "0" },
\ "black": {"gui": "#000000", "cterm": "000", "cterm16": "0" },
\ "purple": { "gui": "#C678DF", "cterm": "170", "cterm16": "5" }
\}

colorscheme onedark

set modeline
set modelines=5

filetype plugin indent on
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

autocmd bufnewfile,bufread *.tsx set filetype=typescriptreact
autocmd bufnewfile,bufread *.jsx set filetype=javascriptreact

autocmd FileType c,lua,cpp,java,php,sh,typescript autocmd BufWritePre <buffer> %s/\s\+$//e
autocmd FileType markdown set spell
autocmd FileType css setl iskeyword+=-
autocmd FileType scss setl iskeyword+=@-@

xnoremap <leader>m :w ! bash -c cat<CR>

