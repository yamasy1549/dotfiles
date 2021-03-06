#!/usr/bin/env bash

##########
# 関数定義など
##########

# -e エラーがあったら停止
# -u 未定義変数があったら停止
set -eu

# コマンドが使えるかチェック
function has() {
    return `type $1 > /dev/null 2>&1`
}

# エラー時はメッセージを出して異常終了する
function die() {
    echo "$*" 1>&2
    exit 1
}

# 今やってる処理表示と段階のカウント
COUNT=0
function step() {
    COUNT=$(( COUNT + 1 ))
    echo "[Step$COUNT]: $*"
}


##########
# XCodeの準備
##########

if [ "$(uname -s)" = "Darwin" ]; then
    step "XCodeライセンス同意"
    sudo xcodebuild -license accept
fi


##########
# dotfilesの準備
##########

GITHUB_HTTPS_URL="https://github.com/yamasy1549/dotfiles"
GITHUB_SSH_URL="git@github.com:yamasy1549/dotfiles.git"
DOTPATH=~/dotfiles

if [ ! -d $DOTPATH ]; then
    step "dotfilesリポジトリを落としてくる"

    if has "git"; then
        # gitの設定をしていないので、SSHじゃなくてHTTPSでcloneする必要がある
        git clone "$GITHUB_HTTPS_URL" "$DOTPATH"

    elif has "curl" || has "wget"; then
        tarball="$GITHUB_HTTPS_URL/archive/master.tar.gz"

        if has "curl"; then
            curl -L "$tarball"

        elif has "wget"; then
            wget -O - "$tarball"

        fi | tar xv -

        mv -f dotfiles-master "$DOTPATH"

    else
        die "curl or wget is required."
    fi
fi

step "dotfilesディレクトリがあるか確認"
cd $DOTPATH
if [ $? -ne 0 ]; then
    die "not found: $DOTPATH"
fi

step "dotfilesのoriginをSSHの方に変える"
git remote set-url origin $GITHUB_SSH_URL


##########
# スクリプトのシンボリックリンクを貼る
##########

step "設定ファイルのシンボリックリンクを貼る"
for f in .??*
do
    [ "$f" = ".git" ] && continue
    ln -snfv "$DOTPATH/$f" "$HOME/$f"
done

step "自分で定義したスクリプトのシンボリックリンクを貼る"
ln -snfv "$DOTPATH/bin" "$HOME/bin"


##########
# Gitの準備
##########

if [ ! -f $HOME/.gitconfig.local ]; then
    step ".gitconfig.local設定"

    # /bin/echoでないと-nが効かない
    /bin/echo -n "GitHub username: "
    read name
    /bin/echo -n "GitHub email: "
    read email

    cat << EOS > $HOME/.gitconfig.local
[user]
    name = $name
    email = $email
EOS
fi


##########
# Homebrewの準備
##########

if [ "$(uname -s)" = "Darwin" ]; then
    if ! has "brew" ; then
        step "Homebrewインストール"
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    if ! has "brew" ; then
        step "Homebrewインストール"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    fi
fi

if has "brew" ; then
    step "Brewfileに書いたパッケージをインストール"
    brew tap Homebrew/bundle
    brew bundle
fi


##########
# Zshの準備
##########

zsh=$(which zsh)
if [ ! `grep "$zsh" /etc/shells` ]; then
    step "Zshの設定"
    echo $zsh | sudo tee -a /etc/shells
    chsh -s $zsh
fi

if [ ! -d "$HOME/.zsh" ]; then
    step "iTerm2, Zshの色設定ファイル準備"
    git clone https://github.com/yamasy1549/iTerm2-gochiusa $HOME/.zsh
fi

if [ ! -f "$HOME/.tmux/plugins/tpm/tpm" ]; then
    step "tmuxの設定"
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi


##########
# その他インストールが必要なもののインストール
##########

zsh ./install.sh
