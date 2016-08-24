## Installation

Run (assuming `git` is installed)

```
cd && rm -rf ~/.vim && \
git clone https://github.com/glabo/dotfiles.git ~/.vim && \
ln -sf ~/.vim/.vimrc .vimrc && \
ln -sf ~/.vim/.rvmrc .rvmrc && \
ln -sf ~/.vim/.bashrc .bashrc && \
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
git config --global user.email "graham.labo@gmail.com" && \
git config --global user.name "glabo"
```

Warning: This will obliterate your `.vim` directory, `.vimrc` and `.rvmrc`
files if they exist.


#### Vundle
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    open vim, run :PluginInstall

## Applications
* [Chrome](https://support.google.com/chrome/answer/95346?hl=en)
* [Drive](https://www.google.com/drive/download/)
* [Music Manager](https://support.google.com/googleplay/answer/1229970?hl=en)
<!---
* [Postgres.app](http://postgresapp.com/)
* [Java](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
-->
* [Latex](http://tug.org/mactex/mactex-download.html)
