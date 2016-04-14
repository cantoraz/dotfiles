" ======================================================================
" Title: Cantoraz's vimrc
" Author: Cantoraz
" License: GPLv3
" Date: Mon, 2012-02-13 22:43:50 CST

" ======================================================================
" # Dependencies - Libraries/Applications outside of vim
" ======================================================================
" Pep8
" Ack
" Rake & Ruby for command-t
" nose, django-nose

" ======================================================================
" # Plugins Management
" ======================================================================
	" ======================================================================
	" ## Vundle - Manage our vim plugins
	" ======================================================================
	" original repos on github
	" Eg, Bundle 'lokaltog/vim-easymotion'
	" Eg, Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
	"
	" vim-scripts repos
	" Eg, Bundle 'L9'
	" Eg, Bundle 'FuzzyFinder'
	" Eg, Bundle 'rails.vim'
	"
	" non github repos
	" Eg, Bundle 'git://git.wincent.com/command-t.git'

	" Load all plugins
	set nocompatible			" be iMproved
	filetype off				" required!
	set rtp+=~/.vim/bundle/vundle/
	call vundle#rc()

	" The plug-in manager for Vim. Here let Vundle manage Vundel
	Bundle 'gmarik/vundle'

	" My Bundles here:

	" Plugin for the Perl module / CLI script 'ack'
	"Bundle 'vim-scripts/ack.vim'
	Bundle 'mileszs/ack.vim'

	" CoffeeScript support for vim
	Bundle 'kchmck/vim-coffee-script'

	" Collections of snippets for CoffeScript
	Bundle 'carlosvillu/coffeScript-VIM-Snippets'

	" Allows easy search and opening of files within a given path 
	" Bundle 'wincent/Command-T'

	" Auto-mirror of the official svn repo (syncs once per day)
	Bundle 'rson/vim-conque'

	" Highlight colors in css files
	Bundle 'skammer/vim-css-color'

	" Add CSS3 syntax support to vim's built-in `syntax/css.vim`.
	Bundle 'hail2u/vim-css3-syntax'

	" Fuzzy file, buffer, mru and tag finder
	Bundle 'kien/ctrlp.vim'

	" Provides insert mode auto-completion for quotes, parens, brackets, etc.
    Bundle 'Raimondi/delimitMate'

	" Interface with git from vim
	Bundle 'tpope/vim-fugitive'

	" Syntax highlighting for git config files
	Bundle 'tpope/vim-git'

	" Visual Undo in vim with diff's to check the differences
	Bundle 'sjl/gundo.vim'

	" A Vim plugin for visually displaying indent levels in code
	Bundle 'nathanaelkane/vim-indent-guides'

	" An alternative indentation script for python
	Bundle 'vim-scripts/indentpython.vim'

	" vim syntax for LESS (dynamic CSS)
	Bundle 'groenewege/vim-less'

	" Extended % matching for HTML, LaTeX, and many other languages
	Bundle 'vim-scripts/matchit.zip'
	
	" Generic test runner that works with nose
	"Bundle 'reinh/vim-makegreen'

	" Visually display what buffers are currently opened
	"Bundle 'vim-scripts/minibufexpl.vim'
	"Bundle 'fholgado/minibufexpl.vim'
	"Bundle 'sontek/minibufexpl.vim'

	" A tree explorer plugin for navigating the filesystem
	Bundle 'vim-scripts/The-NERD-tree'

	" Better Management of VIM plugins 
	Bundle 'tpope/vim-pathogen'

	" Check your python source files with PEP8
	"Bundle 'vim-scripts/pep8'

	" Tab-complete your Python code
	"Bundle 'vim-scripts/Pydiction'

	" pydoc integration for the best text editor on earth
	"Bundle 'fs111/pydoc.vim'

	" Underlines and displays errors with Python on-the-fly
	" an improved pyflakes module is INCLUDED with this plugin,
	" so you don't need to install it separately
	Bundle 'mitechie/pyflakes-pathogen'

	" Run py.test test's from within vim 
	"Bundle 'alfredodeza/pytest.vim'

	" Bundle 'vim-scripts/python.vim--Vasiliev'
	Bundle 'vim-scripts/python.vim'

	" Ruby on Rails power tools
	Bundle 'tpope/vim-rails'

	" Pathogen compatable ropevim plugin.
	" Dont need install rope libs in system.
	"Bundle 'klen/rope-vim'
	"Bundle 'sontek/rope-vim'

	" Beautiful rspec output in vim.
	" See also: https://github.com/skwp/vim-ruby-conque
	" for non-blocking rspec through ConqueTerm
	" Bundle 'skwp/vim-rspec'

	" Vim/Ruby Configuration Files
	Bundle 'vim-ruby/vim-ruby'

	" Vim plugin to display ruby, rake, and rspec
	" output colorized in ConqueTerm
	Bundle 'skwp/vim-ruby-conque'

	" switch Ruby versions from inside Vim
	Bundle 'tpope/vim-rvm'

	" Configurable snippets to avoid re-typing common comands
	Bundle 'msanders/snipmate.vim'

	" Functions to help make behavioral testing easy with ruby and rspec.
	" Bundle 'vim-scripts/Specky'

	" Perform all your vim insert mode completions with Tab
	"Bundle 'ervandew/supertab'

	" Allows you to surround text with open/close tags
	Bundle 'tpope/vim-surround'

	" Source code browser
	" (supports C/C++, java, perl, python, tcl, sql, php, etc)
	Bundle 'vim-scripts/taglist.vim'

	" Eclipse like task list 
	Bundle 'vim-scripts/TaskList.vim'

	" An extensible & universal comment vim-plugin
	" that also handles embedded filetypes
	Bundle 'tomtom/tcomment_vim'

	" tmux syntax
	" Bundle 'tsaleh/vim-tmux'
	Bundle 'acustodioo/vim-tmux'

	" Vim plugins for HTML and CSS hi-speed coding.
	Bundle 'mattn/zencoding-vim'

	" Color schemes here:
	
	" A slightly-modified desert theme, for 88- and 256-color xterms.
	Bundle 'desert256.vim'

	" A port of the Railscasts Textmate theme to Vim (GUI Only)
	Bundle 'jpo/vim-railscasts-theme'

	" Precision colors for machines and people
	Bundle 'altercation/vim-colors-solarized'

	" A color scheme that imitates the Twilight theme for TextMate
	Bundle 'twilight256.vim'

	" A low-contrast color scheme for Vim. 
	Bundle 'Zenburn'

	" ======================================================================
	" ## Pathogen - organize our vim plugins out of Vundle
	" ======================================================================
	" Load pathogen with docs for all plugins
	call pathogen#runtime_append_all_bundles('nobundle')
	call pathogen#helptags()

" ======================================================================
" # General Settings
" ======================================================================
filetype plugin indent on   " required!
                            " trye to detect filetypes
                            " enable loading indent file for filetype
set helplang=cn             " Enable help in Chinese language

	" ======================================================================
	" ## File Reading/Writing
	" ======================================================================
	"set modeline				" Allow vim options to be embedded in files;
	"set modellines=5			" they must be within the first
								" or last 5 lines.

	set noautowrite             " Never write a file unless I request it.
	set noautowriteall          " NEVER.
	set noautoread              " Don't automatically re-read changed files.
	set ffs=unix,mac,dos        " Try recognizing dos, unix
								" and mac line endings.
	let &termencoding=&encoding " Encoding detection
	set fileencodings=ucs-bom,utf-8,cp936,euc-cn,cp950,big5,euc-tw,default
				\,latin0

	" ======================================================================
	" ## Display
	" ======================================================================
	syntax enable               " syntax highlighting
	set number                  " Display line numbers
	set numberwidth=1           " using only 1 column (and 1 space)
								" while possible
	"set background=dark        " We are using dark background in vim
	set cursorline              " have a line indicate the cursor location
	"set nowrap					" don't wrap text
	set linebreak               " don't wrap text in the middle of a world
	"set listchars=tab:>-,eol:$,trail:-,precedes:<,extends:>
	"set listchars=tab:▸\ ,eol:↵
	set listchars=tab:│┈,eol:↵,trail:·,extends:>,precedes:<,nbsp:˽

	set t_Co=256
	colorscheme twilight256

	if has('gui_running')
		colorscheme railscasts
		set guicursor+=a:blinkon0
		set list                " displays tabs with :set list 
								" displays when a line runs off-screen
		if has("gui_macvim")    " MacVim
			let s:caz_guifont = "Menlo:h14"
			let s:caz_lines = 999
			let s:caz_columns = 84
		elseif has("gui_gtk2")  " GTK+2
			let s:caz_guifont = "DejaVu\ Sans\ Mono\ 12"
			let s:caz_lines = 50
			let s:caz_columns = 84
		elseif has("gui_win32") " WIN32
			let s:caz_guifont = "DejaVu\ Sans\ Mono:h13"
			let s:caz_lines = 38
			let s:caz_columns = 84
		endif

		let &guifont = s:caz_guifont
		let &lines = s:caz_lines
		if !exists('b:caz_columns_saved')
			let &columns = s:caz_columns
			let b:caz_columns_saved = &columns
		endif
	endif

	if exists("&colorcolumn")
		setlocal colorcolumn=80
		" Incompatible with MiniBufExpl, hack this color in used ColorScheme
		"hi ColorColumn term=reverse ctermbg=3 guibg=#3d3535
	endif

	" ====================================================================
	" ## Messages/Info/Status
	" ====================================================================
	"set vb t_vb=				" Disable all bells. I hate ringing/flashing.
	set title                   " show title in console title bar
	set ruler                   " show the cursor position all the time
	set shortmess+=a            " Use [+]/[RO]/[w] for
								" modified/readonly/written.
	set laststatus=2            " Always show status line,
								" even if only 1 window.
	" 缓冲区号 文件名 行数 修改 帮助 只读 编码 换行符 BOM
	" ======== 字符编码 位置 百分比位置
	set statusline=%n\ %<%f\ %LL\ 
				\%{&modified?'[+]':&modifiable\|\|
				\&ft=~'^\\vhelp\|qf$'?'':'[-]'}%h%r
				\%{&fenc=='utf-8'\|\|&fenc==''?'':'['.&fenc.']'}
				\%{&ff=='unix'?'':'['.&ff.']'}
				\%{&bomb?'[BOM]':''}%{&eol?'':'[noeol]'}
				\%=
				\%{exists('$rvm_path')?rvm#statusline():''}
				\%{fugitive#statusline()}
				\\ 0x%-4.4B\ \ \ \ %-14.(%l,%c%V%)\ %P
	"set statusline=%<%f\ (%{&ft})
				\%=%-19(%3l,%02c0%03V%)%{fugitive#statusline()}
	set wildmenu                " Menu completion in commond mode on <Tab>
	set wildmode=full           " <Tab> cycles between all matching choices.
	set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
				\,*.so,*/.o,*/.obj,*/.pyc
								" Ignore these files when completing
	set showcmd                 " Show incomplete normal mode commands
								" as I type.
	set confirm                 " Y-N-C prompt if closing with unsaved changes.
	set report=0                " : commands always print changed line count.

	" ======================================================================
	" ## Moving/Editing
	" ====================================================================
	set backspace=2             " Allow backspacing over autoindext,
								" EOL and BOL
	set nostartofline           " Avoid moving cursor to BOL
								" when jumping around
	set scrolloff=3             " Keep 3 context lines above
								" and below the cursor
	set virtualedit=block       " Let cursor move past the last char
								" in <C-v> mode

	set showmatch               " Briefly jump to a paren once it's balanced
	set matchtime=2             " (for only .2 seconds)
	set matchpairs+=<:>         " show matching <> (xml/html mainly) as well

	set foldmethod=indent       " allow us to fold on indents
	set foldlevel=99            " don't fold by default

	"au BufEnter * lcd %:p:h	" Auto change the directory
								" to the current file I'm working on

	" close preview window automatically when we move around
	"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
	"autocmd InsertLeave * if pumvisible() == 0|pclose|endif

	" ======================================================================
	" ## Indentation
	" ======================================================================
	set autoindent              " always set autoindenting on
	set tabstop=2               " <tab> inserts 4 spaces
	set shiftwidth=2            " and an indent level is 4 spaces wide
	set softtabstop=2           " <BS> over an autoindent deletes both spaces.
	" set expandtab				" Use spaces, not tabs, for autoindent/tab key.
	" set shiftround				" rounds indent to a multiple of shiftwidth

	" ======================================================================
	" ## Completion
	" ======================================================================
	" don't select first item, follow typeing in autocomplete
	set completeopt=menuone,longest,preview
	set pumheight=20            " Keep a small completion window

	" Refer: ft-syntax-omni
	if has("autocmd") && exists("+omnifunc")
		autocmd Filetype *
				\	if &omnifunc == "" |
				\		setlocal omnifunc=syntaxcomplete#Complete |
				\	endif
	endif

	" ======================================================================
	" ## Searching/Patterns
	" ======================================================================
	set ignorecase              " Default to using case insensitive searches,
	set smartcase               " unless uppercase letters are used
								" in the regex.
	set hlsearch                " Highlight searches by default.
	set incsearch               " Incrementally search while typing a /regex
	"set grepprg=ack-prep		" replace the default grep program with ack

	" ======================================================================
	" ## Key Mapping
	" ======================================================================
	" Note: Do not map <C-S>, <C-Q> or <C-unprintable>

	if exists('&macmeta')
		" set macmeta				" Enable option key as meta key under Mac
	endif
	"let mapleader=","			" Change the leader to be a comma vs splash

	" Autocomplete
	imap <F2> <C-X><C-O>

	" Quick to <C-W>
	nmap ' <C-W>

	" Quick to shell command
	nmap :: :!

	" Quick to comman
	nnoremap ;; :

	" Disable Ex mode key mappings
	nmap Q <Nop>
	omap Q <Nop>
	nmap gQ <Nop>
	omap gQ <Nop>

	" Copy all characters after current position
	nmap Y y$

	" Save
	nmap <C-X><C-X> <Esc>:update<CR>
	map! <C-X><C-X> <Esc>:update<CR>a

	" Cycle windows
	map <C-J> <C-W>j
	map <C-K> <C-W>k
	map <C-L> <C-W>l
	map <C-H> <C-W>h

	" Ctrl-c to jank/copy, Ctrl-v to paste
	map <C-C> "+y
	map <C-V> "+p

	" Insert current timestamp/date/time
	" if exists('*strftime')
	" 	imap <silent> <C-I><C-F> <C-R>=strftime('%a, %F %T %Z')<CR>
	" 	imap <silent> <C-I><C-T> <C-R>=strftime('%T %Z')<CR>
	" 	imap <silent> <C-I><C-D> <C-R>=strftime('%F')<CR>
	" endif

	" and lets make these all work in insert mode too
	" ( <C-O> makes next cmd happend as if in command mode )
	"imap <C-W> <C-O><C-W>

	" Move line
	nmap <S-Up> mz:m-2<cr>`z
	nmap <S-Down> mz:m+<cr>`z
	vmap <S-Up> :m'<-2<cr>`>my`<mzgv`yo`z
	vmap <S-Down> :m'>+<cr>`<my`>mzgv`yo`z

	" New line above
	imap <S-CR> <Esc>O

	" New line below
	imap <C-CR> <Esc>o

	" Turn off hlsearch on enter
	nnoremap <CR> :nohlsearch<CR>

	" Folding
	nnoremap <Space> za

	" Seriously, guys. It's not like :W is bound to anything anyway.
	"command! W :w

	" for when we forget to use sudo to open/edit a file
	"cmap w!! w !sudo tee % >/dev/null

	" brings up my .vimrc
	map <silent> <leader>v :e ~/.vimrc<CR>
	" reloads .vimrc -- making all changes active (have to save first)
	map <silent> <leader>V :source ~/.vimrc<CR>:echo 'vimrc reloaded.'<CR>

	" List buffers
	map <leader>bb :ls<CR>
	" Delete current buffer
	map <leader>bd :bd<CR>
	" Cycle buffers
	map <leader>bn :bnext<CR>
	map <leader>bp :bprevious<CR>

	" Change working directory
	nnoremap <silent> <leader>. :lcd %:p:h<CR>:echo expand('%:p:h')<CR>

	" Toggle line numbers and fold column for easy copying
	nnoremap <leader>nu :set nonumber!<CR>:set foldcolumn=0<CR>

	" open/close the quickfix window
	nmap <leader>c :copen<CR>
	nmap <leader>C :cclose<CR>

" ======================================================================
" # FileType Setting
" ======================================================================
	" ======================================================================
	" ## C
	" ======================================================================
	au FileType c setlocal ts=4 sts=4 sw=4 et ai sta 
	au FileType c set omnifunc=ccomplete#Complete

	" ======================================================================
	" ## CSS
	" ======================================================================
	au FileType css setlocal ts=2 sts=2 sw=2 et ai sta
	au FileType css set omnifunc=csscomplete#CompleteCSS
	
	" ======================================================================
	" ## HTML
	" ======================================================================
	au FileType html,xhtml setlocal ts=2 sts=2 sw=2 noet ai sta
	au FileType html set omnifunc=htmlcomplete#CompleteTags

	" ======================================================================
	" ## Javscript
	" ======================================================================
	au FileType javascript setlocal ts=2 sts=2 sw=2 et ai sta
	au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
	au FileType javascript set makeprg=jsl\ %

	" ======================================================================
	" ## LESS
	" ======================================================================
	au FileType less setlocal ts=2 sts=2 sw=2 et ai sta

	" ======================================================================
	" ## PHP
	" ======================================================================
	au FileType php setlocal ts=2 sts=2 sw=2 et ai sta
	au FileType php map <buffer> <F11> :w<CR>:!/usr/bin/env php %<CR>

	" ======================================================================
	" ## Python
	" ======================================================================
	au FileType python setlocal ts=4 sts=4 sw=4 et ai sta
	au FileType python set omnifunc=pythoncomplete#Complete
	au FileType python set errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\
				\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
	"au FileType python compiler nose

	" Improve formatting and display of improper indentation.
	" Refer: http://www.vim.org/scripts/script.php?script_id=790
	"au FileType python set complete+=k~/.vim/bundle/python.vim--Vasiliev/syntax/python3.0.vim isk+=.,(

	" Ability to run script beging edited.
	" Execute file being edited with <F11>
	au FileType python map <buffer> <F11> :w<CR>:!/usr/bin/env python %<CR>
	" Debug file being edited with <Shift> + <F11>
	au FileType python map <buffer> <S-F11> :w<CR>:!/usr/bin/env python -m pdb %<CR>

	" Trim trailing whitespace
	"au BufWritePre *.py normal m`:%s/\s\+$//e``

	" turn off hlsearch and update pyflakes on enter
	"au FileType python nnoremap <CR> :nohlsearch\|:call PressedEnter()<CR>

		" ====================================================================
		" ### Plugins for Python
		" ====================================================================
			" ================================================================
			" #### Pep8
			" ================================================================
			"let g:pep8_map='<leader>8'  " Run pep8

			" ================================================================
			" #### Py.test
			" ================================================================
			" Execute the tests
			"nmap <silent><leader>tf <Esc>:Pytest file<CR>
			"nmap <silent><leader>tc <Esc>:Pytest class<CR>
			"nmap <silent><leader>tm <Esc>:Pytest method<CR>

			" Cycle through test errors
			"nmap <silent><leader>tn <Esc>:Pytest next<CR>
			"nmap <silent><leader>tp <Esc>:Pytest previous<CR>
			"nmap <silent><leader>te <Esc>:Pytest error<CR>

			" ================================================================
			" #### Pydiction
			" ================================================================
			"let g:pydiction_location = '$HOME/.vim/bundle/Pydiction/complete-dict'
			" The default menu height is 15.
			"let g:pydiction_menu_height = 20

			" ================================================================
			" #### Pyflakes
			" ================================================================
			" Don't let pyflakes use the quickfix window
			let g:pyflakes_use_quickfix=0

			" clear the search bufrer when hitting return
			" and update pyflakes checks
			function! PressedEnter()
				:nohlsearch
				if &filetype == 'python'
					:PyflakesUpdate
				end
			endfunction

			" ================================================================
			" #### Rope
			" ================================================================
			" Jump to the definition of whatever the cursor is on 
			"map <leader>j :RopeGotoDefinition<CR>
			" Rename whatever the cursor is on (including references to it)
			"map <leader>r :RopeRename<CR>

			" ================================================================
			" #### Nose, Django-Nose, MakeGreen
			" ================================================================
			" Run django tests
			"map <leader>dt :set makeprg=pyton\ manger.py\ test\|:call MakeGreen()<CR>

	" ======================================================================
	" ## RSpec
	" ======================================================================
	au BufRead *_spec.rb set ft=rspec
	au FileType rspec setlocal commentstring=#\ %s
	au FileType rspec let delimitMate_matchpairs = '(:),{:},[:]'
	" Run current RSpec file being edited with <F11>
	au FileType rspec map <buffer> <F11> :w<CR>:call RunRspecCurrentFileConque()<CR>
	" Run current line in RSpec file being edited with <Shift> + <F11>
	au FileType rspec map <buffer> <C-F11> :w<CR>:call RunRspecCurrentLineConque()<CR>
	
	" ======================================================================
	" ## Ruby
	" ======================================================================
	au FileType ruby,eruby,yaml setlocal ts=2 sts=2 sw=2 et ai sta
	au FileType ruby let delimitMate_matchpairs = '(:),{:},[:]'
	au BufRead,BufNewFile Gemfile,Rakefile,Thorfile,config.ru,Vagrantfile
				\,Guardfile,Capfile set ft=ruby

	" ======================================================================
	" ## Plugins for Ruby
	" ======================================================================
		" =================================================================
		" ### Vim-Ruby
		" =================================================================
		autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
		autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
		" autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
		" autocmd FileType ruby,eruby let g:rubycomplete_include_object = 1
		" autocmd FileType ruby,eruby let g:rubycomplete_include_objectspace = 1

	" ======================================================================
	" ## Vim
	" ======================================================================
	au FileType vim setlocal ts=2 sts=2 sw=2 noet ai sta
	" au FileType vim set listchars=tab:▸\ ,eol:↵,trail:·,extends:>,precedes:<,nbsp:˽

" ======================================================================
" # General Plugins
" ======================================================================
	" ======================================================================
	" ## Ack searching
	" ======================================================================
	nmap <leader>a <Esc>:Ack 

	" ======================================================================
	" ## Command-T
	" ======================================================================
	" Run command-t file search
	" map <leader>tt :CommandT<CR>
	" map <leader>tb :CommandTBuffer<CR>
	" map <leader>tf :CommandTFlush<CR>

	" ======================================================================
	" ## ctrlp.vim
	" ======================================================================

	" ======================================================================
	" delimitMate"
	" ======================================================================
	let delimitMate_expand_cr = 1
	let delimitMate_expand_space = 1

	" ======================================================================
	" ## Gundo
	" ======================================================================
	" load the Gundo window
	map <leader>gu :GundoToggle<CR>

	" ======================================================================
	" ## MiniBufExpl
	" ======================================================================
	" let g:miniBufExplSplitToEdge = 1
	" let g:miniBufExplorerMoreThanOne = 1
	" let g:miniBufExplMapWindowNavVim = 1
	" let g:miniBufExplMapWindowNavArrows = 1
	" let g:miniBufExplMapCTabSwitchBufs = 1
	" let g:miniBufExplUseSingleClick = 1
	" let g:miniBufExplModSelTarget = 1
	" let g:miniBufExplForceSyntaxEnable = 1

	" ======================================================================
	" ## Open NerdTree
	" ======================================================================
	"au VimEnter * NERDTree|wincmd p
	"au TabEnter * NERDTreeMirror|wincmd p
	let NERDTreeWinPos = 'right'
	map <leader>nt :NERDTreeToggle<CR>

	" ======================================================================
	" ## SuperTab - Allows us to get code completion with tab
	" ======================================================================
	"let g:SuperTabDefaultCompletiontype = "context"

	" ======================================================================
	" ## TagList
	" ======================================================================
	let Tlist_Show_One_File=1
	let Tlist_Exit_OnlyWindow=1
	map <leader>tg :TlistToggle<CR>

	" ======================================================================
	" ## TaskList
	" ======================================================================
	map <leader>ts <Plug>TaskList

" ======================================================================
" # Functions
" ======================================================================

" ======================================================================
" # EOF
" ======================================================================
