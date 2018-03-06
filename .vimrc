source $HOME/.vim/.vimrc.dein
source $HOME/.vim/.vimrc.indent
source $HOME/.vim/.vimrc.appearance

"================================================================
" encoding
"================================================================

set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
set encoding=utf-8

"================================================================
" search
"================================================================

" 検索時に大文字小文字の区別をしない
set ignorecase

" 大文字小文字がどちらも含まれている場合は区別
set smartcase

" インクリメンタルサーチON
set incsearch

" 検索結果のハイライト
set hlsearch

" ファイル末尾まで検索したら先頭に戻る
set wrapscan

" Esc連打でハイライトを消す
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"================================================================
" moving
"================================================================

" <hoge></hoge>みたいなのも%で移動できる
set matchpairs+=<:>

" matchitを有効化（rubyのコードブロックに対応させる）
if !exists('loaded_matchit')
  runtime macros/matchit.vim
endif

" 行を跨いで移動できるアレ
set whichwrap=b,s,h,l,<,>,[,]

" emmetの設定 ctrl + e で展開
let g:user_emmet_expandabbr_key = '<C-e>'

"================================================================
" tab
"================================================================

" | モード                                 | 再割当無し | 再割当有り |
" | ---                                    | ---        | ---        |
" | ノーマルモード＋ビジュアルモード       | noremap    | map        |
" | コマンドラインモード＋インサートモード | noremap!   | map!       |
" | ノーマルモード                         | nnoremap   | nmap       |
" | ビジュアル(選択)モード                 | vnoremap   | vmap       |
" | コマンドラインモード                   | cnoremap   | cmap       |
" | インサート(挿入)モード                 | inoremap   | imap       |

nmap t [tab]

" t+数字でタブ移動
for n in range(1, 9)
    execute 'nnoremap <silent> [tab]'.n ':<C-u>tabnext'.n.'<CR>'
endfor

" tt で新しいタブ
map <silent> [tab]t :tablast <bar> tabnew<CR>

" tx でタブを閉じる
map <silent> [tab]x :tabclose<CR>

" tn で次のタブへ
map <silent> [tab]n :tabnext<CR>

" tp で前のタブへ
map <silent> [tab]p :tabprevious<CR>

"================================================================
" edit
"================================================================

" backspaceで改行とかインデントとかを消せるようにする
set backspace=indent,eol,start

" 単語を補完する時の大文字小文字の無視
set infercase

" 補完
set wildmenu

" スワップファイルを作らない
set noswapfile

" 折りたたみON
set foldenable

" syntaxにまかせる
set foldmethod=syntax

" 行番号とか出るとこの幅
set foldcolumn=4

" 起動時は全開にする
set foldlevel=99

" 新しいウィンドウを下（右）に開く
set splitbelow
set splitright

" 3行分だけ余裕をもたせてスクロール
set scrolloff=3

" クリップボード有効化
set clipboard+=unnamed
