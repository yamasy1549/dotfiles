# シンボリックリンク
for f in .??*
do
    [ "$f" = ".git" ] && continue
    ln -snfv "$DOTPATH/$f" "$HOME/$f"
done

ln -snfv "$DOTPATH/bin" "$HOME/bin"

brew tap Homebrew/bundle
brew bundle
