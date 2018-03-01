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


##########
# Rubyのインストール
##########

step "最新版のRubyインストール"
rbenv init
rbenv install -s `rbenv install -l | /usr/bin/grep -v - | tail -1`
rbenv global `rbenv install -l | /usr/bin/grep -v - | tail -1`
