cask_args appdir: '/Applications'

# ================================================================
# tap
# ================================================================

tap 'caskroom/cask-cask'
tap 'caskroom/cask-versions'
tap 'sanemat/font'

# ================================================================
# formulas
# ================================================================

brew 'gcc'
brew 'go'
brew 'lua'
brew 'nodenv'
brew 'pyenv'
brew 'rbenv'
brew 'ruby-build'
brew 'readline'

brew 'git'
brew 'git-lfs'
brew 'zsh', args: ['disable-etc-dir']
brew 'zsh-completions'
brew 'vim'
brew 'tmux' if OS.mac?
brew 'reattach-to-user-namespace' if OS.mac?

brew 'tig'

brew 'docker-compose'
brew 'docker-machine'

brew 'mongodb'
brew 'mysql'

brew 'jq'
brew 'gnu-sed' if OS.mac?
brew 'curl'
brew 'tree'
brew 'peco'
brew 'coreutils'

brew 'nkf'

brew 'heroku-toolbelt'
brew 'imagemagick'
brew 'pngquant'

brew 'ricty', args: ['with-powerline']

brew 'mas' if OS.mac?

# ================================================================
# mas
# ================================================================

mas 'LINE',  id: 539883307
mas 'Slack', id: 803453959

# ================================================================
# cask
# ================================================================

cask 'google-chrome'
cask 'firefox', args: { 'language': 'ja' }

cask 'android-file-transfer'
cask 'appcleaner'
cask 'alfred2'
cask 'bettertouchtool'
cask 'caffeine'
cask 'dash'
cask 'docker'
cask 'google-japanese-ime'
cask 'iterm2'
cask 'karabiner'
cask 'cmd-eikana'

cask 'silverlight'
cask 'flash-player'

cask 'xquartz'

cask 'adobe-acrobat-reader'
cask 'adobe-creative-cloud'

cask 'android-studio'
cask 'arduino'
cask 'pycharm'
cask 'sublime-text'

cask 'vagrant'
cask 'postgres'

cask 'kindle'
cask 'licecap'
cask 'skype'
cask 'discord'

# after mactex
brew 'gnuplot', args: ['with-x11', 'latex']
