git clone https://github.com/riywo/ndenv.git ~/.ndenv
mkdir .ndenv/plugins
git clone https://github.com/riywo/node-build.git ~/.ndenv/plugins/node-build

zsh
source ~/.zshrc

ndenv install --list
# ndenv install vX.X.X
