export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
eval "$(rbenv init -)"

function cdls() {
    # cdがaliasでループするので\をつける
    \cd $1;
    ls;
}
alias cd=cdls

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# export PS1="yamasy♥ "
