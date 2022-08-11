# dotfiles

## Vim

For Windows users, replace usage of the Unix `~/.vim` directory with `%USERPROFILE%\vimfiles`,
or another directory if you have configured Vim differently. On Windows, your `~/.vimrc` file
will be similarly stored in `%USERPROFILE%\_vimrc`

Note: you need to install Vundle as a prereq

```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

### Changing the config

After saving changes to your `.vimrc`, run the following commands:

```
:so ~/.vimrc
:PluginInstall
```

### Managing sessions:

**Making Sessions**
```
# Create a new session file
# :mksession ~/.vim/sessions/session.vim
:mks ~/.vim/sessions/session.vim

# Overwrite the current session
:mks!
```

**Reloading Sessions**
```
:source ~/.vim/sessions/session.vim

vim -S ~/.vim/sessions/session.vim
```

### Searching
> Leverages `fzf` and `ripgrep` for fast searching

Commands:
* `ctrl + f` to search for terms in files using regex
* `ctrl + p` to search for files

Tips:
* Modify `.rgingore` to globally ignore files/directories
* Modify `.ingore` in a project to locally ignore files/directories

