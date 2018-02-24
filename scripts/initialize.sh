#!/bin/sh

function is_exists() {
    return `type $1 > /dev/null 2>&1`
}

function is_installed() {
    return $(brew info $1 | grep -c "Not installed")
}

if ! is_exists "brew"; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if is_installed "zsh" && [ $SHELL != `which zsh` ]; then
    echo current shell: $SHELL
    echo Please exec
    echo "\t$ sudo sh -c \"echo `which zsh` >> /etc/shells\""
    echo "\t$ chsh -s `which zsh`"
fi

if ! is_exists "$HOME/.tmux/plugins/tpm/tpm"; then
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi
