call plug#begin('~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

" Plug 'kyazdani42/nvim-web-devicons'
" Plug 'ryanoasis/vim-devicons'

" Those two require migration to lua setup.
" Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}

Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'projekt0n/github-nvim-theme'

Plug 'ThePrimeagen/vim-be-good'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-dispatch'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neoinclude.vim'
Plug 'zchee/deoplete-clang'
Plug 'deoplete-plugins/deoplete-clang'
Plug 'tyru/open-browser.vim'
Plug 'derekwyatt/vim-fswitch'
" Plug 'w0rp/ale'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'ThePrimeagen/harpoon'
Plug 'Chiel92/vim-autoformat'
Plug 'bfrg/vim-cpp-modern'
Plug 'MaskRay/ccls'
Plug 'SirVer/ultisnips'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'voldikss/vim-floaterm'
Plug 'cdelledonne/vim-cmake'
Plug 'alepez/vim-gtest'
Plug 'tpope/vim-commentary'
Plug 'windwp/nvim-spectre'
Plug 'xiyaowong/nvim-transparent'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'masukomi/vim-markdown-folding'
Plug 'FotiadisM/tabset.nvim'

call plug#end()

set exrc
set guicursor=
set number
set relativenumber
set hidden
set secure
set cmdheight=2
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set wrap
set linebreak
set nolist
set incsearch
set ignorecase
set scrolloff=8

inoremap ,, <esc>

lua require('lspconfig').clangd.setup{}

let &path.='src/include,/usr/include/AL,/home/quietmediocrity/dev/cpp/include'

" whole config for colors can be found here: https://github.com/projekt0n/github-nvim-theme/blob/main/lua/github-theme/colors.lua
"
" previous keyword color: 17a465
" previous keyword color: 1aa24d
lua require('github-theme').setup({
      \ theme_style = 'dark',
      \ colors = {
        \ syntax = { keyword = "#46ad6c" },
        \ }
        \ })
let g:airline_theme='onehalfdark'

" for white head of terminal -> dconf editor ->
" org/gnome/terminal/legacy/theme-variant -> light

" lua require('github-theme').setup({
"       \ theme_style = 'light',
"       \ colors = {
"           \ syntax = { keyword = "#177f2c" },
"           \ }
"       \ })

" statusline
" hi statusline guibg=White guifg=#24292E
hi statusline guibg=#24292e guifg=#bdbdbd

" bg transparency setting
" let g:transparent_enabled = v:true

" Yank from the cursor until the end of the line
nnoremap Y y$

" Keeping it centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Ctrl - j/k deletes blank line below/above and Alt - j/k inserts
nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

" Undo break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" Jumplist mutations
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Moving text around
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==
inoremap <C-k> <esc>:m .-2<CR>==
nnoremap <leader>K :m .-2<CR>==
nnoremap <leader>J :m .+1<CR>==

" Set <leader> to space
let mapleader = ' '
let maplocalleader = ' '

" c/ppreference and qt search
let g:openbrowser_search_engines = extend(
      \ get(g:, 'openbrowser_search_engines', {}),
      \ {
        \   'cppreference': 'https://en.cppreference.com/mwiki/index.php?title=Special%3ASearch&search={query}',
        \   'qt': 'https://doc.qt.io/qt-5/search-results.html?q={query}',
        \ },
        \ 'keep'
        \)

nnoremap <silent> <leader>osx :call openbrowser#smart_search(expand('<cword>'), "cppreference")<CR>
nnoremap <silent> <leader>osq :call openbrowser#smart_search(expand('<cword>'), "qt")<CR>

" Setup for vim-fswitch plugin
au BufEnter *.h let b:fswitchdst = 'c,cpp,m,cc' | let b:fswitchlocs = 'reg:|include.*|src/**|'

nnoremap <silent> <A-o> :FSHere<cr>
" Extra hotkeys to open header/source in the split
nnoremap <silent> <leader>ol :FSSplitLeft<cr>
nnoremap <silent> <leader>ob :FSSplitBelow<cr>
nnoremap <silent> <leader>oa :FSSplitAbove<cr>
nnoremap <silent> <leader>or :FSSplitRight<cr>

" clang-format
function! s:ClangFormat(first, last)
  let l:winview = winsaveview()
  execute a:first . ',' . a:last . '!clang-format'
  call winrestview(l:winview)
endfunction
command! -range=% ClangFormat call <sid>ClangFormat (<line1>, <line2>)

au FileType c,cpp,cc nnoremap <buffer><leader>cf :<C-u>ClangFormat<CR>
au FileType c,cpp,cc vnoremap <buffer><leader>cf :ClangFormat<CR>

" vim-cpp-modern hightlighting
let g:cpp_function_highlight = 0
let g:cpp_attribute_highlight = 1
let g:cpp_member_hightlight = 0
let g:cpp_class_highlight = 1

" Buffers shenanigans
nnoremap <leader>bn :bnext<cr>
nnoremap <leader>bp :bprevious<cr>
nnoremap <leader>bd :bdelete<cr>
nnoremap <leader>ba :badd
nnoremap <leader>bc :bp\|bd #<cr>
" Close all buffers except current
nnoremap <leader>bq :%bd\|e#<cr>
nnoremap <leader>bb :%bd<cr>

"" ultisnips
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsJumpForwardTrigger='<c-l>'
let g:UltiSnipsJumpBackward='<c-h>'
let g:UltiSnipsSnippetDirectories=['customsnippets']
"" _ultisnips

"" telescope
lua require('telescope').setup({ defaults = { file_sorter = require('telescope.sorters').get_fzy_sorter}})

nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<cr>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap <leader>pf :lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <leader>pb :lua require('telescope.builtin').buffers()<CR>
"" _telescope

"" neoclide nvim.coc

" TextEdit might fail if hidden is not set.
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
" nmap <silent> g[ <Plug>(coc-diagnostic-prev)
" nmap <silent> g] <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show documentation in preview window.
nnoremap <silent> <leader>sd :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . ' ' . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"" _neoclide nvim.coc

"" vim-floaterm

let g:floaterm_keymap_toggle = '<leader>ft'
nmap <C-t> :FloatermNew fff<cr>
let g:floaterm_width = 0.9
let g:floaterm_height = 0.9
nmap <leader>fk :FloatermKill<cr>
" Enter normal mode inside floating terminal with <C-\><C-n>

" _vim-floaterm

" vim-cmake
nmap <leader>cmg <Plug>(CMakeGenerate)
nmap <leader>cmb <Plug>(CMakeBuild)
nmap <leader>cmt <Plug>(CMakeBuildTarget)
nmap <leader>cmo <Plug>(CMakeOpen)
nmap <leader>cmc <Plug>(CMakeClose)
nmap <leader>cmn :cnext<cr>
nmap <leader>cmp :cprevious<cr>
let g:cmake_default_config='build'
let g:cmake_console_size=25

" for C projects with just makefile or build script
nnoremap <leader>mb :make<cr>
nnoremap <leader>mo :copen<cr>
nnoremap <leader>mc :cclose<cr>

" CMakeBuildFailed event
let g:cmake_jump_on_error = 0 " do not want to focus the console
augroup vim-cmake-group
  autocmd User CMakeBuildFailed :cfirst
augroup END

" CMakeBuildSucceeded
augroup vim-cmake-group
  autocmd! User CMakeBuildSucceeded CMakeClose
augroup END

" vim-cmake notes:
" to open list of errors -> :copen
" to jump between erros -> :cfirst :cnext

nmap <leader>gt :GTestRunUnderCursor<cr>
" _vim-cmake

" nvim-spectre
nnoremap <leader>S :lua require('spectre').open()<CR>

"search current word
nnoremap <leader>sw :lua require('spectre').open_visual({select_word=true})<CR>
vnoremap <leader>s :lua require('spectre').open_visual()<CR>
"  search in current file
nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>
" _nvim-spectre

fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

augroup QuietMediocrity
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
  autocmd BufRead, BufNewFile *.h, *.c set filetype=c.doxygen
augroup END

map <leader>h :noh<CR>

nnoremap <leader>qf :CocFix<cr>

" let g:ale_linters = {
"       \ 'cpp': ['cc', 'ccls', 'clangd', 'clangtidy', 'cppcheck'],
"       \}

" let g:ale_fixers = {}
" let g:ale_fixers.cpp = ['clang-format', 'clangtidy']

" nnoremap <leader>qf <Plug>(ale_fix)

" folding settings
let g:markdown_fold_style = 'nested'
autocmd FileType markdown set foldexpr=NestedMarkdownFolds()
" augroup VimFolding
"   au BufReadPre * setlocal foldmethod=indent
"   au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
" augroup END
" _folding settings

" spelling checks
" Spell-check Markdown files and Git Commit Messages
augroup Spelling
  autocmd FileType markdown setlocal spell
  autocmd FileType gitcommit setlocal spell
  " Enable dictionary auto-completion in Markdown files and Git Commit Messages
  autocmd FileType markdown setlocal complete+=kspell
  autocmd FileType gitcommit setlocal complete+=kspell
augroup END
" _spelling checks

nnoremap <leader>af :Autoformat<cr>

" deoplite
" let g:deoplete#enable_at_startup = 1

" SourceKit-LSP configuration
if executable('sourcekit-lsp')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'sourcekit-lsp',
        \ 'cmd': {server_info->['sourcekit-lsp']},
        \ 'whitelist': ['swift'],
        \ })
endif

lua require("tabset").setup({
      \ defaults = {
        \     tabwidth = 2,
        \     expandtab = true
        \ },
        \ languages = {
          \     c = {
            \         tabwidth = 8,
            \         expandtab = true
            \     },
            \     make = {
              \         tabwidth = 4,
              \         expandtab = false
              \     },
              \ },
              \ })
