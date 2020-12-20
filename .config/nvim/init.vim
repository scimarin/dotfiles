" navigate wrapped lines
nmap j gj
nmap k gk

if !exists('g:vscode')
      "Source automatically
      autocmd BufWritePost .vimrc source %

      " load file to last position of cursor
      autocmd BufReadPost *
                        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                        \ |   exe "normal! g`\""
                        \ | endif

      " show vim file open name in tmux
      autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%:t"))
endif

" change current working directory unless in /tmp
autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif

" <space> as leader key
nnoremap <SPACE> <Nop>
let mapleader=" "

" copy to system clipboard
noremap <Leader>y "+y

" double esc to disable hlsearch
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" splits and Buffers
" for easy split navigation (Ctrl + hjkl)
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>

" resize splits
nnoremap <silent> <s-up>    :resize +2<cr>
nnoremap <silent> <s-down>  :resize -2<cr>
nnoremap <silent> <s-left>  :vertical resize -2<cr>
nnoremap <silent> <s-right> :vertical resize +2<cr>

" moving between buffers
nnoremap <M-l> :bn<CR>
nnoremap <M-h> :bprev<CR>

" close buffer
nnoremap <M-d> :bp\|bd #<CR>

" move line up/down
nnoremap <Leader>j ddp
nnoremap <Leader>k ddkP

" indentation
set autoindent
set smartindent
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
filetype plugin indent on

set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes
set autoread            "reload file on change on disk
set mouse=a
set encoding=utf-8      "windows specific rendering option
set undofile            "persistent undo
set number
set relativenumber
set scrolloff=3
set hlsearch
set incsearch
set inccommand=nosplit
set nowrapscan
set history=50
set autowrite
set ignorecase
set smartcase
set listchars=tab:>·,trail:$,extends:>,precedes:<
set list                " shows invisible characters
set hidden              " show hidden buffers
set foldlevelstart=1    " never fold
set foldmethod=syntax
set nofoldenable
set foldnestmax=10
set nobackup
set nowritebackup
set timeout
set timeoutlen=3000
set ttimeoutlen=100
syntax on

" display ASCII characters numerically
set display+=uhex

if $SERVER == 0
      if !exists('g:vscode')
            " install plug unless launched through vscode
            if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
                  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
                  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
            endif
      endif

      call plug#begin()
            " consistent vimscript
            Plug 'google/vim-maktaba'

            " coc aka vim intellisense
            Plug 'neoclide/coc.nvim', {'branch': 'release'}

            " coc config
            inoremap <silent><expr> <TAB>
                              \ pumvisible() ? "\<C-n>" :
                              \ <SID>check_back_space() ? "\<TAB>" :
                              \ coc#refresh()
            inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

            function! s:check_back_space() abort
                  let col = col('.') - 1
                  return !col || getline('.')[col - 1] =~# '\s'
            endfunction

            " use <c-space> to trigger completion
            inoremap <silent><expr> <c-space> coc#refresh()

            " use <cr> to confirm completion, `<C-g>u` means break undo chain at current
            " position. Coc only does snippet and additional edit on confirm.
            if has('patch8.1.1068')
                  " use `complete_info` if your (Neo)Vim version supports it.
                  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
            else
                  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
            endif

            " use `[g` and `]g` to navigate diagnostics
            nmap <silent> [g <Plug>(coc-diagnostic-prev)
            nmap <silent> ]g <Plug>(coc-diagnostic-next)

            " GoTo code navigation.
            nmap <silent> gd <Plug>(coc-definition)
            nmap <silent> gy <Plug>(coc-type-definition)
            nmap <silent> gi <Plug>(coc-implementation)
            nmap <silent> gr <Plug>(coc-references)

            " use K to show documentation in preview window.
            nnoremap <silent> K :call <SID>show_documentation()<CR>

            function! s:show_documentation()
                  if (index(['vim','help'], &filetype) >= 0)
                        execute 'h '.expand('<cword>')
                  else
                        call CocAction('doHover')
                  endif
            endfunction

            Plug 'autozimu/LanguageClient-neovim', {
                              \ 'branch': 'next',
                              \ 'do': './install.sh'
                              \ }

            let g:LanguageClient_serverCommands = {
                              \ 'python': ['/home/smooth/.local/bin/pyls'],
                              \ 'javascript': ['/usr/bin/typescript-language-server', '--stdio'],
                              \ 'typescript': ['/usr/bin/typescript-language-server', '--stdio'],
                              \ }

            nnoremap <F5> :call LanguageClient_contextMenu()<CR>
            map <Leader>lk :call LanguageClient#textDocument_hover()<CR>
            map <Leader>lg :call LanguageClient#textDocument_definition()<CR>
            map <Leader>lr :call LanguageClient#textDocument_rename()<CR>
            map <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
            map <Leader>lb :call LanguageClient#textDocument_references()<CR>
            map <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
            map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>

            " highlight the symbol and its references when holding the cursor.
            autocmd CursorHold * silent call CocActionAsync('highlight')

            Plug 'sheerun/vim-polyglot'               " language packs
            Plug 'vhda/verilog_systemverilog.vim'     " verilog syntax highlighting
            Plug 'elzr/vim-json'

            Plug 'junegunn/fzf.vim'                   " fuzzy finder
            Plug 'BurntSushi/ripgrep'                 " run ripgrep from inside vim

            " fuzzy finder for files and ripgrep through files for CWD
            nnoremap <c-o> :FZF<cr>
            nnoremap <c-p> :Rg<cr>

            " markdown support
            Plug 'plasticboy/vim-markdown'

            Plug 'prabirshrestha/async.vim'
            Plug 'ap/vim-buftabline'
            Plug 'scrooloose/nerdcommenter'
            Plug 'airblade/vim-rooter'
            Plug 'preservim/nerdtree'
            Plug 'jiangmiao/auto-pairs'
            Plug 'tpope/vim-surround'
            Plug 'alvan/vim-closetag'           " close HTML tags automatically

            " closetag config
            let g:closetag_filenames = '*.html,*.xhtml,*.phtml'
            let g:closetag_filetypes = 'html,xhtml,phtml'
            let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'
            let g:closetag_emptyTags_caseSensitive = 1
            let g:closetag_regions = {
                \ 'typescript.tsx': 'jsxRegion,tsxRegion',
                \ 'javascript.jsx': 'jsxRegion',
                \ }
            " add > at current position without closing the current tag, default is ''
            let g:closetag_close_shortcut = '<leader>>'

            " tagging the file to easily navigate methods and classes
            Plug 'ludovicchabant/vim-gutentags'
            Plug 'majutsushi/tagbar'
            nmap <C-m> :TagbarToggle<CR>

            " theming
            Plug 'morhetz/gruvbox'
            let g:gruvbox_contrast_dark='hard'
            let g:gruvbox_contrast_light='medium'

      call plug#end()

      if !exists('g:vscode')
            "Theming
            set termguicolors "sets to true colors
            let &t_ut=''

            set background=dark
            colorscheme gruvbox
      endif
endif
