" General settings
set nocompatible
filetype plugin indent on
syntax on

" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp1251,latin1

" Tabs and Indents
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

" Interface
set number
set relativenumber
set mouse=

" Search and Text
set ignorecase
set smartcase
set fixendofline
set backspace=indent,eol,start

" System and Clipboard
set clipboard=unnamedplus
set undofile

" Directory setup
if !isdirectory($HOME . '/.vim/undo')
    call mkdir($HOME . '/.vim/undo', 'p')
endif
set undodir=~/.vim/undo//

if !isdirectory($HOME . '/.vim/swap')
    call mkdir($HOME . '/.vim/swap', 'p')
endif
set directory=~/.vim/swap//

" Mappings
inoremap jj <Esc>

" Russian layout support
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
