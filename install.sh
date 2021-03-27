##########
# 関数定義など
##########

# -e エラーがあったら停止
# -u 未定義変数があったら停止
set -eu

# 今やってる処理表示と段階のカウント
COUNT=0
function step() {
    COUNT=$(( COUNT + 1 ))
    echo "[Step$COUNT]: $*"
}

DOTPATH=~/dotfiles


##########
# Rubyのインストール
##########

if [ ! -d "$HOME/.rbenv/plugins/rbenv-default-gems" ]; then
    step "rbenv-default-gems導入"
    git clone https://github.com/rbenv/rbenv-default-gems.git $HOME/.rbenv/plugins/rbenv-default-gems
    ln -snfv "$DOTPATH/rbenv-default-gems" "$HOME/.rbenv/default-gems"
fi

step "最新版のRubyインストール"
ruby_latest=`rbenv install -l | /usr/bin/grep -v - | tail -1 | tr -d ' '`
rbenv install -s $ruby_latest
rbenv global $ruby_latest


##########
# Pythonのインストール
##########

if [ ! -d "$HOME/.pyenv/plugins/pyenv-default-packages" ]; then
    step "pyenv-default-packages導入"
    git clone https://github.com/jawshooah/pyenv-default-packages.git $HOME/.pyenv/plugins/pyenv-default-packages
    ln -snfv "$DOTPATH/pyenv-default-packages" "$HOME/.pyenv/default-packages"
fi

step "最新版のPython{2,3}系インストール"
python2_latest=`pyenv install -l | /usr/bin/grep -e "\s\+2\+.[0-9]\+.[0-9]\+$" | tail -1 | tr -d ' '`
python3_latest=`pyenv install -l | /usr/bin/grep -e "\s\+3\+.[0-9]\+.[0-9]\+$" | tail -1 | tr -d ' '`
pyenv install -s $python2_latest
pyenv install -s $python3_latest
pyenv global $python3_latest


##########
# Node.jsのインストール
#########

step "最新版のNode.jsインストール"
node_latest=`nodenv install -l | /usr/bin/grep -e "^[0-9]\+.[0-9]\+.[0-9]\+$" | tail -1 | tr -d ' '`
nodenv install -s $node_latest
nodenv global $node_latest

source $HOME/.zshrc
