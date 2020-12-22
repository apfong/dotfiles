# dotfiles

## Vim

### Managing sessions:

**Making Sessions**
```
# :mksession ~/.vim/sessions/session.vim
:mks ~/.vim/sessions/session.vim
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

