eval "$(rbenv init -)"

# -------------------------------------
# 環境変数
# -------------------------------------

# SSHで接続した先で日本語が使えるようにする
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# lsしたときの色
# export LSCOLORS=gxfxcxdxbxegedabagacad

export TERM=xterm-256color

# エディタ
export EDITOR=vim

# ページャ
export PAGER=/usr/local/bin/vimpager
export MANPAGER=/usr/local/bin/vimpager

export PATH=$HOME/bin:$PATH

export PGDATA=/usr/local/var/postgres

export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# -------------------------------------
# zshのオプション
# -------------------------------------

## 補完機能の強化
autoload -U compinit
compinit

autoload -U zmv

## 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct

# ビープを鳴らさない
setopt nobeep

## 色を使う
setopt prompt_subst

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

# cd -[tab]で過去のディレクトリにひとっ飛びできるようにする
setopt auto_pushd

# ディレクトリ名を入力するだけでcdできるようにする
setopt auto_cd

# 同時に起動したzshの間で履歴共有
setopt share_history

# '#' 以降をコメントとして扱う
setopt interactive_comments

# -------------------------------------
# パス
# -------------------------------------

# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

path=(
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

# -------------------------------------
# プロンプト
# -------------------------------------

autoload -U promptinit; promptinit
autoload -Uz colors; colors
autoload -Uz vcs_info
autoload -Uz is-at-least
autoload -U compinit; compinit

# begin VCS
zstyle ":vcs_info:*" enable git svn hg bzr
zstyle ":vcs_info:*" formats "(%s)-[%b]"
zstyle ":vcs_info:*" actionformats "(%s)-[%b|%a]"
zstyle ":vcs_info:(svn|bzr):*" branchformat "%b:r%r"
zstyle ":vcs_info:bzr:*" use-simple true

zstyle ":vcs_info:*" max-exports 6

if is-at-least 4.3.10; then
    zstyle ":vcs_info:git:*" check-for-changes true # commitしていないのをチェック
    zstyle ":vcs_info:git:*" stagedstr "<S>"
    zstyle ":vcs_info:git:*" unstagedstr "<U>"
    zstyle ":vcs_info:git:*" formats "(%b) %c%u"
    zstyle ":vcs_info:git:*" actionformats "(%s)-[%b|%a] %c%u"
fi

function vcs_prompt_info() {
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && echo -n " %F{178}$vcs_info_msg_0_%f" # 黄色
}
# end VCS

PROMPT=""
PROMPT+="%F{070}%~%f" # 黄緑
PROMPT+="\$(vcs_prompt_info)"
PROMPT+=$'\n'
PROMPT+="%% "
RPROMPT="[%*]"

if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# -------------------------------------
# エイリアス
# -------------------------------------

# -n 行数表示, -I バイナリファイル無視, svn関係のファイルを無視
alias grep="grep --color -n -I"
alias gitlog="git log --graph --oneline --all --branches --decorate"

alias ls="gls --color=auto" # lsに色を付ける
alias la="gls --color=auto -a"

# tree
alias tree="tree -NC" # N: 文字化け対策, C:色をつける

# historyに時刻表示
alias history='history -E'

# C言語
alias aout="./a.out"

# bundle exec
alias be="bundle exec"

# exit
alias :q="exit"

# -------------------------------------
# キーバインド
# -------------------------------------

bindkey -e

function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup
bindkey '^K' cdup

bindkey "^R" history-incremental-search-backward

# -------------------------------------
# その他
# -------------------------------------

alias g="git"
alias gs="git st"
alias gd="git std"
alias gsd="git std"
alias ga="git sta"
alias gsa="git sta"
alias gc="git commit"
alias gcm="git commit -m"

# mkdirで一気に階層を作る
alias mkdir="mkdir -p"

# treeでnode_modulesを表示しない
alias tree="tree -I node_modules"

# cdしたあとで、自動的に ls する
function chpwd() { ls }

# iTerm2のタブ名を変更する
function title {
    echo -ne "\033]0;"$*"\007"
}

if [ -z "$PS1" ]; then return ; fi

if [ -z $TMUX ] ; then
    tmux new-session \; source-file ~/.tmux/new-session
fi

eval `dircolors -b ~/.dir_colors`
