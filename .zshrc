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
# XXenv
# -------------------------------------

# rbenv
eval "$(rbenv init -)"

# pyenv
eval "$(pyenv init -)"

# nodenv
eval "$(nodenv init -)"


# -------------------------------------
# export
# -------------------------------------

# SSHで接続した先で日本語が使えるようにする
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# エディタ
export EDITOR=vim

# ページャ
export PAGER=cat
export MANPAGER=less

# rbenv
export PATH="$HOME/.rbenv/shims:$PATH"

# pyenv
export PATH="$HOME/.pyenv/shims:$PATH"

# nodenv
export PATH="$HOME/.nodenv/shims:$PATH"

# GNU系のコマンドを使う
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# Postgres
export PGDATA=/usr/local/var/postgres

#Python
export PYTHONSTARTUP=~/.pythonstartup

# Go
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin

# Imagemagick
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"

# -------------------------------------
# zsh options
# -------------------------------------

# 補完機能の強化
autoload -U compinit; compinit
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

# mv をいい感じにやる
autoload -U zmv
alias zmv='noglob zmv -W'

# 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct

# ビープを鳴らさない
setopt nobeep

# 色を使う
setopt prompt_subst

# ディレクトリ名を入力するだけでcdできるようにする
setopt auto_cd

# 同時に起動したzshの間で履歴共有
setopt share_history

# '#' 以降をコメントとして扱う
setopt interactive_comments


# -------------------------------------
# history
# -------------------------------------

# 同じ履歴を省く
setopt hist_ignore_all_dups

# Ctrl+R で履歴 w/ peco
function peco_select_history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | eval $tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle accept-line
}
zle -N peco_select_history
bindkey '^r' peco_select_history


# -------------------------------------
# colors
# -------------------------------------

# 色空間
export TERM=xterm-256color

# e.g. ${fg[red]}hogehoge${reset_color}
autoload -Uz colors; colors

# ls した時の色
eval $(dircolors $HOME/.zsh/gochiusa.dircolors)
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi


# -------------------------------------
# prompt
# -------------------------------------

autoload -Uz vcs_info

zstyle ":vcs_info:*" enable git svn hg bzr
zstyle ":vcs_info:*" formats "(%s)-[%b]"
zstyle ":vcs_info:*" actionformats "(%s)-[%b|%a]"
zstyle ":vcs_info:(svn|bzr):*" branchformat "%b:r%r"
zstyle ":vcs_info:bzr:*" use-simple true

zstyle ":vcs_info:*" max-exports 6

zstyle ":vcs_info:git:*" check-for-changes true # commitしていないのをチェック
zstyle ":vcs_info:git:*" stagedstr "<S>"
zstyle ":vcs_info:git:*" unstagedstr "<U>"
zstyle ":vcs_info:git:*" formats "(%b) %c%u"
zstyle ":vcs_info:git:*" actionformats "(%s)-[%b|%a] %c%u"

function vcs_prompt_info() {
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && echo -n " ${fg[yellow]}$vcs_info_msg_0_${reset_color}"
}

PROMPT=""
PROMPT+="${fg[green]}%~${reset_color}"
PROMPT+="\$(vcs_prompt_info)"
PROMPT+=$'\n'
PROMPT+="%% "
# ずれるので、色指定を %{ %} で囲む
RPROMPT="%{${fg[white]}%}[%*]%{${reset_color}%}"


# -------------------------------------
# alias
# -------------------------------------

# -n 行数表示
# -I バイナリファイル無視
alias grep="grep --color -n -I"

# ls に色を付ける
alias ls="gls --color=auto"
alias la="gls --color=auto -a"
alias ll="gls --color=auto -l"

# N 文字化け対策
# C 色をつける
alias tree="tree -NC"

# treeでnode_modulesを表示しない
alias tree="tree -I node_modules"

# historyに時刻表示
alias history='history -E'

# bundle exec
alias be="bundle exec"

# mkdirで一気に階層を作る
alias mkdir="mkdir -p"

# exit
alias :q="exit"

# gsedを使う
alias sed="gsed"

# treeで日本語ファイル名表示
alias tree="tree -N"


# -------------------------------------
# git
# -------------------------------------

alias g="git"
alias gb="git branch"
alias gcm="git commit -m"
alias gcma="git commit --amend"
alias gcmi="git commit --allow-empty -m 'Initial commit'"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gme="git merge"
alias gmer="git merge"
alias gr="git rebase"
alias gs="git st"
alias gd="git std"
alias gsd="git std"
alias ga="git sta"
alias gsa="git sta"
alias gp="git push"
alias gpo="git push origin"
alias gl="git log --graph --oneline --all --branches --decorate"


# -------------------------------------
# その他
# -------------------------------------

# Emacs風キーバインド
bindkey -e

# cdしたあとで、自動的にlsする
function chpwd() { ls }

# ~/.zshrcの読み込み
function source_zshrc {
  BUFFER="source ~/.zshrc"
  zle accept-line
}
zle -N source_zshrc
bindkey '^z' source_zshrc

# tmux
if [ -z $TMUX ] ; then
    tmux new-session \; source-file ~/.tmux.new-session
fi
