" basic configuration
" ===================

" use Vim settings, rather than Vi settings
set nocompatible

" enable syntax and plugins (vim-plug does this)
" syntax enable
" filetype plugin on

" show row number
set number

" set encoding
scriptencoding utf-8
set encoding=utf-8

" indenting
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab

" fuzzy find inside projects folder
" =================================

" search down into subfolders
" provides tab-completion for all file-related tasks
set path+=**

" display all matching files during tab complete
set wildmenu

" tag jumping
" ===========

" create the 'tags' file
command! MakeTags !ctags -R

" <C ]> to go to tag under cursor
" <g C ]> for ambiguous tags
" <C t> to jump back the tag stack

" plugins
" =======
call plug#begin()

" haskell scripts
Plug 'neovimhaskell/haskell-vim'

" initialize plugin system
call plug#end()
