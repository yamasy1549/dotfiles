eval "$(rbenv init -)"

# -------------------------------------
# env
# -------------------------------------

# SSHで接続した先で日本語が使えるようにする
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export TERM=xterm-256color

# エディタ
export EDITOR=vim

# ページャ
export PAGER=/usr/local/bin/vimpager
export MANPAGER=/usr/local/bin/vimpager

export PATH=$HOME/bin:$PATH

export PGDATA=/usr/local/var/postgres

export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# -------------------------------------
# zsh options
# -------------------------------------

## 補完機能の強化
autoload -U compinit

autoload -U zmv

## 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct

# ビープを鳴らさない
setopt nobeep

## 色を使う
setopt prompt_subst

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

# ディレクトリ名を入力するだけでcdできるようにする
setopt auto_cd

# 同時に起動したzshの間で履歴共有
setopt share_history

# '#' 以降をコメントとして扱う
setopt interactive_comments


# -------------------------------------
# history
# -------------------------------------

setopt hist_ignore_all_dups
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | eval $tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

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
# prompt
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
# alias
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

# mkdirで一気に階層を作る
alias mkdir="mkdir -p"

# treeでnode_modulesを表示しない
alias tree="tree -I node_modules"

# git
alias g="git"
alias git="hub"
alias gb="git branch"
alias gcm="git commit -m"
alias gcma="git commit --amend"
alias gcmi="git commit --allow-empty -m 'Initial commit'"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gr="git rebase"
alias gs="git st"
alias gd="git std"
alias gsd="git std"
alias ga="git sta"
alias gsa="git sta"
alias gp="git push"
alias gpo="git push origin"

# cdしたあとで、自動的に ls する
function chpwd() { ls }

# pecoでcd
function cdp {
    local dir="$( find . -maxdepth 1 -type d | sed -e 's;\./;;' | peco )"
    if [ ! -z "$dir" ] ; then
        cd "$dir"
    fi
}

# 手元でリポジトリを作成してpush
function ghq-new() {
  local root=`ghq root`
  local user=`git config --get user.name`
  if [ -z "$user" ]; then
    echo "you need to set user.name"
    echo "git config --global user.name YOUR_GITHUB_USER_NAME"
    return 1
  fi
  local name=$1
  local repo="$root/github.com/$user/$name"
  local remote_url="git@github.com:$user/$name.git"
  if [ -e "$repo" ]; then
    echo "$repo is already exists."
    return 1
  fi
  git init $repo
  cd $repo
  git remote add origin $remote_url
  git commit --allow-empty -m 'Initial commit'
  git push -u origin master
}

# ghq x peco
function peco_ghq_list () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco_ghq_list
bindkey '^]' peco_ghq_list

# -------------------------------------
# keybind
# -------------------------------------

bindkey -e

function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup
bindkey '^K' cdup

# -------------------------------------
# その他
# -------------------------------------

if [ -z $TMUX ] ; then
    tmux new-session \; source-file ~/.tmux/new-session
fi

eval `dircolors -b ~/.dir_colors`

if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi
